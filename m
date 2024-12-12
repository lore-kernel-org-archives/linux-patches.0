Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485FF2253EF;
	Thu, 12 Dec 2024 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021191; cv=none; b=gpPiUQ4zv/waqL+ERDxJ9ESnpo1qkFWsrdiGAa2ee8Kvj+M6uG1cGfiWLVQwR2qwwbt205/D+uA2B4GSaI1lfAxcA4UqW1U8YorosDE1NdGiE5vqNZfcploUSxl2ZFpf3J+8YzhiWzs9ulhfPDnnDQJnaXNqw3KnEXOaXs0etWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021191; c=relaxed/simple;
	bh=UtP2FXVI9oYEzSKPLwIA0tIBX/hQVhrrvULDnKpVunk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1Yqajqpj6sC1zh/nimfsbRvzwXA/fBK7kQ0k68avrU9afI3hzyHk31z6asYRNDiyyQdJ9S9DOr71kwSAngz44yGO+BCMFOSRDI2tQWi4yf87gKK8xZoQHfw9/YlFp47XbPatcYiuoLqbtug1NLgFvFPtLFaDS3Ox1ktEXITQ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Msc3Lmmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Msc3Lmmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F4C4CECE;
	Thu, 12 Dec 2024 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021191;
	bh=UtP2FXVI9oYEzSKPLwIA0tIBX/hQVhrrvULDnKpVunk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Msc3LmmqC3V9+/lc6md8OuBrIlaDNyFfHxtsudopI/hvOypaIsN6maD29HRlR31JO
	 DlXSXL+HMT9qLmm2bFO1ayNwavTmpRLzpxKOgMEzN4Wj+aFI5w5fhk9gtaRHB/tCpM
	 dUcbjEOpIey6iFzTT495/LO7fDLFaB6UTvu5bGpw=
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
Subject: [PATCH 6.1 670/772] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 16:00:15 +0100
Message-ID: <20241212144417.602952209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index c69168f11e44a..7d8543e877b44 100644
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



