Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ECD171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5308C4339C;
	Mon, 22 May 2023 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784982;
	bh=Z09mb+Id8SAXX6I62b5oep420jLQoUnWEGut5FthJCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef2CbvHns6ShL3IZNXAAusU8WisXU6L6FQPFtZ2oczUGIMQ/qTcnwdiKLc9UdyISU
	 1l0S4hHCocMwoqFJtuGt28Jgu9oMvHLYLNXNtvcgetCiUEVeL4AwPsoFjxGytTxW1q
	 DbFzNhfJ0Bh5kuECkCejL9oDlyQ2qnJNTUc3AZJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 251/364] ASoC: SOF: topology: Fix logic for copying tuples
Date: Mon, 22 May 2023 20:09:16 +0100
Message-Id: <20230522190418.973879663@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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
index 9f3a038fe21ad..93ab58cea14f8 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -586,6 +586,10 @@ static int sof_copy_tuples(struct snd_sof_dev *sdev, struct snd_soc_tplg_vendor_
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



