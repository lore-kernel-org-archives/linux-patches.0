Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F3032B11D;
	Sat, 30 May 2026 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160462; cv=none; b=MikWxZx3o2RAemhuSF06eiE64rhUUYgXM9SDcu5/cDDrmhBCDCWVjqo+d9++AE4PAajiEr28XWo0LPmTelJYS3SEq43U2oNe9Xlih6k6j7oEpw7XWyfykEN+BUtzdMbQGHDeh3fImlTaR77qxPE2U+X99/vlIUsRbcSmEEqsUok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160462; c=relaxed/simple;
	bh=l3HbycIrWgQqTufLT5oTZ0iW5J2Axu8WmAMAE6wztXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lS2QmDEMQcn9R7vXEU1g3cYUo2YK2RPfVGe1eVmzzxRjMXnYCpImbOBvGNuE+TrhE6Gpb7O+B0sLDDU8jSgEGunlHszE2mxp0sAFPlDriE+37ocTA5xuyaPRU9KsTOVYg1c3lzSo3nQqOX8VN8jVPE7fYi5ZUQWXgn3PQoL/7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDQO7aSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDQO7aSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A12C1F00893;
	Sat, 30 May 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160460;
	bh=gB/c84Ww+xBY8RSqIQ8WXTI9OYtCHF+I98LbDmV0oi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDQO7aSpls5uFVMyl8E5M34nhdJ95F952rsljac0lEWQta5KpHgfCYzuhjf3MP2aD
	 gtzX5ZzclOhZ0eRoCdzogXiSz3vjieZbZhqEwTayYeCBpwU2yd2MbrkNR3y7hAoYWb
	 t3bKXKU9x/bdG4Up6nyXG+X4V9LbzdJb2YAogbEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 304/969] wifi: b43: enforce bounds check on firmware key index in b43_rx()
Date: Sat, 30 May 2026 17:57:08 +0200
Message-ID: <20260530160308.825282229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 1f4f78bf8549e6ac4f04fba4176854f3a6e0c332 upstream.

The firmware-controlled key index in b43_rx() can exceed the dev->key[]
array size (58 entries). The existing B43_WARN_ON is non-enforcing in
production builds, allowing an out-of-bounds read.

Make the B43_WARN_ON check enforcing by dropping the frame when the
firmware returns an invalid key index.

Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Acked-by: Michael Büsch <m@bues.ch>
Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260417111145.2694196-1-tristmd@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -702,7 +702,8 @@ void b43_rx(struct b43_wldev *dev, struc
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43_kidx_to_raw(dev, keyidx);
-		B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key));
+		if (B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key)))
+			goto drop;
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
 			wlhdr_len = ieee80211_hdrlen(fctl);


