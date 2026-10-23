Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773997;
	b=WAWR4eCuKDkK5gzpnAcOmnWpETeJEO44d9Bbs/YODn09+5A2YIniK/m4otR2kgREW6vr
	 0snxcHpYXgtaHsAs/X4aOqL+8VgdCryD8lBo8BOhL2vOY2lnpV6RX+5sR9HSAF/V7zh1N
	 JnYhfd5GgOH5ddhZQnuhkPn2MMz1z9AOvzYpVdWHaEyOfJcBv5QekYELnLSJAJLuNRNGy
	 EaNdnMcLn0cHFeC1Yw+lfbGJ0i2esPittXddf13eIGEq7dyKZeUedoCUh/JQ+4xM/nUG1
	 leT56F7B9qXq/COqt/HVMd9Oqcgs8Ig03j59Z59VjOm7SvpQLSrwKHHNMsLra1Wpt6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MK/poevvOeNI4Cj2PMMYZQwgm4hixlNcoh1f7lPjTYI=;
	b=UL83eElWyuKYpV6LlAHjYm3+w9tAwxEI26k4zsKWaRnRodWaLojZr5oYwxk2Qu1/kKXv
	 g9Ntd5Cv1Jc8yGu3ov8MVU8kETR92rZypyyjAp2r9v5L4HgKTB61Bwl8Y+QAbJBKQtP+Q
	 TdFnq725Kktyoq4jIzPD9/1taL1TFhei+SkqUawvKgxsCOvVNVPuI8d2QBjhUyA/Bt+uE
	 Rx7YQVb0WmgQu/+5chw0PoEAUL5gK99ZatoS9/EEkIc7xq10rU3PjJFRwSGavPUYl3ym/
	 CNJ7MJm/g1y35gqO7Ta35gOY9xm4X8fPC+nln89xkOcqY8n6a4vrPuPcAUvd+AwdFzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6djHWCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D1606A31B;
	Fri, 23 Oct 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6djHWCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953001F01825;
	Fri, 23 Oct 2026 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773997;
	bh=MK/poevvOeNI4Cj2PMMYZQwgm4hixlNcoh1f7lPjTYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6djHWCLZsRYRQg//DX4tTMmCoVSmwskyUNa4pfmP2S0AQ7ycwWuMKdL5rtEr5PTR
	 +/wzTBPZc4f+jqOfhAkobMwRbZ9MllxKp6quT8nmCJozKuBciWwKQ01sK9K8w7FhuS
	 GhE8RmrP9yRsR8DAKxzDxFld1lRoJGLYIwfZmv2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 085/193] net/sched: fix use-after-free in __tcf_action_put()
Date: Fri, 23 Oct 2026 18:36:02 +0200
Message-ID: <20261023163716.218615349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


