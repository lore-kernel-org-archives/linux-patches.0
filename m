Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D62DF73;
	Mon,  8 Apr 2024 13:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581402; cv=none; b=k6zvxbHsVlzpEiw/OU8/GLGwuSjm0swOX+9ig5QdXnDTbQNWJ2SQYUj68RU7bQdRdAerHs+JT9gwiYI/ewZrMHd+NU6WjloCuILWQbuWfEmVS4cZpewXby/ignXDjdgqWtk0JX99P5oNocMAqMej10KODU3Pm3wtoTLudjKOznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581402; c=relaxed/simple;
	bh=nq55zSlykl5n5Pd6USumRM8AY501BrOskwBXn+Ofn5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAit6r+88+LUSuDY5cM9BbhG1a1sg5tVYotFsG2RE7UKP29Fg7cHilSHnXTEtf/nnJE5IOpnIgUkfrsNwh5LsmXh726WEk5BrOmVDQjdYM74LdK6R/QFiWSwJg0X8PoIOza25izcaWHHKmIBwP7cqIUrhvB+yV1LYPk8jkMccmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBKhkEyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBKhkEyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBB4C433C7;
	Mon,  8 Apr 2024 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581402;
	bh=nq55zSlykl5n5Pd6USumRM8AY501BrOskwBXn+Ofn5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBKhkEyTSMrLsdQqFMHmntSwORaxwtnFDqf5BrA+jlhH1GkSeSkbuqk7/uHCk7VSM
	 YpFEzPYUPVmj1a7cRldmlSHpaI/kSUMl+9zpAdaei63ISuIivlKGYdXKjMutydBkG6
	 Uw2565Wy2oVcFtxrgAnGzrVjINYJwJ+cTpdowjsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/690] usb: xhci: Add error handling in xhci_map_urb_for_dma
Date: Mon,  8 Apr 2024 14:48:31 +0200
Message-ID: <20240408125401.159843243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5c9d3be136d2c..2539d97b90c31 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1324,6 +1324,8 @@ static int xhci_map_temp_buffer(struct usb_hcd *hcd, struct urb *urb)
 
 	temp = kzalloc_node(buf_len, GFP_ATOMIC,
 			    dev_to_node(hcd->self.sysdev));
+	if (!temp)
+		return -ENOMEM;
 
 	if (usb_urb_dir_out(urb))
 		sg_pcopy_to_buffer(urb->sg, urb->num_sgs,
-- 
2.43.0



