Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921ED2236FA;
	Thu, 12 Dec 2024 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018311; cv=none; b=bN7DcqWOhxIAkKaWN7qXo9zxHnPAQgatfh3FTlG8EEyVyHBzoyqsG/saISrCHMMYQ0imUqKBds27X4C2D2NcQ1V1hpQpDv/AJyiN5GFMtAYCKlm14ciFa7tNawwnGA7E3rZTyaLm7qxypf3JOTIKpGsu7R317X+D9MaLZcKbN8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018311; c=relaxed/simple;
	bh=H2SxPZjMXisHqihJR/xwF+xlfHyW86NuTIouEn46CU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmYKIg3p6eM6QxSUUUdZNMndEV27wKOZLcGi/hNPbmDqalXVehws09/dDAyqarBwqv8O9a0mVRIVkfUKA4zR5OpT41b8pOB27AU3EnHQshGHAw0Xs4ntrVY5LvpQ96dYflc4fp1KgT3G+QtAThsFBnro2YISR4qTg+ihbp9jfoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piu6HFcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piu6HFcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F325C4CED0;
	Thu, 12 Dec 2024 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018311;
	bh=H2SxPZjMXisHqihJR/xwF+xlfHyW86NuTIouEn46CU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piu6HFcfgA5ab74Lextbzm6uPzoWovYEq6cAO6+G2QLblVvb49ZRYzqMgOWZ012OX
	 4SIABhBwC4q52NwwgJmlZNPS7uiBXQbh3P2FxZo1xPIs3tLVQh7nnIJcXRiGP6hGYH
	 4mYomP7tSQBRfvlz8VVc/tE0SgXZ3SWrelOxf6p8=
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
Subject: [PATCH 6.6 227/356] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 15:59:06 +0100
Message-ID: <20241212144253.587909035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7343fd487dbea..c469fc187f0c7 100644
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



