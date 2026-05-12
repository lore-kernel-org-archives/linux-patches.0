Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F63C8C7D;
	Tue, 12 May 2026 17:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607782; cv=none; b=hgHKodeItvdC3bTLB78BjUqbI1kxMngjP3UpEEEZ82QT4l4XUapVLwSx4tHtylLkGCgKu83b/4J+Cn8KIB6qAi/oFFG6sEuYNuOijHuBR5+91ba0Fhs6vx/VGK7VK6lA1pHuWGBT1jUGqw7xooL5XSxKTmYcjuVKkZBuUZzmUVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607782; c=relaxed/simple;
	bh=U5HOzjreQPvHXIy010Qxm0Asmr7ryZHq7Ex2uFScbTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTyoi+Vw8emWbSB3Kj6bzsWM/ukXAOhbQuyaO+HCK1fXLRSAn+kDjcOeiLHcgI7dvKnsxKy2+h7jm2c4KIBKl+8N2LLQ1TCOFOIKEyKlbTsHa6LDZJZp+/ku1KaBxZQ+Xe1YvclUNdbD/KrnLzlvrmxqMwg+uL6h11utOH1rvFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPoU49xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPoU49xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C9C2BCB0;
	Tue, 12 May 2026 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607782;
	bh=U5HOzjreQPvHXIy010Qxm0Asmr7ryZHq7Ex2uFScbTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPoU49xd8ZDtJzaEBCE/Wj+EgStJiZuIziVTMhGOVfdxxfZ7whGloEOj281SzL1NG
	 9+hmOe4P92WyHw1+ByNGHO2a/Toaa5iyeILv5mMNN7iD6npIEqrrjlCXmuwAeQHmJp
	 Ayb+JhIqX3sKOaU4rVPTdguRN3QJG43wgZmSKVkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 033/206] wifi: b43legacy: enforce bounds check on firmware key index in RX path
Date: Tue, 12 May 2026 19:38:05 +0200
Message-ID: <20260512173933.531331819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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


