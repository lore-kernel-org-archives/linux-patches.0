Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0651B1EA80;
	Tue, 11 Mar 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706526; cv=none; b=g2RvR3DfFnh+RWnc8fKDPYFDJ1ySfAOmGLWT00r1QeKMVLR1OFYmi1lg8p15NiefmCgpG7oBBVyP2/GRPU21OrxjuVM/V2xYRO5wSKR1qOGRrjqUYRqLpPrJJMEi04oTf/CJubtfjSukRaoKYoA6ad5d4nayKnm1dfczDzsmM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706526; c=relaxed/simple;
	bh=onYLppi+yTVDjhEGC3T0iuFr1UqeZU5aeDMwVTqgbJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKIL3R9Y4ASbjaeo2vXAae/IxAqo43aVsBTUpr5T9O1YknmCdb8o5coTMCNA5rwK7sEjvt2Q7Xf0B9ZU2z6FF8/xVqN+smDfd26n4epkx1KE8SYQsxhJDyZcDrUYkiKZzPoVc8pFLKDFF9S+tQnEFa+YAhnfsC/5SXT9XzVw3O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdYciwus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdYciwus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84376C4CEE9;
	Tue, 11 Mar 2025 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706525;
	bh=onYLppi+yTVDjhEGC3T0iuFr1UqeZU5aeDMwVTqgbJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdYciwusXXqI/dUVrIRgy21pSX/YxeUpW+la6CR0qczdsLSnbkcubExtos2Er6TNe
	 Pr+LeWFQfBqdQ9q1u3q9THr3NY0zJGn6RMuHj2Yj3582UdbDppvB199gJwhcpstqBt
	 jlc5VlNk8L/5NxVUaAp+xm9BeNWBWIMOVsmmN5+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/462] net/rose: prevent integer overflows in rose_setsockopt()
Date: Tue, 11 Mar 2025 15:55:14 +0100
Message-ID: <20250311145800.251065255@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit d640627663bfe7d8963c7615316d7d4ef60f3b0b ]

In case of possible unpredictably large arguments passed to
rose_setsockopt() and multiplied by extra values on top of that,
integer overflows may occur.

Do the safest minimum and fix these issues by checking the
contents of 'opt' and returning -EINVAL if they are too large. Also,
switch to unsigned int and remove useless check for negative 'opt'
in ROSE_IDLE case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250115164220.19954-1-n.zhandarovich@fintech.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 1d95ff34b13c9..65fd5b99f9dea 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -396,15 +396,15 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct rose_sock *rose = rose_sk(sk);
-	int opt;
+	unsigned int opt;
 
 	if (level != SOL_ROSE)
 		return -ENOPROTOOPT;
 
-	if (optlen < sizeof(int))
+	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (copy_from_sockptr(&opt, optval, sizeof(int)))
+	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
 		return -EFAULT;
 
 	switch (optname) {
@@ -413,31 +413,31 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 
 	case ROSE_T1:
-		if (opt < 1)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		rose->t1 = opt * HZ;
 		return 0;
 
 	case ROSE_T2:
-		if (opt < 1)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		rose->t2 = opt * HZ;
 		return 0;
 
 	case ROSE_T3:
-		if (opt < 1)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		rose->t3 = opt * HZ;
 		return 0;
 
 	case ROSE_HOLDBACK:
-		if (opt < 1)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		rose->hb = opt * HZ;
 		return 0;
 
 	case ROSE_IDLE:
-		if (opt < 0)
+		if (opt > UINT_MAX / (60 * HZ))
 			return -EINVAL;
 		rose->idle = opt * 60 * HZ;
 		return 0;
-- 
2.39.5



