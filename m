Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E352D2B1;
	Thu, 17 Sep 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659209; cv=none; b=AH4RX07mhhO4dvjPoahElj/VntJKQ3RMBSRbGj1iSb/ya0zGGaVpeyEJ5LawSa3tyZzxtCleijKGruhgMdyk5IakD1oCLSRDoclauIB9LalnNnotmp9bIlr8mdssV+U3tH4d0qRlb13wmMDaMUGfR+hTTnrTnzpAl5mCWmm2nIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659209; c=relaxed/simple;
	bh=xuW1Gd1G1tEWgmYZ6dpvlDWuZbK3xiStyzJjijC1Evs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUFRpslpF+JjVZ48c0OAGnjVZUOvspFqyhAkBqjpC/PBMHIb9gPX5q1uOmu+W32dtZVuXzWlfYdJn6qRz8fuUI+pOdHNW8F85fktyTS6ePvNPpD+JhJC3i5t3H6zUfpyPMZgSDkxcHwzbSig4AdeqEiN7q+OOMD+ZoaQAcU0K8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7sF29iO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7sF29iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36471F00893;
	Thu, 17 Sep 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659194;
	bh=GpVhOrok2EJ40BQU/VRIEP28mWhLev0mybAqbFMsTD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7sF29iOm5mVRLG7mjQsPZiEfZN0f0lthcSLqR2Llf8v0YL4ZZOPVC0ffHbvTKlHF
	 NwyfNXwCoqK1qjgMi8n0cyHH+Dp3eEuTn5nX5OhyG0IO9QrDz4FJmMV/zLdsjoywsZ
	 Ok3tlrkoQBPlnS+z3oeQRNbraJUACa2e00vu6R3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyu Zhang <usupergate@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 176/733] ALSA: ump: do not touch legacy_rmidi before it exists
Date: Thu, 17 Sep 2026 16:08:04 +0100
Message-ID: <20260917151355.498785656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 632c13baf21e1..a85d1006e7a51 100644
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



