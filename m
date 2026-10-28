Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211775;
	b=oYuJ8dODRx+ggd0rawnJ+MgQSszzYsMzNgHrHu6Qih8cPOvkr9qp27b7UHmF6ckr/eut
	 mj0SxMRz/MBLxhZguDtkc6JwvzV6DPhCtDK4B8kXFQeI8XgXBt6WGdcorP/AxKWC2pBgC
	 6CD/cUOa0bwPEmhx44ix3zk7BtxYiViyllMo29NbyctYYaaNZuObGs+0xoXNrVTMegjDA
	 9WrlVZn0gCvaml4dmFWbMtTvJ96/RIdPESfeC3n2SOEROht42YryKSvdAJFwnc9iBC/oT
	 +Q+HBiwm6+qoZDtkIBS4NexHiZkz3GExDz37pLi27CHK5dElzTvupLXMf1oy5noZ0BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CmJAh1oG28klg+w9tmugjsgo5xGjN/n2v64eq1H8DaA=;
	b=PfDCNoE00kPFA0AheFQsqnNEa8pLSgawKd77k5JiXcmjmjnWaNyl97o8tOSu1eAHnliW
	 3T1cTIUheTg8d5C+g7QDI1V/Hs4lctrCj4Jjs+U4MEcewtPbVOkxtqwMXuOqj8ACeGLxG
	 9CI7k0Qez54FRYzyLc+U9MfRDDDUMDQRk8mGKMKDifDiswzPoGb4+8xUGSM/5J9+4ndCo
	 wUEo0T1+hbzza7PeBKxjSdgJMBGdECfxxhb+fGt6mkG5K2cvT5ioD07QjXt7IBL7KyUKY
	 yK/lNhymrZ8EUFggMW20iBCe8numYJx/YzN9KhwzxneRfKTl7/1PBfLLaPdYYTE4nvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWbqs2IU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4405060A263E;
	Wed, 28 Oct 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWbqs2IU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961991F031E5;
	Wed, 28 Oct 2026 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211775;
	bh=CmJAh1oG28klg+w9tmugjsgo5xGjN/n2v64eq1H8DaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWbqs2IUhsS6A0qH99kHgaFNhFtJkN8gfHwnmyiia7pQRmu/SWQs3JfTOSgRiFZBk
	 558FQ9ZnUJaiAciuE7GG78/HhY6ddw1c/dDHJqxa3zW6zA8fvvOkGFeOM2qKakuTDj
	 +8Lz2Kj1IEiLpNV0UuhiBiN0t/ZEaqGqUiuHaqSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 495/571] net/sched: fix use-after-free in __tcf_action_put()
Date: Wed, 28 Oct 2026 18:00:42 +0100
Message-ID: <20261028170019.772827574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,9 +137,10 @@ static int __tcf_action_put(struct tc_ac
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
 
@@ -147,9 +148,7 @@ static int __tcf_action_put(struct tc_ac
 		return 1;
 	}
 
-	if (bind)
-		atomic_dec(&p->tcfa_bindcnt);
-
+	mutex_unlock(&idrinfo->lock);
 	return 0;
 }
 


