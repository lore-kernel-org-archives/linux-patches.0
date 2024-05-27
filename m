Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216715FCF0;
	Mon, 27 May 2024 19:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838607; cv=none; b=mZ9DlEy2d1qMtPW88LaElD+otvsgEMx28U4RsWND0Fxk8BaQSirW2wr3gv93b7gCzihVO3JtkuVckxLAwQagnbs1ZT2Zm+Vbgem/gIgbOS4yN414sq7F8fs86mRhAE2nht9WJzXJ33rm0bjSxOY8Vs7NRHTMKgdCHTd7XoBqRwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838607; c=relaxed/simple;
	bh=8QtG+DxdpXb+reg3ONlxGnmUGWFv6rzNVjCVL9S6S8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbZ7zg8GqK5oKJVAvQ5Pn4NVVo4Mzj1iY2DDh4SOw+0KJR77taXCRHgMSg2LkZnS0BtwijWtoMFJtTTZ0xcbNUatUi2cHnpbyU6qvPuVApDhhwIQsIp9VDfX6C9vLLqoc26OZiLsQ6G1tcKDygupl9JuCjzKr4luYOQtotOz7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gS0Kmt19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gS0Kmt19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1208C2BBFC;
	Mon, 27 May 2024 19:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838607;
	bh=8QtG+DxdpXb+reg3ONlxGnmUGWFv6rzNVjCVL9S6S8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gS0Kmt19yOEKISAuQlg9C2ZHv/mhADrqjy8m12I47BVmy+aYnCP3aii/gcpcux8g8
	 9vJQW1cEQ98zuXaJv8s3EAhGMAXOVYRz0JKF/kNGYNXgsmMzOopDKIa6+KPZhzR4Uh
	 8zKZZLzzy+9F3Goz8xu8ltPzhzd+3cqqJfcGeXBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 458/493] ext4: fix potential unnitialized variable
Date: Mon, 27 May 2024 20:57:40 +0200
Message-ID: <20240527185645.187340125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3f4830abd236d0428e50451e1ecb62e14c365e9b ]

Smatch complains "err" can be uninitialized in the caller.

    fs/ext4/indirect.c:349 ext4_alloc_branch()
    error: uninitialized symbol 'err'.

Set the error to zero on the success path.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/363a4673-0fb8-4adf-b4fb-90a499077276@moroto.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cf407425d0f30..00b0839b534da 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6119,6 +6119,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, true);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



