Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC01B32F770;
	Sat, 30 May 2026 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166001; cv=none; b=flLMiy63h52yPpp4aJQOWFoKb16PvyfTMnhE+DOzsFGnwktaBUZCrLIVw0iDyyYgKO0jNB9Merh7PyZt6R5/jHryZVvFh6i9EfIXG6DFdPpTkOsZyxIKjYfCINTyuV81gyKWjUEdRhJZBuyCSXr3D3RslfHbIGEG4sghCHuCZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166001; c=relaxed/simple;
	bh=CKypzkwOFLVsCzUKxKjhGrlMLSAjDdH9Ls/xoTaY1zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pndf/2cMzAjYwl7ttSGA+JnCQdaK0pgInPnx2YHGRJ1zIG381qbSiHYNyTW4DCI0tri1HC3MtWv4TcUB1PbNkSM3PITX9BjjggDiNqnR1QOH8Ojnyv38lllupAKrV0ewoszZzsjovOrHl0C0aPnn2KYwItmu1g98f+sxvYDG98Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FR+v+hS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FR+v+hS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3611B1F00893;
	Sat, 30 May 2026 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166000;
	bh=eV7SMFzF4UETOPzu8FiVVv6BzaXj/+nbKNz7d9lOH8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FR+v+hS4j/udQtjfxgI6EGxLQDSiuYBEGkFQ4aFQtWwmuQ+1Bdm5fj9ixa8RdOnbx
	 BX8Exppz8RcTYtTFVcRjL30fsxqvoxeGs64rRWCuVjzSbsbtXwaOy7nBAoPXSyiWO2
	 82BD1MRIbFY5pJUogp/i/IrqtfcXbkmJq3y8q26Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 216/589] wifi: b43legacy: enforce bounds check on firmware key index in RX path
Date: Sat, 30 May 2026 18:01:37 +0200
Message-ID: <20260530160230.650984336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit a035766f970bde2d4298346a31a80685be5c0205 upstream.

Same fix as b43: the firmware-controlled key index in b43legacy_rx()
can exceed dev->max_nr_keys. The existing B43legacy_WARN_ON is
non-enforcing in production builds, allowing an out-of-bounds read of
dev->key[].

Make the check enforcing by dropping the frame for invalid indices.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260417111145.2694196-2-tristmd@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43legacy/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -476,7 +476,8 @@ void b43legacy_rx(struct b43legacy_wldev
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43legacy_kidx_to_raw(dev, keyidx);
-		B43legacy_WARN_ON(keyidx >= dev->max_nr_keys);
+		if (B43legacy_WARN_ON(keyidx >= dev->max_nr_keys))
+			goto drop;
 
 		if (dev->key[keyidx].algorithm != B43legacy_SEC_ALGO_NONE) {
 			/* Remove PROTECTED flag to mark it as decrypted. */


