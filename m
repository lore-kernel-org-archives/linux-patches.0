Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D6B2236F0;
	Thu, 12 Dec 2024 17:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023390; cv=none; b=BL22kweVf1mq3Vfs88JkntbCDFMHHUdl0qi1MClSjsiq/XfBIJBfolBDi3NfzETg1D5OFGTCMohd5qMWhlx5fSAs5Eyqoy4g3gdGYVElMlgovZaymrY0/Z0PdJnR2mun29iVpfY2VZLf3pNKwOUWdRBebGVuHBt4pAFfyBW64Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023390; c=relaxed/simple;
	bh=35qrRE6U8kI9c84yhvIYhvj023TAEqLFpyCirvXpDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjAhPR6GpOB7d4c6NGC+kdh9Qqn14OwCc891ImzlUMI3qGleeo6yOopFt8nuobL9kHvvEiHfuxupLDhX5OfetykqeyPtmt20hfoc3OxB60lO/r8kd1IQbLy+c6P4Kz9/QjDjbp6/p3a7X3DpCDWBLFIfGFUTewcqQE1EPACuMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAIfr9b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAIfr9b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDB7C4CECE;
	Thu, 12 Dec 2024 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023390;
	bh=35qrRE6U8kI9c84yhvIYhvj023TAEqLFpyCirvXpDmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAIfr9b4AlP3gKz+G4TPqp7LbBLkjeHe7dVH/uDmL0BehvlrXJ/WygCCTQv4AjkM/
	 zjkA6k7FFidQUZo/Ml3h2QiA5axEqehWmkwTM2vdaGbI2YBinyDmtZx58U+x3qjkoY
	 R2HCw9uQlnABBXdXzqIH7Ie5FzZk/tQ4jeEhkzKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 488/565] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 16:01:23 +0100
Message-ID: <20241212144331.051232089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 811a7ca7320c062e15d0f5b171fe6ad8592d1434 ]

On error can_create() frees the allocated sk object, but sock_init_data()
has already attached it to the provided sock object. This will leave a
dangling sk pointer in the sock object and may cause use-after-free later.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://patch.msgid.link/20241014153808.51894-5-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 20d2dcb7c97ae..4e728b3da40b3 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -171,6 +171,7 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
 		/* release sk on errors */
 		sock_orphan(sk);
 		sock_put(sk);
+		sock->sk = NULL;
 	}
 
  errout:
-- 
2.43.0



