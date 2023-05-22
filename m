Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF665171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA93C433EF;
	Mon, 22 May 2023 19:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783873;
	bh=GvBIaFFNDWukj+63DYyfuqluzJ4KZ8igHhn8Dae5KdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWY/ov6Tm/Yz4aiwRVwCvhjGyH5CkDyOFwMmJu6GDvJZXeBgraCehSdXmGo0Y2wle
	 Sa+I+RhsCdU/sbswnDvHc3qGua7trrvlPoVkA/3finwwcm2gkTwbyt7wDuiQpVWHaA
	 Q+aWDgPwXEbUfbOKQ+ZPcBUKOQRnTcItWUvaYi5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/292] ASoC: SOF: topology: Fix logic for copying tuples
Date: Mon, 22 May 2023 20:09:07 +0100
Message-Id: <20230522190410.709230428@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 41c5305cc3d827d2ea686533777a285176ae01a0 ]

Topology could have more instances of the tokens being searched for than
the number of sets that need to be copied. Stop copying token after the
limit of number of token instances has been reached. This worked before
only by chance as we had allocated more size for the tuples array than
the number of actual tokens being parsed.

Fixes: 7006d20e5e9d ("ASoC: SOF: Introduce IPC3 ops")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com
Link: https://lore.kernel.org/r/20230512114630.24439-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 6a0e7f3b50234..872e44408298f 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -545,6 +545,10 @@ static int sof_copy_tuples(struct snd_sof_dev *sdev, struct snd_soc_tplg_vendor_
 				if (*num_copied_tuples == tuples_size)
 					return 0;
 			}
+
+			/* stop when we've found the required token instances */
+			if (found == num_tokens * token_instance_num)
+				return 0;
 		}
 
 		/* next array */
-- 
2.39.2



