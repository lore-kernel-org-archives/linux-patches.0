Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF239128818;
	Mon,  8 Apr 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583835; cv=none; b=Eseaoxlfq//PpmrOda7e58pFizh3x68kfn8saKng7zSZvKPKf6DMnU172+42K6G9nNqNZJMWUFgPvNWGubzJAn45Fc9nR91lQUOztqhjszda8XPChTLnZY+Gv9JMhP+ZKjrBlkm0HYYQJrdIL+SNSuruEs9DNuYe1VYE0MFHKRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583835; c=relaxed/simple;
	bh=Uu2U0FVRtlRBmCSuo1jRBABfTjKMo2p56NjAjLvVj2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaRGmP9wZdjHxLvq6NCE59F106PmExatjE8CPY9QNBwwjRWmfkIvtpgdiqOGydQgTEifM7Y7CG9Z9StuNCqY2wDD5LfxSKswUrapMungCF0nKyUftvZxWYvIB7EWUoeYvyyeq04YrwnaJyPdz0ik12eH4WKDdLtENbSs3P96H78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiYO4e23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiYO4e23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43845C433F1;
	Mon,  8 Apr 2024 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583835;
	bh=Uu2U0FVRtlRBmCSuo1jRBABfTjKMo2p56NjAjLvVj2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiYO4e23j76KaMktfvcwO5V3ali+eS3cA6fMQt0m72d5PjZCicamdATvsJyBONLip
	 mq1VKFufWM4qk8RWgYuq036pdluOl12OVnkj9ouTr2p8MHXEbxazkY6S7Dbnm67YFj
	 9LrBh+GQqINNHUqbA6ts/Gldx6UrHAgEKMqsFOXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 225/273] ASoC: SOF: sof-pcm: Add pointer callback to sof_ipc_pcm_ops
Date: Mon,  8 Apr 2024 14:58:20 +0200
Message-ID: <20240408125316.396380071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 77165bd955d55114028b06787a530b8f9220e4b0 upstream.

The IPC specific pointer callback can be used when additional or custom
handling is needed during the pointer calculation, like executing a delay
calculation at the same time to minimize drift between the reported pointer
and the calculated delay.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-15-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pcm.c       | 8 ++++++++
 sound/soc/sof/sof-audio.h | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index 33d576b17647..f03cee94bce6 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -388,13 +388,21 @@ static snd_pcm_uframes_t sof_pcm_pointer(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(component);
+	const struct sof_ipc_pcm_ops *pcm_ops = sof_ipc_get_ops(sdev, pcm);
 	struct snd_sof_pcm *spcm;
 	snd_pcm_uframes_t host, dai;
+	int ret = -EOPNOTSUPP;
 
 	/* nothing to do for BE */
 	if (rtd->dai_link->no_pcm)
 		return 0;
 
+	if (pcm_ops && pcm_ops->pointer)
+		ret = pcm_ops->pointer(component, substream, &host);
+
+	if (ret != -EOPNOTSUPP)
+		return ret ? ret : host;
+
 	/* use dsp ops pointer callback directly if set */
 	if (sof_ops(sdev)->pcm_pointer)
 		return sof_ops(sdev)->pcm_pointer(sdev, substream);
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 04e5cb2c70a7..86bbb531e142 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -103,7 +103,10 @@ struct snd_sof_dai_config_data {
  *	       additional memory in the SOF PCM stream structure
  * @pcm_free: Function pointer for PCM free that can be used for freeing any
  *	       additional memory in the SOF PCM stream structure
- * @delay: Function pointer for pcm delay calculation
+ * @pointer: Function pointer for pcm pointer
+ *	     Note: the @pointer callback may return -EOPNOTSUPP which should be
+ *		   handled in a same way as if the callback is not provided
+ * @delay: Function pointer for pcm delay reporting
  * @reset_hw_params_during_stop: Flag indicating whether the hw_params should be reset during the
  *				 STOP pcm trigger
  * @ipc_first_on_start: Send IPC before invoking platform trigger during
@@ -124,6 +127,9 @@ struct sof_ipc_pcm_ops {
 	int (*dai_link_fixup)(struct snd_soc_pcm_runtime *rtd, struct snd_pcm_hw_params *params);
 	int (*pcm_setup)(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm);
 	void (*pcm_free)(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm);
+	int (*pointer)(struct snd_soc_component *component,
+		       struct snd_pcm_substream *substream,
+		       snd_pcm_uframes_t *pointer);
 	snd_pcm_sframes_t (*delay)(struct snd_soc_component *component,
 				   struct snd_pcm_substream *substream);
 	bool reset_hw_params_during_stop;
-- 
2.44.0



