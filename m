Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D45447ACE6;
	Sat, 12 Sep 2026 13:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218760; cv=none; b=o2h0yeYKg5EOKujXMeJXypUrZv5+qxfujLIhMSulBObMTPSSnBl3HDhgAS2Mj7Vzgvux4/J+DRVEDz0Kcd+nRZ0Rr2amF7Yr+8sDSjXj/ISp29SHJV1UNxv77DnSoB3KM++9zIMhIbWTr2ots6tZsj1w9RJAjcVsajsThWL1fIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218760; c=relaxed/simple;
	bh=h4ECO8ckZ4SGhzz3YsKgzUWs1qz6a4+lhUeQvQYPj98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3Lyo0PzPzdedOXT1S0/nJfv087X1RRJ0HnpzKbBjFZyVC7refUXrwkyzfq6QlVdTwq0MK/tfwROD61+mcC0FqNQG9eY9gxR4LPCIqIB25m+EWIV8leT1R37IZzTDFlkn8kFwebqjanxSzno5tgC+6tZelsOOyGorkJVimoG5V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syUQvuJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syUQvuJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EDC1F00893;
	Sat, 12 Sep 2026 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218759;
	bh=kyQ8K+eSca89YvnBVO4hGaSi2RrX5jufp0FWbWiQ4nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syUQvuJvHHsYZMyxWjNKORrLYsaK4n5d8Krq/BxqzDRIzzM51+lIkbZogdh2OZP8g
	 JrkUqAuegWIXDlhsxwoMa04JFRT81TNMqH055hZCrIZGbxWolYTX7Rk98JWNNZ3sjZ
	 DIWfJbGaQhnlgS1KtJVomV15p70+uO+E8oj2L6Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1212/1376] ALSA: hda: Fix connection list comparison in proc output
Date: Sat, 12 Sep 2026 09:00:38 +0200
Message-ID: <20260912065634.563116388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
 sound/pci/hda/hda_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index 00c2eeb2c472d..e8a4cf3c84d82 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
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



