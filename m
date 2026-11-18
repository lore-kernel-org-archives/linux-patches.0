Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049477;
	b=sLE/rbVISxdGRC1Aavm0Dbx5CMPVBnZ237ULh27MKQJd7dB6q4KHT5T9DyAO7AnoDJUq
	 t48uhN6whbC84V8TG6Js/FkyCCPh8qPRtPlbVAMKvdQoSS01nZyfIg7H6r/ztsQ2FOTGd
	 Iu6E/LY94xUQW8uX6VpdurspvKLgxcqzaenWkxT+EB4RYx2/eS8ziR3mMM3RZMzRuOCak
	 gh3oG1DuA6XSzgCxg+424dbduBy9M2qbWajyFQucfuf0o+6TIsuH1Mllg/KO/PI7OGUNz
	 W/PuYGievCYLBQnQV8qZ90c7vG1H7ZlMOCgoeRv6QpEOYR6ECSo0jTKA23KxdZ11YYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8MwOoh32OoRS/Racofb7OK/aoB9FSbcwcojV77cJpt4=;
	b=Ovnyc9wi0m+DUPal8skCRAs3ZjyKuqSndq7yLXVSYbPi1emRL2Cx6G0yYAn9I03YTFw/
	 L+0qajFGr0Hyv2CbB/mckAV88pG7VMpZNdG20Kf7un9W0r1ryt78lVfbrKO9TmsqbztOW
	 pxZ8RiXVmfdvuO8H8u44FKOVl4bYC7zLuveinsR1CDxbeB4BysgyrnD5DogtJlgoFotga
	 NHI7kTXmCVZrsnawDXBreyZbJOLa5ZFaoD5HSuoLKXSlREl9EO3XR62Ma6bXeiILUSB7/
	 Evgljmt15ZDarp5FZhzHF9Nh05LY+9cCFW1btlMZRBWVRxLnpTK+VjbVg3Q9/iZmazQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbiFYcpB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21BB606A31C;
	Thu, 19 Nov 2026 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbiFYcpB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC0A1F000C4;
	Thu, 19 Nov 2026 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049477;
	bh=8MwOoh32OoRS/Racofb7OK/aoB9FSbcwcojV77cJpt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbiFYcpBhQoBqaU25xau43P3TeGSFB91H+n5vbJV3HciMj406Kc8NwUfH3g+4q1/p
	 3s7/UN0JueUlrUfB2o0J4bXGVugtRCERn4tQ9E/euuy0CFBDHVIOjARh39dWyAQHFF
	 5NZMat5WC5yS4xSDscLedN1vfdKltevrnqM47dHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2324/2857] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:55:58 +0100
Message-ID: <20261118150325.212613027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a6913835735469751f56473f5212eb291a4805e7 ]

snd_power_ref_and_wait() increments card->power_ref and then reads
card->shutdown (and the power state) locklessly, while
snd_card_disconnect() sets card->shutdown and then waits for
power_ref to drop to zero via snd_power_sync_ref().  Due to the
missing barrier on both sides, the caller proceeds with shutdown still
seen as false, while the disconnect side sees a zero refcount and
continues tearing down incorrectly.

For addressing the potential race, add smp_mb__after_atomic() after
the refcount increment and smp_mb() before snd_power_sync_ref() in
snd_card_disconnect().

Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-9-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/init.c b/sound/core/init.c
index d164646ab9602..7cd5e08d4e7ee 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -550,6 +550,8 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
+	/* order card->shutdown store against power_ref read */
+	smp_mb();
 	snd_power_sync_ref(card);
 }
 EXPORT_SYMBOL(snd_card_disconnect);
@@ -1144,6 +1146,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
+	/* order power_ref increment against card->shutdown read */
+	smp_mb__after_atomic();
 	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
 		wait_event_cmd(card->power_sleep,
 			       card->shutdown ||
-- 
2.53.0



