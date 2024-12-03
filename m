Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030701F754A;
	Tue,  3 Dec 2024 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239932; cv=none; b=gJAtpo+I4QqgcOvswWmZ0gJTO4x33ok132yhnAQZYYzBMSjhUWvSnKu5zgz0KWtN8knzVkyqqcKlSNO+dj/F8TBxrEoO8EKjROetEJVbe8/SB3Juc3jZCY7Hgn+Aay4ftxxcIee+acwwCN1qnN3bQ3++LJan4TIolcou/OHbTQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239932; c=relaxed/simple;
	bh=LtxPBs0DiyTl0eA05M0Rqe0BCYtlB6C9NzxMYf0Qv58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdk06mcNqi24CiZs4lwAaz8Pd7C594yVN7XjQUTJNDPw/e1cjjtpzcMKtbyv0DnrDlwH7wE//SX8wouhPDpsBtadcBu8w38aZeeNHtBNasPQqRhrCZaKQZhzcb4MaGNwoyAzrvu8z97Sc7Joyq/m2i/QyjUguTh7TvGqm4LTVWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGaDQR8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGaDQR8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC5DC4CECF;
	Tue,  3 Dec 2024 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239931;
	bh=LtxPBs0DiyTl0eA05M0Rqe0BCYtlB6C9NzxMYf0Qv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGaDQR8PTljUcSBDz3v8s3mg+0cK7NNqiuVkz65CY0A3AmYYVoaSKrQiM+edyrAFi
	 +erRCTgzK1Cvm8Gmqp0X+kDW/yb9Bfxxf5siAFveO2w++lPDX1u/nIqhvuSwb55AHC
	 A4zqUImqD9CU6cuS8HE2/vMj/JpHwGKcYap7aMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.11 752/817] usb: dwc3: ep0: Dont clear ep0 DWC3_EP_TRANSFER_STARTED
Date: Tue,  3 Dec 2024 15:45:24 +0100
Message-ID: <20241203144025.350477031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 5d2fb074dea289c41f5aaf2c3f68286bee370634 upstream.

The driver cannot issue the End Transfer command to the SETUP transfer.
Don't clear DWC3_EP_TRANSFER_STARTED flag to make sure that the driver
won't send Start Transfer command again, which can cause no-resource
error. For example this can occur if the host issues a reset to the
device.

Cc: stable@vger.kernel.org
Fixes: 76cb323f80ac ("usb: dwc3: ep0: clear all EP0 flags")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/d3d618185fd614bb7426352a9fc1199641d3b5f5.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -232,7 +232,7 @@ void dwc3_ep0_stall_and_restart(struct d
 	/* stall is always issued on EP0 */
 	dep = dwc->eps[0];
 	__dwc3_gadget_ep_set_halt(dep, 1, false);
-	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED;
+	dep->flags &= DWC3_EP_RESOURCE_ALLOCATED | DWC3_EP_TRANSFER_STARTED;
 	dep->flags |= DWC3_EP_ENABLED;
 	dwc->delayed_status = false;
 


