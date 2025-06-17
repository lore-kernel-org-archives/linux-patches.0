Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DE18A6AE;
	Tue, 17 Jun 2025 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174659; cv=none; b=W22dpghbe01VSdFtiD3v3/6E46C5VVBSic++yMbfu9zrJAYDS7N8fn4s6hrOWygKVEaYbc16Uon9i1bo4sAIfn/41vt5Icsq+6TZinom6387TqIDnyjQv6BuU0iJ599b1Q6KE9/uWopUnKf4zr4/Tf4YRYsfTifLWPXJRv96rTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174659; c=relaxed/simple;
	bh=qFVeJKDbiQKmO8hCSiviB7YghMI3VhMqfA2Gwbifm1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/0W+V5LN4vwrm8CC8pb7RnPLV/ZcuyepPINQ22Vm/vmzAa7+PBTqqG1mlbu9h/kAfHYPaBlkcuq9G7NpmGxDu6uQNA3RtSRM/UQwz5RGF0Ag8fdVcgFocBlJNVOS6INAHiNKS5ZNC9Zk7bf9zVIDbjnl+qfbfRTiAox9qbCBG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOFLtcdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOFLtcdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0058DC4CEE3;
	Tue, 17 Jun 2025 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174659;
	bh=qFVeJKDbiQKmO8hCSiviB7YghMI3VhMqfA2Gwbifm1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOFLtcdljvuK1H2iaPCDhOgKVBingP2yGy+iPdxzGG5q9b6tWzltHmPQOEwI+oHRs
	 etw/tF9IvGSQlk0hTjo2NzBP1A0/cmA2jgBrV+d5uCCFOXo4jPyHqx8ZoGWhCK4QLj
	 aGaFZMBC+lH0jSCux6lFl61B1WiPujF41w+x1md8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/512] ASoC: SOF: ipc4-pcm: Adjust pipeline_list->pipelines allocation type
Date: Tue, 17 Jun 2025 17:20:14 +0200
Message-ID: <20250617152421.483026308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 00a371adbbfb46db561db85a9d7b53b2363880a1 ]

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct snd_sof_pipeline **", but the returned type
will be "struct snd_sof_widget **". These are the same size allocation
(pointer size) but the types don't match. Adjust the allocation type to
match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
Fixes: 9c04363d222b ("ASoC: SOF: Introduce struct snd_sof_pipeline")
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250426062511.work.859-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 2fe4969cdc3b4..9db2cdb321282 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -780,7 +780,8 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 
 		/* allocate memory for max number of pipeline IDs */
 		pipeline_list->pipelines = kcalloc(ipc4_data->max_num_pipelines,
-						   sizeof(struct snd_sof_widget *), GFP_KERNEL);
+						   sizeof(*pipeline_list->pipelines),
+						   GFP_KERNEL);
 		if (!pipeline_list->pipelines) {
 			sof_ipc4_pcm_free(sdev, spcm);
 			return -ENOMEM;
-- 
2.39.5



