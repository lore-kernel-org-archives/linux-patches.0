Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07EF1547E9;
	Wed,  5 Feb 2025 14:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764238; cv=none; b=T56ysbiNvLxc3B3hiAE9fHGY1ERMUBjG+jro6NaNANrCYrY8Uo+Yd2gBYLITSIUvipo30TxSjgLQBV3Fyhqm/rqVpSt4Au0n08qrox7G2CF9m5OGb2Q+hZS0q2tb1EcM1OPo44Q3fC6qt1Ie+t7Hhgr/rPsbmdwzKNAlDomikWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764238; c=relaxed/simple;
	bh=UU8D1ws0cmkzsmRw4DhgNR0Kdd8YZrSo9VFuB6cGPLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhUEJ1zTpFBqBVvBszUqu69gBFowLKtGhIKvwzrTjFtSt8ywzvZvD3CiLVg/bF+aSBKS/84fzwwtdtUxPIxcHko+JpJtopCZaHTr/GvnFd4ELVbuRBjCnsdNS6fk4VEiufa6CXbhE4/nRzWH5Fvr5v3RyY3Uu8l6uv0/FUY4ORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlmSrvUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlmSrvUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC5BC4CED1;
	Wed,  5 Feb 2025 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764237;
	bh=UU8D1ws0cmkzsmRw4DhgNR0Kdd8YZrSo9VFuB6cGPLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlmSrvUd5uwTZhgXkuZC3L0V+/BrlQJYxFeWRPAvmch7kDyavlKCifavhHpDJxmEl
	 Ma2x4+lW+x2mNFOGArvknV7CPZO5yhOIGvGmx3hl8JVsiVj7EVhOW7prSQIGZE9MQ+
	 hkDbjupY2OAOD/7Lwi8O9SAk8m4tP5RPjKEBjKHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/393] net/rose: prevent integer overflows in rose_setsockopt()
Date: Wed,  5 Feb 2025 14:41:11 +0100
Message-ID: <20250205134426.117775896@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 42e8b9e37516b..342823b918e7c 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -397,15 +397,15 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
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
@@ -414,31 +414,31 @@ static int rose_setsockopt(struct socket *sock, int level, int optname,
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



