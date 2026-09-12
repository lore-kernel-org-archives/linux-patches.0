Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C93377A9A;
	Sat, 12 Sep 2026 09:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204314; cv=none; b=GvkHnzlmnXfSYvyeLpqbEXTagc57HV+3iPvVgSaltpY81S35+vfWMmlgYEtHv3yoKSpGlZ85y1eoHE7OOGIYPCAy5N4R/z1SAzYQ37+4iAIhyz3/oke9YDDq1a0VRVxQDYP9QrStWcts1sIy+0l+sioPJ7i0/adrCySsHlC4x4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204314; c=relaxed/simple;
	bh=5KXwUtQjgMYD2yD6jk6gu3QRjF+zOsNscy1i32K0cfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/0fHDrBTXyyhzMKFo7extPh+OFaL6PxB7TE04nttkItnwv4U0HivRFIMMXHQ+TaNN+xE0PWLN/j1qEJ/8UJaQ92FPTq5opmOlSmMnc9GZ+xCnzwh+HbC91pOg6PjQ9Qe4Vn1INoJPQXytWtUXWAAn78KypxhyqNJ2Bg1tRIpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyKtOIfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyKtOIfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB51F000FF;
	Sat, 12 Sep 2026 09:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204312;
	bh=tn+6Dl/8rmKnrEKDGIpgyPrJs+GMvzOntOZSYHqEcZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyKtOIfjE8WdWfcsvIuehKm2ZwMFtu/KG/5osfqAaVsWW+OYZ66eMC/iPnaTkxZC9
	 r8t+044jsFQCGloHmayLtowdSQWyJCb/B5uwEtopEyR/MCzzofEzBR5d+/NbYGMVSf
	 BOBmpZNA2jybgEzynMejnQpBa7sGniqF/Dx6tyMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1586/1815] ALSA: hda: Fix connection list comparison in proc output
Date: Sat, 12 Sep 2026 08:55:36 +0200
Message-ID: <20260912065726.222091303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit c139e7e44f58a6f8ddc9d850ea9924d34963b5da ]

print_conn_list() compares the raw hardware connection list with the
connection list cached by the HDA driver.  When they differ, it prints an
additional "In-driver Connection" line so that /proc/asound/card*/codec#*
shows the topology actually used by the driver.

The comparison currently passes conn_len directly to memcmp().  However,
conn_len is a number of connection-list entries, while memcmp() expects a
size in bytes.  Both list and conn are arrays of hda_nid_t, which is u16,
so only half of the connection data is compared.

For example, for two-entry lists such as:

  hardware: 0x0c 0x0d
  cached:   0x0c 0x0e

conn_len is 2, and the current comparison checks only the first hda_nid_t.
The lists are therefore incorrectly treated as identical even though the
second connection differs.

This can happen legitimately when codec fixups replace a cached connection
list with snd_hda_override_conn_list().  The codec routing used by the
driver is not affected, but the proc output can hide the overridden
driver-visible routing and provide misleading topology information during
codec debugging.

Convert the entry count to a byte size so that memcmp() covers the
complete connection list.

Fixes: 8b2c7a5c404d ("ALSA: hda - Add In-driver connection info")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/7B802A4E225CC808+20260818083808.2735120-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/common/proc.c b/sound/hda/common/proc.c
index c83796b13d3de..3dabdb418c7bf 100644
--- a/sound/hda/common/proc.c
+++ b/sound/hda/common/proc.c
@@ -624,7 +624,7 @@ static void print_conn_list(struct snd_info_buffer *buffer,
 	/* Get Cache connections info */
 	cache_len = snd_hda_get_conn_list(codec, nid, &list);
 	if (cache_len >= 0 && (cache_len != conn_len ||
-			      memcmp(list, conn, conn_len) != 0)) {
+			      memcmp(list, conn, conn_len * sizeof(*conn)) != 0)) {
 		snd_iprintf(buffer, "  In-driver Connection: %d\n", cache_len);
 		if (cache_len > 0) {
 			snd_iprintf(buffer, "    ");
-- 
2.53.0



