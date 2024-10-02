Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D320D17B421;
	Wed,  2 Oct 2024 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877094; cv=none; b=QlwJlDkB8Ad7zhDvm6mayWNj28LLYA87+DBVMDZFhCZQy3mG24XG065vHedUVOVlEpkbgoMXp21ey2cJtilEu3KyByGI8sK/k7moMkaBV36LXNEMI1beBoqkjM449vTc/5w6V8aaxZT6HCFNONmauXhdQCXRx4oDmbyLUCnIu48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877094; c=relaxed/simple;
	bh=0Xj1Jp3gmjERJ4MzaW1GoSINIGNGXuz9gWBTIhlBw0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpwbgGSSeYvDp+6p3gxGyfe8JuI9l6U5i/8GVNkjRrnQi1EfP2e6jlgObUIv+MamUUb7rkxYiZjIyrxenzRO8s5/001pVWVTqdkwpEXaIx9q52tmH9/NwUT2H448f2hj5Cm1hLPLPols0pp71wvX3qTTqN2SKdYJTB/X/N6+X5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNoJDggv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNoJDggv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59487C4CEC2;
	Wed,  2 Oct 2024 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877094;
	bh=0Xj1Jp3gmjERJ4MzaW1GoSINIGNGXuz9gWBTIhlBw0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNoJDggvQ2tNlhgsUJWE0KIkHJzOU/zf0ml4TdQE1/cYiMvRyAdCWVcrcDzbnBJ5S
	 RR3RBUFT+AmWfM98xCRi58EqEncvx+CD+XUFzvU0olNhG91KtN+blI+oMtGDcEiRt2
	 LaBApN4WIBcx3qcK4QKPjcxcgXZx5/k7dT8Vhq2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 631/695] f2fs: prevent possible int overflow in dir_block_index()
Date: Wed,  2 Oct 2024 15:00:29 +0200
Message-ID: <20241002125847.703368432@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 47f268f33dff4a5e31541a990dc09f116f80e61c upstream.

The result of multiplication between values derived from functions
dir_buckets() and bucket_blocks() *could* technically reach
2^30 * 2^2 = 2^32.

While unlikely to happen, it is prudent to ensure that it will not
lead to integer overflow. Thus, use mul_u32_u32() as it's more
appropriate to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 3843154598a0 ("f2fs: introduce large directory support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -166,7 +166,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


