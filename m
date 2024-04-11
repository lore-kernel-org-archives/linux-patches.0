Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E911465BF;
	Thu, 11 Apr 2024 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832437; cv=none; b=ZY5EzcAUS9DOqPWi3ChRT5rwb2EeCENg8wNcmkkxYen9UJjmGCM134CBFLL/fF+iUBsZGiw4S9nb4UD2PCJihYFdubpWOq8kJHFyl6mphS5b3jAsEBegeF4eAAiDv8zzE2Ym6TQuBV+GK2O4aPnSe7rMHCdv6EUAARSHbexFrzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832437; c=relaxed/simple;
	bh=tDUtqd4JB4sjZJLUI55/9a+oGVh0O0tb2an0/bi8WyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCEPXPdUOsOO8qGQGq5c6+3lkKg1Jm2Gssf6GCHEt/GZ306Vi2qvvFzQOplrjTPthXco9RyWjd+sb7zjKn7CZ53O9p1Y0/6/9oZeEd/0tTBeEYdtRHMAizbFlPlg1uTr02OkMsyBZllpGlgHMENvBMnomC1o2jci0tx9IHM7r24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lp8Co8rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lp8Co8rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70010C433C7;
	Thu, 11 Apr 2024 10:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832436;
	bh=tDUtqd4JB4sjZJLUI55/9a+oGVh0O0tb2an0/bi8WyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp8Co8rkYJDIbRf0Aaan2OCKfsQMiO/kwgoTlvBxcaRk3M3VoE8ZbClCszJIuG4zm
	 Cwi3d9dBhEOkagGn1c9ERBsaVSLlaDIaXqJfUVKLf2ofg36JLhH+L539HNYHqywoZY
	 fck+OIodiT8/jwLUZjJtPqZdseQU/BaRAnzBFGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/83] block: prevent division by zero in blk_rq_stat_sum()
Date: Thu, 11 Apr 2024 11:57:21 +0200
Message-ID: <20240411095414.160336101@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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
index da9407b7d4abf..41be89ecaf20e 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -28,7 +28,7 @@ void blk_rq_stat_init(struct blk_rq_stat *stat)
 /* src is a per-cpu stat, mean isn't initialized */
 void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
 {
-	if (!src->nr_samples)
+	if (dst->nr_samples + src->nr_samples <= dst->nr_samples)
 		return;
 
 	dst->min = min(dst->min, src->min);
-- 
2.43.0



