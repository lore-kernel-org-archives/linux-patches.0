Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC0515989;
	Wed, 30 Sep 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789552; cv=none; b=ab4RjG3KB+61KMZnhGcl7tOu+abfh6Za6ozD08QrmkIl3yDAPN1fC+B7EpNqicRTc8p/frxZGeuNcKKUSnY6AfrW/nqG2pF4zygaZWkEVrwE63rFzoTXFcMQ1cFBai+Ok8VEc/DK0511GWLQgVXh5NX+fqvFvZCdTo5xRyOSZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789552; c=relaxed/simple;
	bh=seuaedByeuWS0y5QaHvwF4NXwqnhFpaBH7x/QBPloC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt8yYhaMmmthTg/aGgzKVGDJ0kJTBbXl4wxPelZLuypT0W+wHm1GiINtfkPFcaAm9Kmc5rRJYZ6Y4/41JRmYwRNLQ3itzpb75B3AUif7tfzdqTFU2eKrxsegIL61SO/JL74gIBMBwWWeYgJwiI3DMdqrjZYfsh7YULLfQy1REH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpJtDd+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpJtDd+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8E01F000FF;
	Wed, 30 Sep 2026 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789550;
	bh=aFMvfMa1iJtHuN3jWn+l4ChMNlUYb4Q1lopAKvKykeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpJtDd+zfAs+Ly3fcmr7tnEPssUapf6WaSoDoyVkjj8ai3OUoEuLB2MF0zm13Ob8V
	 QN9hVzcPQxGyPgXmXm94SgtfoxddtjDN4NghSeRYHi3DS+LUvzw/dvKTHxtlUNjAtd
	 OdZghyYlq9jfPUa0TQ0l3LdUmHbkBQiCT5e7/uLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 517/877] net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()
Date: Wed, 30 Sep 2026 17:23:48 +0200
Message-ID: <20260930152425.809561467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4932,10 +4932,12 @@ static bool lan78xx_submit_deferred_urbs
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


