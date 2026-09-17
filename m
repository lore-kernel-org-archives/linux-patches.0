Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1A4F7CA8;
	Thu, 17 Sep 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665459; cv=none; b=WQB8ad3BKGFldFVOGg4XykQs4B9oy+LDAKbXE8I/wtijNALwKQ1eg4+PB7i04yClxevNdGt5+JfMR3wtmHMUZ4wgSQuKuvbJivttpw/yacdo6Zl8+/qII/l1AloRa9NRCUSafj9y4bqrOPrgvGHVbL+ShVmvSOk5gdf0Zbg/HZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665459; c=relaxed/simple;
	bh=I/w4h5N5NwubFZFjXK7CQS/Fdz+hcdXUMNqmn9gzzmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMlG5sx8gFHtRWm23OVq9UzPbKTp0hkQHjRJuWAr5CxanKeJgLrjvaDDpZC6NEli6IrejWXe7ERHMjgP3liG208lLmEnq1HTe+fEo/SDINpNAAk1crDcZcpmhuGtvh9WOz53aEK+qols6iHXi1PZ5AfN2jGPfXKZXJqeBN3lK9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS2YxuDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS2YxuDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7510C1F000FF;
	Thu, 17 Sep 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665458;
	bh=hsPfa+XDJFzM9l2mwkVUA+OFTTpS7WbXrwnlml2k0cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS2YxuDjWiik0zakwa6D0L0zaVgVFauHBwcjSj2Vl3qThNHQEx+qinAPT32zkh2hS
	 xmQ1oX0Y9NKAMOOoG+fxZSlbeYfXXkhxeCFeAo65BNy2JzHv59M4PYcW44Bm6haHo5
	 fTlMNkpeZgWhWcQTQ8TCTVSnsCP2MBd0sEcNd2lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyu Zhang <usupergate@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0711/1250] ALSA: ump: do not touch legacy_rmidi before it exists
Date: Thu, 17 Sep 2026 16:08:26 +0100
Message-ID: <20260917151611.167745051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 0ba253f50b5a5..0e6a7d438d75d 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1333,6 +1333,8 @@ static void update_legacy_names(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_INPUT);
 	update_legacy_substreams(ump, rmidi, SNDRV_RAWMIDI_STREAM_OUTPUT);
 }
@@ -1341,6 +1343,8 @@ static void ump_legacy_set_rawmidi_name(struct snd_ump_endpoint *ump)
 {
 	struct snd_rawmidi *rmidi = ump->legacy_rmidi;
 
+	if (!rmidi)
+		return;
 	snprintf(rmidi->name, sizeof(rmidi->name), "%.68s (MIDI 1.0)",
 		 ump->core.name);
 }
-- 
2.53.0



