Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774689;
	b=MlblXkyNUsBJ+DPvPfqX3tuk3SXyD5gHQh7GN+LL4OStvtiiLZo9Kh3KHDFqYVDf2zOH
	 5ALkpYqiZdIefjkpJLeh5MfVVKxcQgHPTdqccA9O6hgVHz1fzdtJJyVEELUqUCBVm2vVO
	 N62awML5UWNGHvDf59hJE6QbeL/PM+/Mda+WtcevwcKK9EINE48pS0Dk1tJm8Qp1s4wXK
	 FxR4iH3WsKp4mScV1iXLUKfvZKzI6IZ0PCaK4eRrkYiegiQ6GcbWBrCFpb4H6n47NHSHm
	 K85JCwdwTZjOfQAoESaZ9dkjSPvzt919AhYekq4IDfF94vfFJsu58MIYs47WfuEusGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HKppwmqSEhU6sxuNMhVpvf34Cp9ozmCkgFogIZx75HM=;
	b=X9f4vJj9aVsNzkmF8LNjbTQ85xTDLlGNO2O+WZhYZkRck/xclxZLf6wG5WJM0c4+T0wp
	 Fr/XtqQg8LFYs4T+mmpmHAiUKWuzzB5IwICzhkFXyGh9TToYKC1R6XA4Y2dZd14Uapk3J
	 XYpU59lYiSEvLqenRkcet4zLiMfMKx+R8mhRf2U7BPO0g5Ys0k1mZAkO77RWHtcIX375e
	 Sc+U5m3M+JC0tMAvRfVUmM5rW9vQfjkNFxWtnJ87wE/81LnnqP7NleEdJFkW6xoCl0QDP
	 O3FQPxzfEgsOEQmE3BvEj0t8VzyNIw+HY/fB1kD/BWbaCVoY0BMbF1H8qqSyT1HCEsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKaxI1aV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CF606A31B;
	Fri, 23 Oct 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKaxI1aV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5081F01825;
	Fri, 23 Oct 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774689;
	bh=HKppwmqSEhU6sxuNMhVpvf34Cp9ozmCkgFogIZx75HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKaxI1aVbTSxOILrqUIOs7C5aqYUkfQFw58GZoSJGZ/6G2moyWE2B/Ljixt3BaTQC
	 B+OTC0jaF/AjPHoLcKsB5XuM0dwT+1SrN2YlDvVMwurL8U+WptRSZ8Jpvn1GzExWj2
	 7REjuCrRh/cxiGxfSkEN4X8dBlz45b5da5M30pak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 124/242] net/sched: fix use-after-free in __tcf_action_put()
Date: Fri, 23 Oct 2026 18:39:26 +0200
Message-ID: <20261023163716.715244511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 7b16eb911091aae237a8673da94e4dfb9cd21d54 upstream.

__tcf_action_put() decrements the reference count before decrementing the
binding count. Another thread can free the action between these operations,
causing the binding-count update to access freed memory. KASAN reports it
as:

  BUG: KASAN: slab-use-after-free in __tcf_action_put+0x327/0x340
  Write of size 4 at addr ff11000000d46420 by task tc-put-pause/64

Hold the action IDR mutex across both counter updates and IDR removal,
keeping cleanup outside the lock.

Fixes: 16af6067392c ("net: sched: implement reference counted action release")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261008181348.527035-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -372,9 +372,10 @@ static int __tcf_action_put(struct tc_ac
 {
 	struct tcf_idrinfo *idrinfo = p->idrinfo;
 
-	if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
-		if (bind)
-			atomic_dec(&p->tcfa_bindcnt);
+	mutex_lock(&idrinfo->lock);
+	if (bind)
+		atomic_dec(&p->tcfa_bindcnt);
+	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
 		idr_remove(&idrinfo->action_idr, p->tcfa_index);
 		mutex_unlock(&idrinfo->lock);
 
@@ -382,9 +383,7 @@ static int __tcf_action_put(struct tc_ac
 		return 1;
 	}
 
-	if (bind)
-		atomic_dec(&p->tcfa_bindcnt);
-
+	mutex_unlock(&idrinfo->lock);
 	return 0;
 }
 


