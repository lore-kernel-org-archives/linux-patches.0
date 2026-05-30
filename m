Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1902341AC7;
	Sat, 30 May 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163542; cv=none; b=Dq6hQ3mnUftPgBpfJuOncErVt8bhFmcKKaHeSJ3I5bMpjrzyeELdFE0ezHVKVob4nFSvvqdWtrAvkSTZRjVOAalE3TjDhEeK+QoNHRY2Vhd2UY22lt3loOEt5qLlLpFd8fgX7qqlB9bUYUftmTvNbwGc8O3G5EvlGzi1Bak+uCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163542; c=relaxed/simple;
	bh=VceRoXooi3A8DhLrREjJl7HpS+YipTvenCt0CoJntQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhiVFI6NUp9+VrfXnFgFTkgrLBUDzhQVLJNLQKae71MffAcHckcRUuh2sTcSYwAsHwyVrLJ8JhetJidOvidtscNnSgvbz7BhXuLJMFfR7Jj3wh8+znSaPXDkuBwvu3T5lgIOV+lBb0BmlfDmD2qMZhVb72JVYYrzZJmE4D+06JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHxP9deg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHxP9deg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FA01F00893;
	Sat, 30 May 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163541;
	bh=bekL264DQrxvPL2FlH8sMFutbQUV87MEnUkRiyVgFfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHxP9deg/RmXvF7EYjclgueYkjl1Vd0JOZg7/MlBFoG3+jrv7dtlKiMChqdpSdjff
	 dClhkFcKKgDX7YrtCXhkIwjCAsKNPB7zrVeMz4sQkYFmwNIbQ4+tpRzNjA0Ozwakv2
	 Daj4Rb/EIfTK633dvYPFQQJ/fW1O8R9W3DPLyOmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 289/776] wifi: b43legacy: enforce bounds check on firmware key index in RX path
Date: Sat, 30 May 2026 18:00:03 +0200
Message-ID: <20260530160248.029534673@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


