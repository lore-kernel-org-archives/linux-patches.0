Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215988;
	b=rKWX/gRB9pHx2uLqQQfjPrXsUwIFdHPc8c0SSXgjIvdEWqPpDyV++rm8cwXuezX9PTHW
	 ib7YLo46dr3XeH5fxQzXPWqnALL1xESoEniItRe8Oc6drwPDcHBnzcg4Y8BQaiLaaIv4g
	 6gbROYbyxShonZsoXp8pu5eTvzFYJAC3qtEBAm9p/Jp9Xu9hgbr6xgyrqvXMGHIlSqHku
	 jvo0IzckDumJ/AXJ6mWG68VbNc7TmBFW6rnplegR3ueo8EsmRws2Q47xJxI9myx8iH+5o
	 Lo7jb1pDqJgZuNn/SStrYi8MTWQIO/cJlKGUp8wCt1GRcC9DYtlvgpIzRfNHIBJr5aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zC8MHL9HM8n1hvnL7spU7dwkP97jNMJoTsbVF2G/Css=;
	b=lVxKKqvsdKEfWjxEqTBwHpyCrhvtXMUpuZzO1RIXtmAehvsFnDOKNdkH7bYKofcO1OYO
	 oNLpWhzply26UhQ8VM7RJ+UTxiaPaJo3zRyssk8jEZzNTF3WTaxvrtqK8mWl0dvjvHbDp
	 NbDCJysKpFIzKbFfsfcNBu9uMkrEVX/X4xqsERHptIvrtgeYbvIeQ5xgdhpKvL0WqPFgV
	 B+43DcDms5FGfE3Ixqyj84gDR54wifWy1XdPSMetsWMLQvcBLQ//ZgTikjDybnvz1hcfm
	 NZisg0Ifgwzw7UtAqEAuetZ0WVbUoHoUZMv2jqKpSuy4Dw4dA129aTzD1euaEfEyEtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eZa//mQe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5A1606A31A;
	Wed, 28 Oct 2026 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZa//mQe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F1C1F01825;
	Wed, 28 Oct 2026 19:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215988;
	bh=zC8MHL9HM8n1hvnL7spU7dwkP97jNMJoTsbVF2G/Css=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZa//mQetMUjmFTiwOvJMefuCzYPRkLsW0+o7P02WNeQwFr/2sUEl+oGc0sSWK3LF
	 u6ZE8il5HPoC+XSmWlR5i2gqjQpU5yPH1QbS/AKDW6SZBgitB1cihZBrLOPgcghhfq
	 689RW4pT2rq9JhPBdxbJfDGvBkR/Mwa+IDXfMdq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1401/1887] sunrpc: defer rq_argp and rq_resp free until after RCU grace period
Date: Wed, 28 Oct 2026 17:58:17 +0100
Message-ID: <20261028170531.331835000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c479bde671cbe2f9e152834a8b0eb7c3c295bbaf ]

svc_rqst_free() frees rqstp->rq_argp and rqstp->rq_resp synchronously
via kfree(), but defers the rqstp struct free via kfree_rcu().  After
svc_exit_thread() calls list_del_rcu() and svc_rqst_free(), there is
a window where RCU readers that started before list_del_rcu() can still
traverse the thread list and find the rqstp.  These readers (e.g.
nfsd_nl_rpc_status_get_dumpit()) dereference rqstp->rq_argp, which has
already been freed — a use-after-free.

Fix this by moving the kfree of rq_argp and rq_resp into an explicit
call_rcu() callback alongside the struct free.  Resources not accessed
by RCU readers (bvec, buffer pages, scratch folio, auth_data) remain
synchronously freed.

Fixes: 812443865c5f ("sunrpc: add a rcu_head to svc_rqst and use kfree_rcu to free it")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-4-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 112dc001459d0..ec977c5c43327 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -874,6 +874,15 @@ void svc_rqst_replace_page(struct svc_rqst *rqstp, struct page *page)
 }
 EXPORT_SYMBOL_GPL(svc_rqst_replace_page);
 
+static void svc_rqst_free_rcu(struct rcu_head *head)
+{
+	struct svc_rqst *rqstp = container_of(head, struct svc_rqst, rq_rcu_head);
+
+	kfree(rqstp->rq_resp);
+	kfree(rqstp->rq_argp);
+	kfree(rqstp);
+}
+
 /*
  * Called from a server thread as it's exiting. Caller must hold the "service
  * mutex" for the service.
@@ -884,10 +893,8 @@ svc_rqst_free(struct svc_rqst *rqstp)
 	svc_release_buffer(rqstp);
 	if (rqstp->rq_scratch_page)
 		put_page(rqstp->rq_scratch_page);
-	kfree(rqstp->rq_resp);
-	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-	kfree_rcu(rqstp, rq_rcu_head);
+	call_rcu(&rqstp->rq_rcu_head, svc_rqst_free_rcu);
 }
 EXPORT_SYMBOL_GPL(svc_rqst_free);
 
-- 
2.53.0



