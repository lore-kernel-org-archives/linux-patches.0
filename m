Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBEC32D42B;
	Sat, 30 May 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160250; cv=none; b=i2NsKB8bSn2wPYeO3ukJosPWplp7wwiEbgkCrovZrsTj6VAz6SIb8t6b3Z4TVk8Z+hYpdLgHArK77YPG4vkwOuKsI5LuAYxZQCieV96YGW93W2UaFljI8BzxJ7f0rHPQ3v0M5SR4+Gx1jJ35CmUuJh/cjhKkTbKkz5h3Z1Zbb4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160250; c=relaxed/simple;
	bh=FNHLphEDBCvHoKCku0ayR00H6HTPAuVzXSnypDoH7mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfv6OHc5Q+1FVEJveuLraIf+jJgE6HJOwtt+NTfl219Ns+hSIWJDgKMZZWUuiBoqMEcXjj6T3gZc8mg2w2iJTMzX4DSj17HU113vAJI9AmKyVPJAOuyBiqFBd2gA4cOv50EcQx80GmBzAZT8QLqLNL0QkZHD84H1a5M1sUZ5Jhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cg1Kpt9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cg1Kpt9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A71D1F00893;
	Sat, 30 May 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160249;
	bh=KTePyPEEIvz1g3MeT8jsXPT4Q7FtIWaoLgJytcIxtz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cg1Kpt9J+x2a95f99fMaQ3w0ZsI28relaP1iul7yU4nVkmGrq+D8DhU5vs6yAQS2q
	 PuvvHIigIiDYQVPSAT1Zl8haOI9WJZDqPyRp75gcQwbm+l3XKD5cwwjKO3H5qpbJDo
	 /O/ZjPNrX3lvjkDgVXXVaiiCXtusnos5z/EKNanU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 287/969] ASoC: SOF: Dont allow pointer operations on unconfigured streams
Date: Sat, 30 May 2026 17:56:51 +0200
Message-ID: <20260530160308.385796510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -366,6 +366,9 @@ static int sof_compr_pointer(struct snd_
 	if (!spcm)
 		return -EINVAL;
 
+	if (!sstream->channels || !sstream->sample_container_bytes)
+		return -EBUSY;
+
 	tstamp->sampling_rate = sstream->sampling_rate;
 	tstamp->copied_total = sstream->copied_total;
 	tstamp->pcm_io_frames = div_u64(spcm->stream[cstream->direction].posn.dai_posn,


