Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF6D501285;
	Wed, 30 Sep 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786720; cv=none; b=C9eNDuUDQYaLqKroP5eawdJztA/r6W+W7sGG2DPz8nam7vHaotum0X5WwXiAxteawPPlcUxLw8q1FlxUjO0AuWJSxgMvlFzeNebe6O4uWmB4QG1/2biX2jTp0/BEIwMj3Bco3Mt1qbM/fy7Q67Cqj4nhB1kqs2YLRkF1AE4DXHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786720; c=relaxed/simple;
	bh=Io2sH34QJc865qXA5fnfQkL0HxKSQDsJSXirmPbrKrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF/BACN1rQ6dpGIERuqynRxP93Q1Yqys8rGjvVofQAf8qhoS7y7CBmh0stBv34TxY7uofm1ErW+G622PlQV2uDFZsZD9S+9W/VeeDeAjkh+DyzFKlHJTSR2FeoDmBPmh6SSMlVYAQ1O6qj4zoGimqeyuuX0bHVB35dLdoopnzhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GP/92zOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GP/92zOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6646C1F000FF;
	Wed, 30 Sep 2026 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786718;
	bh=Qvkly1eabY5PS4vNfUMGmk6nJb+sXYresTZzthYcRSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GP/92zOxsPNvX2d0pSjekf/1lZ38UFm942x3LW9jrq5oMeZ4qrtO4F69Ni+Zajo8/
	 BeCil95q1i61xy9NTBsGL7/9Ny9+gpHylA0wqhgiLRi8W5PVmTcdgdk9Av8NnhqwQp
	 aWedK/YBQG0gwRwiI6zjFlUntN82M+IChvAYFTdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 960/982] net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()
Date: Wed, 30 Sep 2026 17:28:16 +0200
Message-ID: <20260930152437.359670686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4935,10 +4935,12 @@ static bool lan78xx_submit_deferred_urbs
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


