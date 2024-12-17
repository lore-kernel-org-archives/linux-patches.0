Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB01F543C;
	Tue, 17 Dec 2024 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455408; cv=none; b=qQeKSDUr8D6jUOLAgpDhTim1VKn9LPPo6roLWBELwE0BxzRqV4EaDiLJ71M/tIgMUDgmTYRlapuq1xryolBSEl/m/2Y0pOMUDhaKJfQavaxBc/PomS5BaU/xhx+mw7XigcU/PlpmEZslX4i9IG072aFvjAT/dNsIESY82IYAoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455408; c=relaxed/simple;
	bh=Csj8Hmd6H/+IHpygYq4awUcZG3616RU16dezj7RwNY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6dS/iFXdCivFgajy+SuZJtWqFdGJ2EYwV9Sxix0rJe81bQ4eaiRxmZCRNxXBWVwIFouJwGer7CIeBW1FRWIAJdu8KAqcqmJsR/cFTksA0AS96qeAOvRMBh9b3FSHFbXeKdcnMqL5n/EiRmmgYTd97NWP96InC1BxFhv4RJp2tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUkldIrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUkldIrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C0C4CED3;
	Tue, 17 Dec 2024 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455408;
	bh=Csj8Hmd6H/+IHpygYq4awUcZG3616RU16dezj7RwNY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUkldIrKlFYiVfNKIFdsWL2l7cugRAKglToM7Hj8yfP7G+Prg60KWnOGiJHlaDU57
	 n8LKtxpFbpiqRng/0aBM2ju6pIGAPgK23MX6pKw9kGsvnjKM5NHvYLqemwkoiDeSIX
	 veGqxGexTnAhuiFIR3vV6Q3eUj0XmJaX2N5TvU04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/24] blk-iocost: clamp inuse and skip noops in __propagate_weights()
Date: Tue, 17 Dec 2024 18:07:16 +0100
Message-ID: <20241217170519.751688563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit db84a72af6be422abf2089a5896293590dda5066 ]

__propagate_weights() currently expects the callers to clamp inuse within
[1, active], which is needlessly fragile. The inuse adjustment logic is
going to be revamped, in preparation, let's make __propagate_weights() clamp
inuse on entry.

Also, make it avoid weight updates altogether if neither active or inuse is
changed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 57e420c84f9a ("blk-iocost: Avoid using clamp() on inuse in __propagate_weights()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e7d5aafa5e99..75eb90b3241e 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -907,7 +907,10 @@ static void __propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse
 
 	lockdep_assert_held(&ioc->lock);
 
-	inuse = min(active, inuse);
+	inuse = clamp_t(u32, inuse, 1, active);
+
+	if (active == iocg->active && inuse == iocg->inuse)
+		return;
 
 	for (lvl = iocg->level - 1; lvl >= 0; lvl--) {
 		struct ioc_gq *parent = iocg->ancestors[lvl];
-- 
2.39.5



