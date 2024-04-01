Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169661E86C;
	Mon,  1 Apr 2024 16:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989514; cv=none; b=Z/EFMWznAM/juSCKbT8wSsPhV6OOZcRh/J5j3Jf8r0+SdL3SG8t9nhJETBDbfsmH/I4AHbOFYPu8+JvsayrlaPQmjeqh7bu3ArYv07XJA0OW4l1YyvWOPFfGERKDwyexWIyAhzSxbnp2xnTO5o65KF3BwMWv5ZiNmagStXe+iFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989514; c=relaxed/simple;
	bh=SNNNLjZDS0vBVrj3wWGYwdqNEK/CSh7KX8mo4uSzbO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHwmbpoOYsKf/VQIBbviDT9nUMNh1lnM8O1Tv46przj5gVbUHm5gTcg9866LlmVdAB9fig8MZdyyMp+rXqImXGoQ+NJUzCuKe5/KI2hru0G04kl8+7qbwiVGg0VyC/wBOiq6TG/3taxnIjOO2ZuSqJkxIF650M4K3aKNH4dbrrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THDhhVWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THDhhVWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC2CC433C7;
	Mon,  1 Apr 2024 16:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989514;
	bh=SNNNLjZDS0vBVrj3wWGYwdqNEK/CSh7KX8mo4uSzbO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THDhhVWxKIRGIPpEtXz1BeqZj/GiKtQ3xIvsa7Zlm+efo8nYpythKF5On3U9cv0pp
	 dFVftKv5vk9aNCw2diGqYkDANaVsA2sgx9ViIbfYOQl+MaHfdBBBMEgD3z1CAGIxdR
	 7sm5S84/OGOxiIjxNXg83fErM+uEP3mAez+O4MAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/396] usb: xhci: Add error handling in xhci_map_urb_for_dma
Date: Mon,  1 Apr 2024 17:42:01 +0200
Message-ID: <20240401152550.066947077@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 132b76fa7ca60..c4c733d724bd8 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1178,6 +1178,8 @@ static int xhci_map_temp_buffer(struct usb_hcd *hcd, struct urb *urb)
 
 	temp = kzalloc_node(buf_len, GFP_ATOMIC,
 			    dev_to_node(hcd->self.sysdev));
+	if (!temp)
+		return -ENOMEM;
 
 	if (usb_urb_dir_out(urb))
 		sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-- 
2.43.0



