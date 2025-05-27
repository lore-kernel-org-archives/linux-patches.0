Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6310213790B;
	Tue, 27 May 2025 17:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366145; cv=none; b=E9rprKkNkTXKUdo1tViBXchos4tVzBYsA8seMXDenG85FW89JlpRGXPKvLquqLlEvKCuSy5Vhz3ww1m+GxAeG4qcs0yt7NRWUTEUgH+fWSLCtjubRBGhJYX9ZbUJeiSzVVDJ0EFGoRnl45fFFavlvaQcTMWchNCob7IKjuqdwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366145; c=relaxed/simple;
	bh=qNUOBYF2qfK2iu/+eSXTKZiecD95bwKfiUD1F7qfyUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTIxyuzeGdW4d9MKnXfCGSOjHVu3jsM03QG9JtgVjYwfFEZMhBxoTUZ6EJ4s7gW2pAJwUxZYBKNmMCGITM2lVVKlQGWa6K64M/m0JC9ZrtkhZYbYlVsssPDhjr5CpHlip+Ok/q1K1H4cj0v2gw07homhfU0YFvmecYIruPOt5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+4Ls4Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+4Ls4Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF89DC4CEEB;
	Tue, 27 May 2025 17:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366145;
	bh=qNUOBYF2qfK2iu/+eSXTKZiecD95bwKfiUD1F7qfyUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+4Ls4KbYM6E/YFLIEmljSW7lBlI2KUxd1qKViZw06SQkCnMcOVIN8UViKg2e/TJa
	 Kvt17nlgGlM/fAgsbGsA3vVAQUlQYng1zIKTkQRvGWtKmDSr4GS8bqBUuEunptkI0E
	 Of22F1xfPnkUFFf0OT2tFdbKCW7syFPL6oyEzd0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 578/626] ASoC: SOF: ipc4-pcm: Delay reporting is only supported for playback direction
Date: Tue, 27 May 2025 18:27:51 +0200
Message-ID: <20250527162508.456000983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 98db16f314b3a0d6e5acd94708ea69751436467f upstream.

The firmware does not provide any information for capture streams via the
shared pipeline registers.

To avoid reporting invalid delay value for capture streams to user space
we need to disable it.

Fixes: af74dbd0dbcf ("ASoC: SOF: ipc4-pcm: allocate time info for pcm delay feature")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20250509085951.15696-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -794,7 +794,8 @@ static int sof_ipc4_pcm_setup(struct snd
 
 		spcm->stream[stream].private = stream_priv;
 
-		if (!support_info)
+		/* Delay reporting is only supported on playback */
+		if (!support_info || stream == SNDRV_PCM_STREAM_CAPTURE)
 			continue;
 
 		time_info = kzalloc(sizeof(*time_info), GFP_KERNEL);


