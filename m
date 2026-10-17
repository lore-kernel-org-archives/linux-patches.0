Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CB23B7770;
	Sat, 17 Oct 2026 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259686; cv=none; b=FtYr+PHHaTw9ntCS6CHEvNHumHO2+/CpPVnZbTbdnsO36ZfIs0ayrtQG8JGBjFj6h24IqNbUgy08mpyyHICwrm/CbpD5HGnDTbpqMiIBIn77wlxZd9XzVWWkvc55qQW4CQNMO/T4wNLMQMjVX+z3An/dUEsz0a06FN4udLigjjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259686; c=relaxed/simple;
	bh=bARadvg5yOWKmqgUs3iRE+IW515bNVDu1MyoXKxrtj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWi6/WGgyhEM2knzyATKL3KK2mkwewZRSCTIjq8/FdC5GxyseTPDptC4op/gXsAuhRxbMdRCvROsG3P6yYKjpOBFzs57N5yg3POOeHtB0P9jOYd5xcHY6aIvFy/F8FTNl4OH6TXeJorteU0pr8KbxVEXACUacDcQMtT7Ey5jyRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRn3BX38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRn3BX38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7E81F000C4;
	Sat, 17 Oct 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259685;
	bh=zBy5o09Q9gDQKdj32GpVJ6rw+b793kf0ou1l1iy/9sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRn3BX38mr0VWdtHGQ6byJU87LC+sp3Auj7QR7+33d53H4MM1LamSpZtZm41BCe5e
	 TXYOJB7shrDWFWxLJFfvmHisPC/N2bBLWHg5tlO9QldwBOcdlHKIMkHyseH9rSY3Og
	 6RlFRt/jVTmKgG1uclGRdA9333EldyTBMym10pCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1296/1674] sunrpc: defer rq_argp and rq_resp free until after RCU grace period
Date: Sat, 17 Oct 2026 17:59:28 +0200
Message-ID: <20261017160504.411338519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 145ba93a9c019..93a93e11ec4fc 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -737,6 +737,15 @@ svc_release_buffer(struct svc_rqst *rqstp)
 			put_page(rqstp->rq_pages[i]);
 }
 
+static void svc_rqst_free_rcu(struct rcu_head *head)
+{
+	struct svc_rqst *rqstp = container_of(head, struct svc_rqst, rq_rcu_head);
+
+	kfree(rqstp->rq_resp);
+	kfree(rqstp->rq_argp);
+	kfree(rqstp);
+}
+
 static void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
@@ -744,10 +753,8 @@ svc_rqst_free(struct svc_rqst *rqstp)
 	svc_release_buffer(rqstp);
 	if (rqstp->rq_scratch_folio)
 		folio_put(rqstp->rq_scratch_folio);
-	kfree(rqstp->rq_resp);
-	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-	kfree_rcu(rqstp, rq_rcu_head);
+	call_rcu(&rqstp->rq_rcu_head, svc_rqst_free_rcu);
 }
 
 static struct svc_rqst *
-- 
2.53.0



