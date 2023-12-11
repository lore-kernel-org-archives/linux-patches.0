Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253FE5102A;
	Mon, 11 Dec 2023 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GATrUaTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1B6C433C7;
	Mon, 11 Dec 2023 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320575;
	bh=ntD3qtw6fiV8T5aQBq0B8lIZAwG2azMEYn3qcd4Lh3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GATrUaTptz6KmiES+5LOvz58q2QWLQY3ve0fEZZFF69jlCbztJvzPzd5zKIr/aPDY
	 tvNu/5Xp87p6kKnPhOsxQDyulKShx6PFaQL5V7cnNdU77DwkdLY8kZns6sKFmWziBh
	 9i8GiU6J/XAAhTo8CJFS/5adAonLSJVlc5gbh920=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/194] ASoC: wm_adsp: fix memleak in wm_adsp_buffer_populate
Date: Mon, 11 Dec 2023 19:21:13 +0100
Message-ID: <20231211182040.174296683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 29046a78a3c0a1f8fa0427f164caa222f003cf5b ]

When wm_adsp_buffer_read() fails, we should free buf->regions.
Otherwise, the callers of wm_adsp_buffer_populate() will
directly free buf on failure, which makes buf->regions a leaked
memory.

Fixes: a792af69b08f ("ASoC: wm_adsp: Refactor compress stream initialisation")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231204074158.12026-1-dinghao.liu@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 8a2e9771bb50e..2cfca78f0401f 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1401,12 +1401,12 @@ static int wm_adsp_buffer_populate(struct wm_adsp_compr_buf *buf)
 		ret = wm_adsp_buffer_read(buf, caps->region_defs[i].base_offset,
 					  &region->base_addr);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		ret = wm_adsp_buffer_read(buf, caps->region_defs[i].size_offset,
 					  &offset);
 		if (ret < 0)
-			return ret;
+			goto err;
 
 		region->cumulative_size = offset;
 
@@ -1417,6 +1417,10 @@ static int wm_adsp_buffer_populate(struct wm_adsp_compr_buf *buf)
 	}
 
 	return 0;
+
+err:
+	kfree(buf->regions);
+	return ret;
 }
 
 static void wm_adsp_buffer_clear(struct wm_adsp_compr_buf *buf)
-- 
2.42.0



