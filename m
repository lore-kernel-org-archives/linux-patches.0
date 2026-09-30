Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F736998C;
	Wed, 30 Sep 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794547; cv=none; b=XQLbm7wTn76c3BwyhNNksfg7Njv5nTplvjeKzK9EblADFrmYuwtOlArNNdu2MKn8qkiL3YZj9nYRaWGPgTQNmS0YGYZzVDO8v4d6hQZSmHdlQFzacIRTEeih0HAMr4hm6AOjCfpazwRz3NyylnbAdfUDQk9K0b6BUuV6CHqy4Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794547; c=relaxed/simple;
	bh=ZHv2QElAdwOI/YaaTwM2la8BFv8fCe1ndJE2xG8Ak8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7VXPtjVWsA2O55oE1nuB5vekJZw25zdDDZLxYrS+sk/uSwy1F4AyRdO+zYotugR9H4TFl5piwSQYgJYHmFW9YwA80RTjqpt7auLYq2mvT/in+P2awWxDVpHAmqGe/TRmU1zdIGA6oVkvmk5XakeBTFgQUMYTlzU8El5/R/YvY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aY+sCRti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aY+sCRti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8D11F000FF;
	Wed, 30 Sep 2026 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794546;
	bh=hziZzU7QWdfA0KOZkG3ONBtTHTkXZMutKSa3iyV9nVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aY+sCRtiYxOW7vbCu2V8XjPtSxV+v6Y6HmBvhqy2w2QLqXzRDQ1s9c7es5wPCvdbA
	 iX4q10fU/kY+MJzHNlNUKSlSAlFCtjMka7goHD0zS2VdyQa/xXI+Yn7D7nLINFagBM
	 9Yw2xnkH0HiGRS3emU66FDI62YojGRlMysytDRI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0249/1193] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Wed, 30 Sep 2026 17:15:33 +0200
Message-ID: <20260930152439.718906786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bf74859333df1..d83b23b122171 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -991,7 +991,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0



