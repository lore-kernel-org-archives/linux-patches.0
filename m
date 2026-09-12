Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D02F7F17;
	Sat, 12 Sep 2026 15:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225856; cv=none; b=gAG5daYWCF+BAi5HzeUsUJ4r69q/uAswFhZj7J9WHaD6O28Nt6i6hf03VBN+Lz/c9ByNlIMPOwaJADqlWSZQx3dHYp3hMIvlJib7mufbIZqcRGwiqxgWVlk29fEZ0F+PtAGp2S/XUdDNNTMiNGcqeWjfhL+XTkqI3lO2CtrWfU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225856; c=relaxed/simple;
	bh=0/KD1bYcmH04x+kcJmWvD70i9D9Qy6WuKv79sLWirDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezyu7n+hWm87AEyAviMXy8dbLaz+LHrSMsnI9OlGR5gFT2cobEulV/uV3cbO3Pq7uBmUq5k4WkghIV3nZROoyp/FKt5Cxf2Xnk4b0lYxN0usVJ0CIsDTGI1gZu90lcKyaaQS6lo7QGe59sGf1e+iL+jKjR7UHKA7+wv/ET4OSUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptARXOQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptARXOQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56251F000FF;
	Sat, 12 Sep 2026 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225854;
	bh=2JCmvrd1rAkywGABpDsd0igB6YKPTsCAsvToukRdFP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptARXOQ4mkjw7GawHA0ALm4sPgjha1VaN38z8XRaF2yFc8yb7hnerbQZNRTBAa+5b
	 GNDT0O44ArmDtDMMfUevs9HOlXzS7VDphzst8fqzZh+WFZAT+88UL9hALXiPHA82ma
	 Dc9KCHvxHaMfQmR32rkyPJrepSrktnXWLL5DxayA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1284/1424] ALSA: hda: Fix connection list comparison in proc output
Date: Sat, 12 Sep 2026 09:01:56 +0200
Message-ID: <20260912065636.030028976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



