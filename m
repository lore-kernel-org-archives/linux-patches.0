Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6BE1FBC
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21AAC433D2;
	Fri,  3 Feb 2023 10:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420234;
	bh=ZNSTPP3ZQMAJpdMRh7exURaiUqOp4M/G88TFEnNCM/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgMZAGnAo1+aP9lFff8WHfHgWXNdq/k7u88ykTgLaAToDX1DtMT8/puhQofNlT2+2
	 DHvIfKLrEAb35v1/3/gfWJapJke9KaI3LIGmZbVUXaEL8h8ARcrAcnsxtfBuBSOkdk
	 S2TdOxJ/EDfSGZkBYTm8qMjQHUa887emBhxj8M68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/134] sctp: fail if no bound addresses can be used for a given scope
Date: Fri,  3 Feb 2023 11:13:20 +0100
Message-Id: <20230203101028.137618596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 458e279f861d3f61796894cd158b780765a1569f ]

Currently, if you bind the socket to something like:
        servaddr.sin6_family = AF_INET6;
        servaddr.sin6_port = htons(0);
        servaddr.sin6_scope_id = 0;
        inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);

And then request a connect to:
        connaddr.sin6_family = AF_INET6;
        connaddr.sin6_port = htons(20000);
        connaddr.sin6_scope_id = if_nametoindex("lo");
        inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);

What the stack does is:
 - bind the socket
 - create a new asoc
 - to handle the connect
   - copy the addresses that can be used for the given scope
   - try to connect

But the copy returns 0 addresses, and the effect is that it ends up
trying to connect as if the socket wasn't bound, which is not the
desired behavior. This unexpected behavior also allows KASLR leaks
through SCTP diag interface.

The fix here then is, if when trying to copy the addresses that can
be used for the scope used in connect() it returns 0 addresses, bail
out. This is what TCP does with a similar reproducer.

Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/bind_addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index a825e74d01fc..614bc081ca50 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -73,6 +73,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
 		}
 	}
 
+	/* If somehow no addresses were found that can be used with this
+	 * scope, it's an error.
+	 */
+	if (list_empty(&dest->address_list))
+		error = -ENETUNREACH;
+
 out:
 	if (error)
 		sctp_bind_addr_clean(dest);
-- 
2.39.0



