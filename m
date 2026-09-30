Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C2951357A;
	Wed, 30 Sep 2026 17:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787880; cv=none; b=bAGfIPoW4HK+lCEVQ/ioA4GCo7OAJxMht68eZQ+HyCDGzjZGRNAP+UX37FJiXrcbwicjZ9mBFkuP9Ko/C+Ypo95y9AwLeZINL5761cxlthkSt1kAcBzOtvC1zgeKX356Isv4cS/uBmTRKBSWw09nb3eUaK+NFRCm88VhrNCU/jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787880; c=relaxed/simple;
	bh=ppnno39wl5Zxn9JZG9JHg83M0o3U5hbQZm3eTS2hTis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0WW7FHYrM+VwU7I1LS+iVa5gddiiLWjAlduBg3lGQ0WuLptaksTY+ol5mM3wTo/n3w5Ye/mPEvtIeKaeSXXLeFaPQGuy98uvF0oXUKVRIFQxJ76aqqng/SzbgybIsuERXGzfC9pB9vIS/YNTQBiuBzS/mJh0y2b1+lxWKqNqvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJda58c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJda58c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C379F1F000FF;
	Wed, 30 Sep 2026 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787879;
	bh=EmIhcVtTr3GyybANw0xdJZLVFVQsnqal2XSITPhIDoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJda58c+CbCgmm3ih/NtRy3pBsB1/3nxUfD6IoVbyqJqa6kSbc1RP0kW6iDgXCoQK
	 yyhHk19v5bprtx1oySY2yIrjBaHFISz+fZBoASx6TyoeHB+8nWZiX8IdETvK2rkfGe
	 VxbfKYEoK0Bq3xuC/NlTaM0CApA9yfAvEvDXXFNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 349/457] net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152353.544951129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 17741334d00bf5ebd37f8c1c36bc9c146a351deb upstream.

usb_get_from_anchor() hands over a reference to the URB, which the caller
must release. lan78xx_submit_deferred_urbs() never does, so every deferred
Tx URB keeps an extra reference: the counter grows on each suspend/resume
cycle and the URBs are never freed when the buffers are released. Drop
the reference after submitting, and on the path that drops the packet
instead of submitting it.

Fixes: 5f4cc6e25148 ("lan78xx: Fix race conditions in suspend/resume handling")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917115811.2150119-1-vulab@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -5239,10 +5239,12 @@ static bool lan78xx_submit_deferred_urbs
 		    !netif_carrier_ok(dev->net) ||
 		    pipe_halted) {
 			lan78xx_release_tx_buf(dev, skb);
+			usb_put_urb(urb);
 			continue;
 		}
 
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
+		usb_put_urb(urb);
 
 		if (ret == 0) {
 			netif_trans_update(dev->net);


