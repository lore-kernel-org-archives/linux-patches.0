Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7F0481C2;
	Mon,  1 Apr 2024 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988163; cv=none; b=Ku/ngXMIrCC4WE70aRysjowbtN78pshuIMcO6inE5NPiA1ndmuLNzkR32MNKzeUrZ/9kJWerYhMHOWokxiv4ykwLtGhx2fkNA6zXnPuqZDOYD2iNJk4o1y1d0SsThl0Wowu2BOJMfng/HYKpowYKZdHq1B4eq77e40lll3e3eo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988163; c=relaxed/simple;
	bh=Fi3X9U0nu+gKaTGqr1buLab9mhOiwyLYaBSM4TBs+Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT7tSndj7HcUM3RSj3a3LLN9Bf2mKYB3A29gwovzSVZdZBwgNkFeBb2+F53a8tpKl8dhkt0pm5V5KulNxuklsjqCjbryqcwH84WqdwUx2iSO0KkwVIPLs2ZiLGfqw4ASOjMac7FbIslSk1XVgfY5vxUgHprvmthDiniC1tQFhsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZMxy1r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZMxy1r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30ECC433F1;
	Mon,  1 Apr 2024 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988162;
	bh=Fi3X9U0nu+gKaTGqr1buLab9mhOiwyLYaBSM4TBs+Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZMxy1r+fKSykarDgYwxWeH/nh9PP2nom3iE9QyzDSDVm3AuN/NAOskKIcC88xCuI
	 De6aGwB+HQmmJmScVezzWVa3tgpD/VkxD1k4gb/bhhoC1NerQhMMSuimrJFZWlgHFp
	 7dCOcvS2xvWbUZ1DIgDktalKcPov4gANs8MmPX+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 075/432] usb: xhci: Add error handling in xhci_map_urb_for_dma
Date: Mon,  1 Apr 2024 17:41:02 +0200
Message-ID: <20240401152555.360508632@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 884b0898d9c95..943b87d15f7ba 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1202,6 +1202,8 @@ static int xhci_map_temp_buffer(struct usb_hcd *hcd, struct urb *urb)
 
 	temp = kzalloc_node(buf_len, GFP_ATOMIC,
 			    dev_to_node(hcd->self.sysdev));
+	if (!temp)
+		return -ENOMEM;
 
 	if (usb_urb_dir_out(urb))
 		sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-- 
2.43.0



