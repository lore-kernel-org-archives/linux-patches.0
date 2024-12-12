Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC36213E6F;
	Thu, 12 Dec 2024 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024738; cv=none; b=OBZZuPyTW035++8H4nKwX0G691jLCsBMAy0BiOlfDNWkpmaymYQWXmOH3u9cczBcVklFygREVVzWFDjNzqqd6yAz7G6a8dofvyUEc5KWlCu30rLvYT6qouPBW4YD6KYeGIojBYnH555nEMHnj9kJprCvVpS+tUs72ZFBAM10ljs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024738; c=relaxed/simple;
	bh=QzmlyQ+sIlatfFgy5H1f1PkNLmEcrD72h4sJpqTZslE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgcbHu2/8+19zL3KaSfPQifc2zRfUFzuzsQ9LULORgZXQj58Lu8HAWMTqCsekdCrweV+WgxAij0pC+2GOqC0XApAYUkPB5exqUvgVXm1phFqXV5UTfweN4//S5mseNw2CQ0Xx0d8oWVkO5nhquq/6rSL+d7aBsLv1lZeF7vqqas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxzIKjE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxzIKjE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C7C4CECE;
	Thu, 12 Dec 2024 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024738;
	bh=QzmlyQ+sIlatfFgy5H1f1PkNLmEcrD72h4sJpqTZslE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxzIKjE8S9sjKvQpqvGaPKOLIsNcht4pSHQMMTMzfHvggvJ+11j/a9GFARYmi/IBt
	 1J/EQx0gp6PEltQ3rd29u27wo+4CTXFrrfXeyUryZFvMDzy8tMMCwbX+mTMsuOwrid
	 msWXFPkTgq2c1lgUsuU19CzKctkYZXsGdK+k95gc=
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
Subject: [PATCH 5.10 396/459] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 16:02:14 +0100
Message-ID: <20241212144309.406505337@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 79f24c6f43c8c..de47c16b134bf 100644
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



