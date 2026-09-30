Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561A50C2A4;
	Wed, 30 Sep 2026 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788392; cv=none; b=qlLh8YPc1c9GZSXESxu+J/DCsYQcU4UMLb6i689NeI18J+BJJC5+/ZwjHB3vdYsoqc/mXymcBSfpZId48JrPSuiX3HbwoLgWwunMdA1o1OD+B8Z28ox4j2UpdqXWcGgbhSP2IvG4u7sXHwqPcZDEii1+mfEi6jTxeQ5QpgjYqJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788392; c=relaxed/simple;
	bh=I3ZzpRTsoH8qFFSRldwDKydfDEf478rYdOXukVunlok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcYIyvOUaTQozX+v0J71FygmgfqRonjdW0abNs4QRhBCWbKhWg89q5rYsFSLRoLv9Nciq+FohYvzapY0vWtSxvCvqVxlAkImv7ZywGLCcOACzpxxQiGH5ZPw76fB+HP7wcM7DCjxg3ejsylr3x7P37GxcMuqigJL2UHd9PCHM5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xigjrkDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xigjrkDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596631F000FF;
	Wed, 30 Sep 2026 17:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788390;
	bh=BVHzXfnaQzDXFrLDyNYY0aREKLvnbBIXMNf8dc5pNGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xigjrkDCHQTsu1jtSvj9wL6liQY6vUWoWfjD9NTAGAVrzaueDlyJm5CnYj4OkkqSy
	 +qyO/CoGDk4Ok/OJTgpnUyp7Z/zD0YCrFdITnFEHRRRk9Skw3lpHB+eNre+CC/KQMY
	 qwmJUd/s3RYeHmYh4sk7xh20tHcmQm+/SbcfwCZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/877] ASoC: Add codec_ch_mask to snd_soc_dai_link_ch_map
Date: Wed, 30 Sep 2026 17:16:57 +0200
Message-ID: <20260930152417.025242071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 88b14c0d0bab5c0f3e7c641f274e3c70210c0e36 ]

Add a codec_ch_mask member to snd_soc_dai_link_ch_map.

The CPU and codec channel masks are not necessarily the same, and are
quite likely different. SoundWire and I2S/TDM both support assigning
different sample slots to each codec, so for example channel 0 on each
codec could map to different channels at the CPU.

It is also possible for one TX channel to map to multiple RX channels.
So it isn't _always_ safe to assume that the total number of set bits
in the CPU ch_mask is the same as the total number of enabled channels
on the codec.

For example consider this mapping on a capture stream:

CPU0 CODEC0 cpu_ch_mask = 0x03
CPU1 CODEC0 cpu_ch_mask = 0x03

This could be either four TX channels on the codec split across two
receiving CPUs, or two TX channels on the codec duplicated to two CPUs.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260910114500.1586637-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6b382bdfe26a ("ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 87e50c8cdda31..a5f8e83e6ced4 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -718,6 +718,7 @@ struct snd_soc_dai_link_ch_map {
 	unsigned int cpu;
 	unsigned int codec;
 	unsigned int cpu_ch_mask;
+	unsigned int codec_ch_mask;
 };
 
 struct snd_soc_dai_link {
-- 
2.53.0



