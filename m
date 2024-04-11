Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BEF13BC33;
	Thu, 11 Apr 2024 10:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832641; cv=none; b=l9tvjvlQ7+8JmA3Mwixs1k/ouyczPzzfTezmgZvF1EZcuWT04p+Mfp8P2qx+kvHWoCNm9tszGEPURM4FAjNG4oUzeYE1kyJPBWpYxa/hHxZZKdCMOZsOWF9rmPMEh8QDOQKhhtjKHpYPge1+KKgwK3FQx2vJDzQ5vVgYAY1t4D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832641; c=relaxed/simple;
	bh=EKS9iHgDFNRYDK8vuOBJE2Fn8x9Cd1jM0W3ktvv19k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQeo5W2BY11S9ZMpJLTI/AA8yqBtVrQuRXpbQuhSfu8CF9prfFfzOEn2Hsl/2GM9Wnv9t3jqoFgorEyeqKUSAab6CIjNt/9PX4PvAzyhqu6mKDfL2FqZPK9s7Cj+hidIUb8LuVBxs5tR/AlFJbOo2KHMStFLFEYN0kPwdcN4eKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpFzKcAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpFzKcAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1543C433C7;
	Thu, 11 Apr 2024 10:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832641;
	bh=EKS9iHgDFNRYDK8vuOBJE2Fn8x9Cd1jM0W3ktvv19k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpFzKcAu5RAveieL1p3Zffbt185CIOfyAW/wgVG9G3DxcwZ1hNiPJg67yekzlSEb2
	 vd3mhfs9HtHe/hkruiQ3v+Mgn4YSGPHPN92HJxpdZIjuf/f1cqu0cnokWWyjEczkhH
	 6wSSb0rcRdLeAoMn4QSUH99CPf3g49SFMK1DUXoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/57] block: prevent division by zero in blk_rq_stat_sum()
Date: Thu, 11 Apr 2024 11:57:41 +0200
Message-ID: <20240411095408.997363463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae3dd1fb8e61d..6e602f9b966e4 100644
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



