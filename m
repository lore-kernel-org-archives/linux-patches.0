Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209387;
	b=b4VZej/+OFGfUHytt2s2nzv9gb1gd8e4DyX3YnCm9O+QZsKGZ8nO+CujDNfAFAxLC5i0
	 FhjgzYRLcO2DBG3E6MUd6gKcEyr2lgO6KjeKQymbMHiXuksYQNkQ9Aa2WOLOmNbGr6x3M
	 FOEjarf8EB2Eh5TnoiD0/RlBEN8VEIyQB0BgxVlsV9Hi1Fx3STF19khKQiwv0wbhT/g9J
	 G6yWkqtJ7tB2o7pEAcqY4N16UzFOgi4sqvEuhv+28e4/Ye/xtKf1IaLn4/VjGglSqIAEs
	 3vXIaeFL+6wL422mEONO1FWT8mjz7WSQ1FE8lNKTz5Pwn3SDwjOvfa/22U86UoPevxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3QluMBr/vW8jOURz1nF6HqgQ04snsDW4/PoTPc4aJ9w=;
	b=lNYhgrnkFWIVKebCiffcfxranOKgZR3GqxjbxI29m2+fnj+CtnIg6FGrtUFa3ZfUwfy4
	 5gi1XUPpo9gcVyQoDPM2z1na7jDPmxOjAP7whEa2eyPCzuytIpWCTliO1snqpYC2X9e2+
	 y4kmpyT1U6KP5luSRXV550dsi0zAsVcFBP6auhUqwd93Nujys+R4/fEeDQITBv+FZDxBA
	 yE29DvmUjHpv3uzHNyIB1SrJOTIzrr3XQKmngyi4DyFXUoE3rvNcDYlV+HePNMPfVQm2b
	 SwZW49bi3ody8Vs6UdG9mFgz+dv56gy/0k6LuqStXrKr8H1xfgjQRF6BGIhFNE3Ubhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="idFIcPh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA94606A31D;
	Wed, 28 Oct 2026 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idFIcPh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD3E1F01825;
	Wed, 28 Oct 2026 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209386;
	bh=3QluMBr/vW8jOURz1nF6HqgQ04snsDW4/PoTPc4aJ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idFIcPh/tsadGrKhDA4/b9hDvnNmhLoEQCTeQqtKi3jsvmQIsw3wTyULQ5vHy84So
	 JCksgrB/M/Wcvwnc5ZGh+yyoyShfoabMctYgp55j/i7Fd/ZGG2I3ztZRQ23fADQybW
	 OHdgbe5Srav+g+qYwHpmalwm+3WO2m8hzaEW94F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 452/516] net/sched: fix use-after-free in __tcf_action_put()
Date: Wed, 28 Oct 2026 18:00:04 +0100
Message-ID: <20261028170014.190169332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,9 +121,10 @@ static int __tcf_action_put(struct tc_ac
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
 
@@ -131,9 +132,7 @@ static int __tcf_action_put(struct tc_ac
 		return 1;
 	}
 
-	if (bind)
-		atomic_dec(&p->tcfa_bindcnt);
-
+	mutex_unlock(&idrinfo->lock);
 	return 0;
 }
 


