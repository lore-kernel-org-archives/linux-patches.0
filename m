Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037716;
	b=LwVwT+yoGAtL0kDCX9XoyOMo5TB5TjjYId1pvYlOFYN0W3f5OP/YBRLprwcDiIqYlugI
	 D6sAwf2SXqsaxkumGEI2vsKZV9GzI9aJ5YD+jeEUpZ6hohwNFZK6WeO8D19VZVbXr/XKG
	 kglW8IZfT3jodqdSh4o5liDUV8GshIAIYodmcLcZrD6lWndugW04nnVOaxSu3O8ehnZOE
	 mcaaC40utqOMaDPPjieNYFwZvMF7ZgHhC6HuejJpztTB/nWdUGeCLmKqpxA2HXSCebwMp
	 GevNhjhwN/Nk/32cRZTPAhK9noYqfNLUx1fTy3+qTzdg0CzVOKayhgZ47EJGyzf5NIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYdVHDKYBy6oL0jRrJlo5I4BEFUmsLqMA+c1l6c50/g=;
	b=KKAbx6Dl5SamMiGOVQEzQXbC/LTNRMAVGmp4wzifrq3iBd/6pZsuORvVbQiL8IIWbyfW
	 DloGCH25IpIlbPqjlVGw1QDPu/CRzfOhaS7Jk7+wdFuBcN3BUMzQtFpCFfnF44t3WLqwj
	 IGyhX+Ry1/d+h1kcrvzubvUN/BJpRoT6z4jWYPAVN440CGHomnwvFlc3l7MwVQid/b166
	 lOGSbYC8Qs8IUq3CPvFVU6Nbz9knJY7/jIjobDWlMl1eTKWGoHFD0SVsVEdB+svEc4jPc
	 b0MGRYXMg//KOGf6aE3RzkN+nHqpfEPKcluTLnRv95X1njw07wSYMxWhsYPb7Tyn5Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I339PBYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C732606A31C;
	Wed, 18 Nov 2026 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I339PBYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560881F000C4;
	Wed, 18 Nov 2026 21:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037715;
	bh=SYdVHDKYBy6oL0jRrJlo5I4BEFUmsLqMA+c1l6c50/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I339PBYxmCqy581mGLNf/2FqMPqxKm46Vk1g0/mLXoWGF7qsYHmCGoYxhsb+pMSNA
	 u3063GIEmZJ8sLcHbFQH2nRLiUE4iEq2oECCerzkXEnANgWB82C6QaamDcj4wecSVF
	 Xa6F7BBSBDXqgrUgKpj91z2foHXDWCSxm1rJBfH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1494/3318] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118150405.728401421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 2e54b3e187300893688c2c7517894f5d96732e05 ]

qfq_change_class() snapshots the current aggregate settings while
holding the qdisc tree lock, but drops the lock before selecting the
destination aggregate. During that gap, qfq_enqueue() can move the
class to an aggregate matching the requested settings.

When qfq_change_class() resumes, qfq_find_agg() then returns cl->agg.
If it is a singleton, qfq_deact_rm_from_agg() frees the aggregate
before qfq_add_to_agg() immediately accesses the same pointer, causing
a use-after-free.

While holding the tree lock, skip the replacement when the destination
is already the current aggregate. Any estimator replacement has already
completed, so the class change can finish normally.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Link: https://lore.kernel.org/netdev/20260731140533.566493-1-david.lee@trailofbits.com/
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Link: https://patch.msgid.link/20261029180957.43015-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index e3b1921aa7dd3..b7e94255e40ff 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -520,11 +520,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		sch_tree_lock(sch);
 		qfq_init_agg(q, new_agg, lmax, weight);
 	}
+	if (existing && new_agg == cl->agg)
+		goto unlock;
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
 	else
 		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
+unlock:
 	sch_tree_unlock(sch);
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.53.0



