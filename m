Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F257413BAC3;
	Thu, 23 May 2024 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470467; cv=none; b=sZM/Xe8dmxX9WVaDGn/ONQNcqEpSRKz6A4g0TE+FPyqGmDXKT72Hx2rai9CU4pOmXj3ACOlDMnznTS0lfz7nIKVOACgPMHqC6vgwXH9RM56aIubzDVbzjK0kJluqQ5rRhw2n/adsuIBWFImLI1Z3mNzOpEqer8MBHmGr7lT83N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470467; c=relaxed/simple;
	bh=sccydqczZNIa8sT7CeFOoI7ZVyAZFm3yw4+/fOK6MfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpRvkE6vPQuc1Q8qqPjTug+IjlcSQHDzOlRMZX6D4DWLtjZqc8cGTlfnW3jUxaztZQ9suQ94zoDzSiCdUomkoHuTILnWFv+Vf3iIcxdwaaIGeqUr68uBJgJ1MmpN9qxOefh6lOlQCoLJOGOp30nvCTOVnJ708+QmKiPdTdb05pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPXOnaH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPXOnaH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791C6C2BD10;
	Thu, 23 May 2024 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470466;
	bh=sccydqczZNIa8sT7CeFOoI7ZVyAZFm3yw4+/fOK6MfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPXOnaH2gk8seF5ewEf6t4AjT6xc/+5u9LOnVq6+v1mDxG1slytFYW6P1lT1Xl9fw
	 2HN9JhNcqBQInVyzSlml7ITvuSrxv55nYyGg6iLIDDb8ACCMYvUhF1Xf/ToHVCIDRZ
	 L1w8fYhkSvo+8CZ1YnBD0EQWHEpesaNrw6BzoU/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 37/45] usb: dwc3: Wait unconditionally after issuing EndXfer command
Date: Thu, 23 May 2024 15:13:28 +0200
Message-ID: <20240523130333.893976167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 1d26ba0944d398f88aaf997bda3544646cf21945 upstream.

Currently all controller IP/revisions except DWC3_usb3 >= 310a
wait 1ms unconditionally for ENDXFER completion when IOC is not
set. This is because DWC_usb3 controller revisions >= 3.10a
supports GUCTL2[14: Rst_actbitlater] bit which allows polling
CMDACT bit to know whether ENDXFER command is completed.

Consider a case where an IN request was queued, and parallelly
soft_disconnect was called (due to ffs_epfile_release). This
eventually calls stop_active_transfer with IOC cleared, hence
send_gadget_ep_cmd() skips waiting for CMDACT cleared during
EndXfer. For DWC3 controllers with revisions >= 310a, we don't
forcefully wait for 1ms either, and we proceed by unmapping the
requests. If ENDXFER didn't complete by this time, it leads to
SMMU faults since the controller would still be accessing those
requests.

Fix this by ensuring ENDXFER completion by adding 1ms delay in
__dwc3_stop_active_transfer() unconditionally.

Cc: stable@vger.kernel.org
Fixes: b353eb6dc285 ("usb: dwc3: gadget: Skip waiting for CMDACT cleared during endxfer")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240502044103.1066350-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1708,7 +1708,6 @@ static int __dwc3_gadget_get_frame(struc
  */
 static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
 {
-	struct dwc3 *dwc = dep->dwc;
 	struct dwc3_gadget_ep_cmd_params params;
 	u32 cmd;
 	int ret;
@@ -1733,8 +1732,7 @@ static int __dwc3_stop_active_transfer(s
 	dep->resource_index = 0;
 
 	if (!interrupt) {
-		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
-			mdelay(1);
+		mdelay(1);
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	} else if (!ret) {
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;


