Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C133D9DC0;
	Sat, 12 Sep 2026 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211678; cv=none; b=EosufYRnu9qQ53/NQfvjiE8QMIpHjhOoeLntBlqAp9MhEfYn1ogXtTjKDmowSzpkUOXAuBaHFx3MUb3C6TtXjiu5Mdv2q7UVrz8Wn8OlaVoDFc8K5ggiXIyzcVgyHcKCV9sGKYMNBcAkABGfJzWi5uxKWG2muwuTuKjE4+l8TJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211678; c=relaxed/simple;
	bh=/wc6U0JZaab2Cal5P9NOZs7MvIecX4grbsVoa2k9XoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXesuXAN4Jr8xo/+WhisxKf+y87r+Z/EvJECagCLyyaWUq0l/qAUU/H3Dm24ZyZXnsiJRb/gbmb3iwm0ekGWCPZ1J5VykUfIA6gVLyR+hvGX/Jg67VtPnCgmzTzhV8lY3qy5jQB+6RJpeCruv6mgrOcdJhfs/zBFbMpjxa+iD34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNH9hG/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNH9hG/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D4C1F000FF;
	Sat, 12 Sep 2026 11:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211677;
	bh=8HRFcqcMvfkWOez3rFYtDBlal27mVaeDa2yt5X+sEaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNH9hG/fSKqisDdbMZN75hytt1IUKgfce67Fkt0gEOs2TRAHV0RgIKBuKkbzOeNwb
	 U2LdsrfvA6dLX6yRPGNIzpHvMe9OS7JB7HyulCs/MQcjARzoODeR5uUWU6+rq1i0SY
	 7rq1eXMbOcn+GnUSE92dmtTNRGG/hlL0noa2Mf8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1278/1518] ALSA: hda: Fix connection list comparison in proc output
Date: Sat, 12 Sep 2026 08:57:27 +0200
Message-ID: <20260912065652.424355020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 5f3f61519ba64..2d26b4305bcc9 100644
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



