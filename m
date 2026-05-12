Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFED3EDE61;
	Tue, 12 May 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608964; cv=none; b=hfSl7uFQEEahElZq3acC59d3/px4F99Ff0xiPpEhEHAJBDFOqNRUqfdat1KlU60D+bHckDheSUOd73QKcvd+c47iXilu6rbhht/R0DP4aYUKEpYEnmdfLuz9pjMzTQtjN9I7njoR7jth3P8tOm7YEeqFP/m2d9ZSQafhVDt5v30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608964; c=relaxed/simple;
	bh=EBCynUc1Sojt6yY8bG/WzmCFtV3iCvMNiYIzlo7gXr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivx3rP7t+4BZE+84F+mjlJDGBWTxkg2faknhIGqjTL71TqIkCwf515bW/P598y/34FVkYJAmr+Rjau0Whz5bnUuiB5qEWsUWqZqDz5JQjt2bRJXvGwIWFxRsGnw+8W6lKUdGJFjSVzOLxd9/XNI3FGKRmtXLomxG4n1QVMxd/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9iSeWWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9iSeWWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84962C2BCB0;
	Tue, 12 May 2026 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608963;
	bh=EBCynUc1Sojt6yY8bG/WzmCFtV3iCvMNiYIzlo7gXr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9iSeWWeJZU6LVt7Z8BckdZWlV4qfnk/iuJvpeSx+aApuZpIwPuFfi5FUHAGqC7Ns
	 W7VgwvAEOdfCef02np+i3+qvPbkqlBUD2vrI1Qa4DRkn+VfX0cxdHr/gv+aqsEE8nz
	 ilr6zgivl3yCiIP7Zmpl8n38aaxyOG02j78wnMRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 013/307] ASoC: SOF: Dont allow pointer operations on unconfigured streams
Date: Tue, 12 May 2026 19:36:48 +0200
Message-ID: <20260512173940.404944049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -379,6 +379,9 @@ static int sof_compr_pointer(struct snd_
 	if (!spcm)
 		return -EINVAL;
 
+	if (!sstream->channels || !sstream->sample_container_bytes)
+		return -EBUSY;
+
 	tstamp->sampling_rate = sstream->sampling_rate;
 	tstamp->copied_total = sstream->copied_total;
 	tstamp->pcm_io_frames = div_u64(spcm->stream[cstream->direction].posn.dai_posn,


