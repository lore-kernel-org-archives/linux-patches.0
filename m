Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BE3224CC;
	Mon,  6 Jan 2025 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177238; cv=none; b=rm4rstU07vtYsHfAfRSA5/RvuDmKVv8K+ZQ0GL/Oxelb5HXx4IIHS7SRotXwUn0I5KHFUzfOO6GjqzeK0dkGSyr6GFhw5nwkCKUIHvSFN4xZB88gy9pOxSY/DVXZg0Mh4JJ2HyUeHBwLyBqh+Zow6RiqX8zjZJ2zkv2D6UrvCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177238; c=relaxed/simple;
	bh=/C1cncUrT/iE8eIYdI53trrj8H7RPEHw+tXXvppg4cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVZuyUwmwg7kZuApVXAFZOxZ9mmVMVjXUUxRAVa4clOT6RjQSMXGi+7LB82VGeuAXRiFzDD5wOANdiz/dkkHUvpdoHmkjn6nwgVRSEX5EC7YvJIv7lPhWw4WaxjqIQp4HGF+EvzIFPk5rlttS0svqjO93nGlVAujz+MB6JBvfgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cprk83t3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cprk83t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AF0C4CEE5;
	Mon,  6 Jan 2025 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177238;
	bh=/C1cncUrT/iE8eIYdI53trrj8H7RPEHw+tXXvppg4cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cprk83t39Op56uTBNA4XhLfzLTuqzfEbTZZPjDKuH2MDqWNZqndF8S8Chm4T6rvki
	 IJLoPIMzNZFay+s7fPItfD9icTHUjCfOdu+X3JpcbUZUj9vJpy6kVDdyOV9swHw9Lb
	 QKliGxPypDpHm85L274URiyN/zdrU6FkEZwJ+BOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/222] ALSA: ump: Dont open legacy substream for an inactive group
Date: Mon,  6 Jan 2025 16:14:54 +0100
Message-ID: <20250106151154.004118628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ada2625ce78f..5a4a7d0b7cca 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1081,6 +1081,8 @@ static int snd_ump_legacy_open(struct snd_rawmidi_substream *substream)
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



