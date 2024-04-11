Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6096C2EAE5;
	Thu, 11 Apr 2024 10:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829956; cv=none; b=BBBE/SwGqmzqRwIpLMPziqKLc55pKtgRWqa4QLEiA2sKqX02rtFrhuDTywxXZMZYs/f+nG74giF0aFGlx6Nm4n41v8Hsvz+O6LF98GqGdWwkHImUDzh0qmaAlilwuW6BTBCvE23Ca1FxS2woa3HjaiMZUzIpFtejm+sklF6J0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829956; c=relaxed/simple;
	bh=cyhkpGO/Vr65vsVTQuG/hhcPjrrXQDjf5QU35v3mZ5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxY4I/S+W8cu+mNMUirTXYpB3ppNeHSyK+eoVeeYqVjsbrfZTQgng+fxQxrlcdAoXq25mVWEOjbuc25SPF1MrGhAjC6MaeipM+g7wYU4hWWhEDoDpMQwlXS2cnBKF7qGfa1Co6686clpjLUnRbv5Cljo5pZoiZXOO5NYMfxOzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trAA7otv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trAA7otv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B5FC433C7;
	Thu, 11 Apr 2024 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829956;
	bh=cyhkpGO/Vr65vsVTQuG/hhcPjrrXQDjf5QU35v3mZ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trAA7otvdnRSOjsxl6coFIZwLtv+wdcayrsjilOS7IEH1KK+I5em9KKPimwISzLfO
	 q+9P3kL7l9YdPLpfPs7jnVfQyxSAow/TaE7M8CBvwfTiyoOCv2JuCtYEbDpoYZH7JE
	 gNqHlU5fVPWSagh8uoqGnTmdYjqdT2ll+2o4UF2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/175] block: prevent division by zero in blk_rq_stat_sum()
Date: Thu, 11 Apr 2024 11:56:23 +0200
Message-ID: <20240411095424.381474020@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 93f52fbeaf4b676b21acfe42a5152620e6770d02 ]

The expression dst->nr_samples + src->nr_samples may
have zero value on overflow. It is necessary to add
a check to avoid division by zero.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240305134509.23108-1-r.smirnov@omp.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 7587b1c3caaf5..507ac714423bd 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -27,7 +27,7 @@ void blk_rq_stat_init(struct blk_rq_stat *stat)
 /* src is a per-cpu stat, mean isn't initialized */
 void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
 {
-	if (!src->nr_samples)
+	if (dst->nr_samples + src->nr_samples <= dst->nr_samples)
 		return;
 
 	dst->min = min(dst->min, src->min);
-- 
2.43.0



