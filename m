Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207597;
	b=KNM0sD2feULdhS7TWZvRAGpsAQb8Rf8X5kubnAzJHWCMPuPp95csHjMPV+5aSXA3PXei
	 YFM4zwJnJYRj/RbfZaM+V3DitSrSvS2+EQIpAqAcYfBPLwMTRBHL4MllDPNYHERO9u/at
	 0b5F5a/LEOaMDisyDcsmuVVGMTtw7yQ1J3iWUC2NHpXYgVzkv7xG5rn+xMqrxPQIpPCSJ
	 MqEf/I4JX2c/W9HtT8HZtaXIPTvZIopF9rSd48xbLaJ5uPviYwn3+RVA9g+aLwFf2jFJd
	 1XpfqKThXAWm/d4Hl8RcEbCwe1zgd4BuU0frF+z88EaVX3KBs9Qu+hdINMAIw93pDew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UnI8P0uZ3POrwO0uDcnmkuzTJ1gB+hMppwaTtmZ3/HI=;
	b=M95A3U3VUS0XuGm1BQQox8Kn78IFhk4EqYwAxmSrtYwrGCAGqwc7TwX053U3eXhX9K0J
	 20oHe9CXno16IYeuOfD6wQntTTmKyJJKSgQBCbqH4rBtlwn65qw0+5snrmViYnVqIcSgM
	 m6TJmwdMyO34uaC8JVcJJ2rTrwQwC2yed9CGnlIJ3big7jJKu2eR4GbXCGGO23vG2oYLp
	 bgfHEkRoG9323/AcnJvTVAenRfhB/Rf4UbdUQooPn4IF5NSYbtpXfKqcYMtzv0jdY2SCB
	 nc/eUy3HeXAiB4dUyjEIJh8NZdbJ4bf0jmEUwYeZQd1cir7w/6Mn6Sy82i6v5X0uumw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFblOhGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39A7606A31C;
	Wed, 28 Oct 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vFblOhGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F280E1F01829;
	Wed, 28 Oct 2026 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207596;
	bh=UnI8P0uZ3POrwO0uDcnmkuzTJ1gB+hMppwaTtmZ3/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vFblOhGmsZv36IrPSf1MxwHf8BteBCPSxMn9IkSeap9rG0VZ8/jgAkkmpqugS7rP/
	 IOj9DpmjJpGaIxeRADsegxaDSVBXUguzxydSxyd4W9tlzkLqiPkVcpVpEYdW78mWsV
	 5hYhG4W7WYZgbuNjTzHklIoOUboBeIJ39P+wy9n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 071/247] net/sched: fix use-after-free in __tcf_action_put()
Date: Wed, 28 Oct 2026 17:57:54 +0100
Message-ID: <20261028165949.072676116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


