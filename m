Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E112209695;
	Thu, 12 Dec 2024 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025845; cv=none; b=DOzeCAhXAO5gMZmOahd2vaJrMPtOFfIHZBf7LJlDApQAOA77FVYHE8Bi2RqcZ03kkcApXVE6ay+D+qoSoO/W4FebPdaWbG94JaSOwV32COMFKRme8qXM9KiSNqNSsVEc/xevqXF1G9MVDME3Z78Iqir6sIy6XYHPznAPISERgLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025845; c=relaxed/simple;
	bh=RDVKIEDXreTKv007o6QVmjgfnbl/PvwVB4k8jerqvec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPqdvZTMYWDrsTrOYQxeOgYUAAu0+3T0fwFravg8P6IfiYzKdGI35es36i7gnKYha1azv7yjA8CGJ4OiQ8t3LH2hANSRK3C9BJSeam2NSPo0tvtOFWNeuW4NLqoW8PGbjUz1GiTWbfkiHKCg22c9c0rIlkvWbP8KaWGDtkglQGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/qdLo3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/qdLo3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C3EC4CECE;
	Thu, 12 Dec 2024 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025845;
	bh=RDVKIEDXreTKv007o6QVmjgfnbl/PvwVB4k8jerqvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/qdLo3dJwcdpjKGD/zYEvFJa6v7eR3AhW7SAVqDmbciDpjOvv6RB75O3xPOkoztb
	 E2WrklOIyE31d5ihmtf1eU19/h5sgjEkWSyVCL1+EiHWSULbkCz8Z+huRrBx9Wf1W2
	 VjMa5TiutOPWFITTn3CAH/66GRwQH3FzEqyWggJw=
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
Subject: [PATCH 5.4 276/321] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 16:03:14 +0100
Message-ID: <20241212144240.881659284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index b396c23561d63..bc06016a4fe90 100644
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



