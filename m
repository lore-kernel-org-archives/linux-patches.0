Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C9E279790;
	Wed, 23 Apr 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420321; cv=none; b=FaUZK8CIKJZitfWimxMJbHbfbRch+YHRNtL1zUjMGQZwmBoA5arOB1NtNucJyPeNvj6rOBftAhnVdkb4BwBl23QFb2/hCaw1aOUJDjyFdhfuvza+1X8dhrA3PFyKhiOYTDKtrqpqvrkjBIWp44ZtS4onMdFFR4C4cbWlw5GbGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420321; c=relaxed/simple;
	bh=cuDm91yiCQqhNI/B0OQpJ8xmesY90dlnlxQXa7iPS9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrxJnc4JnmmSFG8dmwc1QMCfmGTpDi66M/ePgdmZ33qb+c7LPU0yqcRyQT0m4lBgyDV2DfgWc+2BDaVt1gOalYga2ERjLzDbJq398HbT4K2EmC01GsFtE5W4L8b8g2G2vOGAQpH+izPjsn+vqLYJpQAL/Ea+Gq40GBs9/8YbPbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlJu4gFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlJu4gFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086BBC4CEE2;
	Wed, 23 Apr 2025 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420321;
	bh=cuDm91yiCQqhNI/B0OQpJ8xmesY90dlnlxQXa7iPS9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlJu4gFddtRH76TYTzeEQofdX+Th4B6FSB9kbOXsD1Nl73++wUvH183nms8j4NRTI
	 ILrnqc0TL8KF6cKrWzVmnMq0e4UgNJDAkPBqsQ1q791ynEsCtLCZbNyqmwuwwMhM2F
	 iX7dqXKl0hyn9UisRemhFzJiwWr1OAK/75Tss2xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/393] ASoC: SOF: topology: Use krealloc_array() to replace krealloc()
Date: Wed, 23 Apr 2025 16:39:03 +0200
Message-ID: <20250423142645.230765415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit a05143a8f713d9ae6abc41141dac52c66fca8b06 ]

Use krealloc_array() to replace krealloc() with multiplication.
krealloc_array() has multiply overflow check, which will be safer.

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20250117014343.451503-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index cf1e63daad86b..7afded323150c 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1267,8 +1267,8 @@ static int sof_widget_parse_tokens(struct snd_soc_component *scomp, struct snd_s
 			struct snd_sof_tuple *new_tuples;
 
 			num_tuples += token_list[object_token_list[i]].count * (num_sets - 1);
-			new_tuples = krealloc(swidget->tuples,
-					      sizeof(*new_tuples) * num_tuples, GFP_KERNEL);
+			new_tuples = krealloc_array(swidget->tuples,
+						    num_tuples, sizeof(*new_tuples), GFP_KERNEL);
 			if (!new_tuples) {
 				ret = -ENOMEM;
 				goto err;
-- 
2.39.5



