Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C673E0749;
	Tue, 12 May 2026 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607743; cv=none; b=tKod446x4bCEoxptclWznBnMajL0cgk/psDoewgZpT029Kb6zp2+eHdb6zLDOODslZ4rB+xItXzqWTz4bYKFFsO/xsIWT83UPNC7hPAobTUyx7DZRP/jF5fj3rXJDVBSocErC/2cdFkie8UiAg48m81VpC9dKVC/BV5MHu9wKMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607743; c=relaxed/simple;
	bh=D459uEJystnBzowzRAaQJDo2nNkbNv91p3PBqnEU0ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSFLxhnbVwLM6Zk0Sm1sV6liUt5So9F9m5RgwTlHtvC8uv8A2Bl52YRB/4rnvH/7Vuq7cbtz3Q+flQ88vzOc+YLOg0QLFWuJ1nuVHuXLSfdfpOVYEHLp9xItKHFCPfUY6oXTbc6oioCd/TIxXfjKFFB1ORWmh5+rsr57gTT7Tk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaHDaG58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaHDaG58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C47C2BCB0;
	Tue, 12 May 2026 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607743;
	bh=D459uEJystnBzowzRAaQJDo2nNkbNv91p3PBqnEU0ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaHDaG58+602KWkaqYOSSAdqvw5X9BEHBnQYwJa8mktrczhmUKe/CTfCLyri/XJ5o
	 30+pq8CINI4zIf/RtXGPPEMqf4+B432kaJdtK5D0ayktKSIVeEHwSyRAdj1O7AbPsu
	 ie3tEWMjMlpSRZGLOHsUd2tsNtETIgMJxjx2+Ibc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 011/206] ASoC: SOF: Dont allow pointer operations on unconfigured streams
Date: Tue, 12 May 2026 19:37:43 +0200
Message-ID: <20260512173933.058920188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit c5b6285aae050ff1c3ea824ca3d88ac4be1e69c8 upstream.

When reporting the pointer for a compressed stream we report the current
I/O frame position by dividing the position by the number of channels
multiplied by the number of container bytes. These values default to 0 and
are only configured as part of setting the stream parameters so this allows
a divide by zero to be configured. Validate that they are non zero,
returning an error if not

Fixes: c1a731c71359 ("ASoC: SOF: compress: Add support for computing timestamps")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260326-asoc-compress-tstamp-params-v1-1-3dc735b3d599@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/compress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/sof/compress.c
+++ b/sound/soc/sof/compress.c
@@ -371,6 +371,9 @@ static int sof_compr_pointer(struct snd_
 	if (!spcm)
 		return -EINVAL;
 
+	if (!sstream->channels || !sstream->sample_container_bytes)
+		return -EBUSY;
+
 	tstamp->sampling_rate = sstream->sampling_rate;
 	tstamp->copied_total = sstream->copied_total;
 	tstamp->pcm_io_frames = div_u64(spcm->stream[cstream->direction].posn.dai_posn,


