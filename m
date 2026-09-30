Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF9151AECE;
	Wed, 30 Sep 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793536; cv=none; b=JRjOAjcMu47rJBy5WAYCOFHOaeQWI8WyneMsFxa1+ieV3+NPY2PiTTnxSPTH3D3/ecdtTZWltOnMMn3Rxph8GiowTGKGv60dyAKHHfQmdX5KTZ8FJmGrIbM+ovUQNhc8tQRm5vz37nT2q17rZuF0CmL5eO0+5QKlK6MV8e5S4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793536; c=relaxed/simple;
	bh=ulHf0n/L/EKGw8z5yeU8z0dD9kn3I0NE86REu2N2WCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbW40SzlvwooSwKTJMbpJAJv76Orfwwy2qvVeA8B6/Rjrx57jX3STybECLotobLvbNpPcmMege2CHo/y0WjjLIjXXg954wiLaS0fsOuzGeiaKFdbwdLrb4ScY+4W8qI3y0XL+Jy7zNX5SDK1x5f6AF2HKwplWOWx+R6G89WcP6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewgiI6Gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewgiI6Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C61F000FF;
	Wed, 30 Sep 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793534;
	bh=B9vcnE13mOAsFutbRYj3oUr2iZd4jESXIC0GWphp8lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewgiI6GhWC/ifdfRF5gyGrFhxTKOLU61dbs6OvaAVPttvg4llVLUbmnrrBbJBk4kW
	 dTUy3IqLO0ECmpADqrXXcukVLdcLKnfU6W2LCRQgAJoOnDynAB+kkOsQRfd9YJIY3b
	 oIYZF8tfNy7v1VfJsDwLrTVwyw1WQhmg+17jTiQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 289/395] net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()
Date: Wed, 30 Sep 2026 17:29:11 +0200
Message-ID: <20260930152346.928500427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5246,10 +5246,12 @@ static bool lan78xx_submit_deferred_urbs
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


