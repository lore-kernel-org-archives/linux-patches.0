Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B3C481B3;
	Mon,  1 Apr 2024 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986761; cv=none; b=J0n+ka51Ymn1J5MexwjsefZEK+NceUjMpU8OoN+rUO92bqgz4XJO4MTzs/ZXiNKPP3UUySYbgHRpiOCz4a3zfj/AIHOuWSFeWyYV/ddLKU52IlFhKeHoLqqGr2p22ifE6uiZrfaOy3Hm3Fi+zumreJ/6AsfioDzZju3Hw2iJYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986761; c=relaxed/simple;
	bh=beh/cGdFu2+St3YJ7kBncTGZHpTL/+g0MtBXXgF0se0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta/LMXPm2NtHKw2WTp7cDJMSc2RHm48crj5v4mTsf6k9QZRK735CaZP73DUqNhtQXnS4dfQVLVIjIN8/cuIJWialThAOQFv6DdMkjMj2CM9K8JDup0OrEuQMumPhyrFALr+H9Ok/oYGV49/VDM0gsLMeFvuSJv6UQAo7C1Fvu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IL4OS/do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IL4OS/do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBD2C433C7;
	Mon,  1 Apr 2024 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986760;
	bh=beh/cGdFu2+St3YJ7kBncTGZHpTL/+g0MtBXXgF0se0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IL4OS/doFHjpp9BGsJwARcX88tvQ/lOB+aHhQoUafOgipHEuBp8buBic8Kw4wUYgM
	 lRkSCiDshZZR6lHeJvav9lfP1p4SR4DSMC6iaQ1A3lkSHPWm/JDWDY0gzYx/OuXdzo
	 E6E2bcUfzdXpaQkMS3WSggUkODHq6M2GX9SUB5Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 077/399] usb: xhci: Add error handling in xhci_map_urb_for_dma
Date: Mon,  1 Apr 2024 17:40:43 +0200
Message-ID: <20240401152551.481035306@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

[ Upstream commit be95cc6d71dfd0cba66e3621c65413321b398052 ]

Currently xhci_map_urb_for_dma() creates a temporary buffer and copies
the SG list to the new linear buffer. But if the kzalloc_node() fails,
then the following sg_pcopy_to_buffer() can lead to crash since it
tries to memcpy to NULL pointer.

So return -ENOMEM if kzalloc returns null pointer.

Cc: stable@vger.kernel.org # 5.11
Fixes: 2017a1e58472 ("usb: xhci: Use temporary buffer to consolidate SG")
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240229141438.619372-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 0886829d53e51..afccd58c9a75a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1220,6 +1220,8 @@ static int xhci_map_temp_buffer(struct usb_hcd *hcd, struct urb *urb)
 
 	temp = kzalloc_node(buf_len, GFP_ATOMIC,
 			    dev_to_node(hcd->self.sysdev));
+	if (!temp)
+		return -ENOMEM;
 
 	if (usb_urb_dir_out(urb))
 		sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-- 
2.43.0



