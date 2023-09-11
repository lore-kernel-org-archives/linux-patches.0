Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17AE11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1FDC433C7;
	Mon, 11 Sep 2023 14:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443231;
	bh=dJdWS+DXbQGTp81XfIF1HUleIs0Ryaj7Ys7zr6oyqEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttBOlENYQMGuOE3bC0KQj90RPHdZ2V5p0W39X85xuldF7LEWo+ngAgOQlD/DuNdi4
	 YG/rJxsY3nWPzHhZM8MDYMbDSIU/eecX4/u460u+jZaesVzrMW7GnmzSjVVHsfwyFJ
	 qVEzl+M7Qy5O1Xt3puMahGSZBZhcZ7vsuhN9pjBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yixuanjiang <yixuanjiang@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 268/737] ASoC: soc-compress: Fix deadlock in soc_compr_open_fe
Date: Mon, 11 Sep 2023 15:42:07 +0200
Message-ID: <20230911134658.067369916@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yixuanjiang <yixuanjiang@google.com>

[ Upstream commit 2222214749a9969e09454b9ba7febfdfb09c1c8d ]

Modify the error handling flow by release lock.
The require mutex will keep holding if open fail.

Fixes: aa9ff6a4955f ("ASoC: soc-compress: Reposition and add pcm_mutex")
Signed-off-by: yixuanjiang <yixuanjiang@google.com>
Link: https://lore.kernel.org/r/20230619033127.2522477-1-yixuanjiang@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index d8715db5e415e..2117fd61cf8f3 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -194,6 +194,7 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	snd_soc_dai_compr_shutdown(cpu_dai, cstream, 1);
 out:
 	dpcm_path_put(&list);
+	snd_soc_dpcm_mutex_unlock(fe);
 be_err:
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
 	snd_soc_card_mutex_unlock(fe->card);
-- 
2.40.1



