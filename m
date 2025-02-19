Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371651DEFF5;
	Wed, 19 Feb 2025 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956207; cv=none; b=pS4ZClhZ9TzmhXeyEOLw0HfDYI2pR//WHkfKqXUtoRfTPv49W2MpMz+3GOySpWJtv465B5LDoZwaO7xpDWMAjv/fASd5BWYbrGQ0BQQkfqOdqtZg7FDzdvD6KoFXrtc8TowUTc00DRdt8Tftg3Lsl2MVPRMQN8kn5auEZSzW5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956207; c=relaxed/simple;
	bh=Nw5O38CDdBv4JJdS/Sp9p87E+GYFG+81yXwcPzBfDag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I89FElJeqp8RAG/FO3PNpitMh0wYnUANB5RElqCpwbmd8UzEG4ohX3LxHEaQaAdL4DckgX0pwhL41K4DlCdwB24uCsK5ZSb/rco0dC7papTO4I36swTusm0UZpGhZ1gL5Ao4gKys1Z7XOJdDpTmqF6ZQauTr0Z5bDRvdM/DL6qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNk6O4ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNk6O4ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A131DC4CED1;
	Wed, 19 Feb 2025 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956207;
	bh=Nw5O38CDdBv4JJdS/Sp9p87E+GYFG+81yXwcPzBfDag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNk6O4jaHCdBUJPhqXhMxJvI9sCvdQkwpJc+TQjR1JsgTsop08Sa4nigSdydFPopb
	 3qPXRz10WdFJIeX1DM/gZxh4s55BeBtB0vnnjwmS/K6IyBHy1dJTzDCXv6AwAoB09q
	 D03UAW/XRsRNKHmqzjkNr32ubZ1zZ30CVKqtccSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/578] net/rose: prevent integer overflows in rose_setsockopt()
Date: Wed, 19 Feb 2025 09:21:45 +0100
Message-ID: <20250219082656.931386992@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29b74a569e0b0..8b0f249c94570 100644
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



