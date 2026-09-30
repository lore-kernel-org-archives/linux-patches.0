Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E653DDDA1;
	Wed, 30 Sep 2026 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795115; cv=none; b=odF+NNSPq/gLN1UjzOCuSwCzbYznCIRSXolqUYpjFQg1+4aXbjqBkZvb5Ku+px4xTLsF3fJdEQFh1lZjQyogBVBYZ5tWSmEmzSuichCiYQQGJEESI4+IYJ+aSllaOmgGws+qYGapLgXEudVT53ktOeGhrAArgYpicJ/cgie4gt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795115; c=relaxed/simple;
	bh=mih4/EQWz6sVrs8zUrOo3uOfr1HUmtXo4L4gUVu+TsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvD/2ywUJuP5KAgfC0WQaBlVlgjRKaZw1hu8gH+NtxegGRvQr6HcDCx67Cpah5AryiDLMWMe3OrcY32LdkRdvyYP0076baK7QjNYxHyW1wbu3x+Ph9GXWyu4HRq5fUXirjWeV8aW6bFUI9IU5joLS1Yk0WTXhCM9BOqOaC/EYSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9E5LcuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9E5LcuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8232A1F00899;
	Wed, 30 Sep 2026 19:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795114;
	bh=qIyBG4KknZZQMu5mmCXUbpXP/csmJV1YbKNpHrOMnmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9E5LcuYQVztKyQONTn1QbKKNxsR0yFDY+FWcR2mhWF0XeQOPlkwu4g/PykafDcZ3
	 gLVVooPKjzpEHx0i3DIGR2uaWAyqao3aW9k2BU4hTSoWo7brnurQrne+m78EBMy8K+
	 v/gYmfcpVWzKmNk7bWvqlXpo/El2a1Q9MBuUrfZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyu Zhang <usupergate@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0448/1193] ALSA: ump: do not touch legacy_rmidi before it exists
Date: Wed, 30 Sep 2026 17:18:52 +0200
Message-ID: <20260930152444.132940251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Qingyu Zhang <usupergate@gmail.com>

[ Upstream commit adeee7187694719890aaffdc14b7e89cfd736f1d ]

snd_ump_parse_endpoint() sets ump->parsed on every exit, including
error, before the caller attaches the legacy rawmidi device.
ump_handle_ep_name_msg() then treats parsed as "legacy_rmidi is live"
and calls ump_legacy_set_rawmidi_name(), which snprintf()s into
ump->legacy_rmidi->name. If a UMP packet arrives in that window
(IRQ path from snd_ump_receive), legacy_rmidi is still NULL
(KASAN null-ptr-deref in snprintf).

Guard the legacy helpers. parsed only means endpoint info was
parsed, not that legacy_rmidi exists.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Signed-off-by: Qingyu Zhang <usupergate@gmail.com>
Link: https://patch.msgid.link/20260902073918.880245-1-usupergate@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 2b6c16d3afa4f..70c74207b6c0f 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1305,6 +1305,8 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
 }
@@ -1313,6 +1315,8 @@ static void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
 		 ump->core.name);
 }
-- 
2.53.0



