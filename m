Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468215E8B;
	Mon, 30 Dec 2024 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574260; cv=none; b=oLw80L5m8AFbQl41xDIssZ+GuJpEilPYVlHGwEneZ1JJrzNR+vKQcxY16WiycoXEeWfhV7ElRN0IcJBnkmrgVayiUdQYYrAJaqLMMHrQmGAMLc0a8ILuP9fD5qbLfcO1rTuWz3QfCu0gLfF4vZvQATLHJBDeKHpqBaQO873OdqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574260; c=relaxed/simple;
	bh=8TyJC5LP8FIK/ueSwWtfqree6wDbH2bCOSXOmlKVYLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3BC4l/5ig2R4Afgwi3rIllAyj5C4c+uKZIwY1ZyiD1/1LDaVmB85kpErsG9Io79bc/V68V+G6BS+m9FldlVyWmnHEy6GKqGQqbnUcGl9Bf8zUAudyyCIN9yVI/Hcz3MUYx5JR9e2OhYNYaexQbJHuh2/+rwDRhjbCcbMlxR308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2QA95Y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2QA95Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F48C4CED6;
	Mon, 30 Dec 2024 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574259;
	bh=8TyJC5LP8FIK/ueSwWtfqree6wDbH2bCOSXOmlKVYLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2QA95Y5gNth87kAPGwtA3lW55SQHMAvrW/MIrUXgvkgGEUdwmT1McOubaC//4fjN
	 Y29MnMpqKy/pl76Lp7DpXxnbk/1OVl3zLvXt47knAcjCejDPgxznOA30ck/Swan2wF
	 sKQ+BnBOkLNDd6NgY2LTmqsv3199m/e1ifBQbPvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/114] ALSA: ump: Dont open legacy substream for an inactive group
Date: Mon, 30 Dec 2024 16:42:51 +0100
Message-ID: <20241230154220.152561935@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3978d53df7236f0a517c2abeb43ddf6ac162cdd8 ]

When a UMP Group is inactive, we shouldn't allow users to access it
via the legacy MIDI access.  Add the group active flag check and
return -ENODEV if it's inactive.

Link: https://patch.msgid.link/20241129094546.32119-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 8d37f237f83b..0ade67d6b089 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1087,6 +1087,8 @@ static int snd_ump_legacy_open(struct snd_rawmidi_substream *substream)
 	guard(mutex)(&ump->open_mutex);
 	if (ump->legacy_substreams[dir][group])
 		return -EBUSY;
+	if (!ump->groups[group].active)
+		return -ENODEV;
 	if (dir == SNDRV_RAWMIDI_STREAM_OUTPUT) {
 		if (!ump->legacy_out_opens) {
 			err = snd_rawmidi_kernel_open(&ump->core, 0,
-- 
2.39.5



