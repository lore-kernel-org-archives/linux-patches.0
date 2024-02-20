Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E0151CEB;
	Tue, 20 Feb 2024 21:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463434; cv=none; b=Gnpr8C7llI2MbYQH+imbZLeVc0x/IIF1NoW8bROYHrvVUPtkZ4qQhbfCc6FxrAFBWPAJ2EyGLjUOayRGXndW8axo8XrIOIqkaWepCXWljLVgkTpSGt1qM1lTJj7DDirfwuN+lOJb45svE5Vxs8JSUhSfEZIkd/Wr8WXWhi0CWfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463434; c=relaxed/simple;
	bh=Qd2xb12tuW+MHJHj9ZzOcQbkKGwnqpZjtOANyJuWLwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckgzFo8YV95xgpSAqHcoOQ58iVBlUSlyX3sQE1mDU3xvER/CcDVMGJ+P7NHm6brlCyD4TTotV+nTC2uU3mM3KyC7KpgF23xjBIGe2BpAWG0wCXlWrveHB/97Y1U6eFbvgfTdwRc9tV676/fdMXOD20l8029r12HZg9/D8rzXbC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MofRNAXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MofRNAXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C36C433C7;
	Tue, 20 Feb 2024 21:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463433;
	bh=Qd2xb12tuW+MHJHj9ZzOcQbkKGwnqpZjtOANyJuWLwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MofRNAXO8Zt/wKpv3wbh9x5IjBBBdwNcN7QoPCpeyLAhGVH1CbgPbwkZwJ+QCfxC9
	 EcciIa+7oSIPUb30B9Jv9wmVrsI9aw12l2MsmqXMJQDyfwQt+xOC1zHUfNmoynIJGE
	 DlCnAFhgA0HOb3RUH7EzAy6KXHjjD5s/7QoHiQcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/331] tls: fix race between tx work scheduling and socket close
Date: Tue, 20 Feb 2024 21:52:38 +0100
Message-ID: <20240220205638.935740477@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e01e3934a1b2d122919f73bc6ddbe1cdafc4bbdb ]

Similarly to previous commit, the submitting thread (recvmsg/sendmsg)
may exit as soon as the async crypto handler calls complete().
Reorder scheduling the work before calling complete().
This seems more logical in the first place, as it's
the inverse order of what the submitting thread will do.

Reported-by: valis <sec@valis.email>
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 650080d5fd72..0b47acfd6a7f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -447,7 +447,6 @@ static void tls_encrypt_done(void *data, int err)
 	struct tls_rec *rec = data;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
-	bool ready = false;
 	struct sock *sk;
 
 	msg_en = &rec->msg_encrypted;
@@ -483,19 +482,16 @@ static void tls_encrypt_done(void *data, int err)
 		/* If received record is at head of tx_list, schedule tx */
 		first_rec = list_first_entry(&ctx->tx_list,
 					     struct tls_rec, list);
-		if (rec == first_rec)
-			ready = true;
+		if (rec == first_rec) {
+			/* Schedule the transmission */
+			if (!test_and_set_bit(BIT_TX_SCHEDULED,
+					      &ctx->tx_bitmask))
+				schedule_delayed_work(&ctx->tx_work.work, 1);
+		}
 	}
 
 	if (atomic_dec_and_test(&ctx->encrypt_pending))
 		complete(&ctx->async_wait.completion);
-
-	if (!ready)
-		return;
-
-	/* Schedule the transmission */
-	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
-		schedule_delayed_work(&ctx->tx_work.work, 1);
 }
 
 static int tls_encrypt_async_wait(struct tls_sw_context_tx *ctx)
-- 
2.43.0



