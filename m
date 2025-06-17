Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2BE2DF3CB;
	Tue, 17 Jun 2025 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174317; cv=none; b=e9jHtBgeEe4mhVpj0YVIBfGKNsewg/JG/E6cvYxXzTXH0rD9q2X8L27jiQh91pUd96ReepUps04tFikYXR3DzVoOn3Aq6TKhBxz2+69I+EC3kesp7FcRur7RplqMkwRD+DmWUUKjCl+R0Wxt1CQ4HQR/GN+c/yXqn4rlgVIKrcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174317; c=relaxed/simple;
	bh=17kLOvF/t7RFPwn1ESN0LkSXPbWaePe9K53rvNShpD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu/QMbaggiFYQsOzQ9W3tiiBtlnSxwz4vPmt5g3zXdHwqe9EAJ+KLPnjd72mqMM/7VAsZTIl1RVQgr+r6sztRF7sqLHXil7cjn8I0/rt9dTMYs0x6rKDBE8cW73EfWBuyRjI1ZyHw3T84i7F2ql4Kph/dApwB9X5dfXwh9aOs0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvS5rrt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvS5rrt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD527C4CEE3;
	Tue, 17 Jun 2025 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174317;
	bh=17kLOvF/t7RFPwn1ESN0LkSXPbWaePe9K53rvNShpD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvS5rrt1vXUOcTL8gyz4Goihcl1zIX2JqRJl4Y3UMCHxIfH5hZ00gu0giPkT+uOvb
	 NQDkK6weqT8BPBzWrbv1hPJzVE5JYuIhkrkf0L60zftHRO/TaRCjTrDtYW8yqPuq10
	 Taqtjd+sH+quG1oD6LZfzBvPLiJ8Mh6Bz067VVGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/356] ASoC: SOF: ipc4-pcm: Adjust pipeline_list->pipelines allocation type
Date: Tue, 17 Jun 2025 17:22:43 +0200
Message-ID: <20250617152340.170034638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index bb5df0d214e36..a29632423ccda 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -615,7 +615,8 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 
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



