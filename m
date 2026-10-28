Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216954;
	b=y6lik8OM2lrVU/DEZJG1Zf1nyo1hxYlJZeqTEfxFtWoj+ciXt2MgiQn0ajJpNHR8yXKU
	 RtASxKyI0oJwFk2E3p2ueBIUZeNyC68gsDV4AevQFFzt/OLHHfULveSBZN5oaXe0aJ5fg
	 yTH7d58dBjznZ1BU63XYsTHCwm9BrYaIv67zsn6ZMnjM3sjA1SCczto4f4LlEKLlzW1P8
	 rWEVkm19ucwSpoGpYdXmjkhfoQsyzlBc+cjRHT51vledamhK3tTI3LY3YDVaMLgGBWQ6m
	 GhHcTPo9buT2bpvgXrpnKiHFVxRo7IglBjSaTQW2Q+fhR3KBpqmf60zFanbe/5ku+3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pssnl7d53xlnbK5oBdxAlVFJYjsDSQpLAbpD0DSho8E=;
	b=s8I+2n5qVLYSbsOfrdv2lnK1CpAPNE10ux+FSwDisy7BDfrRrd45JFmRKUdHKC1NqsqM
	 j+977EQSRNNjId1j0xeWSY++kvxmKCcnhbAVJo9VAVZWgr4rqzox9gE5WQwMqSSzjPQQJ
	 JcQvGVArTi8TPMr/86GBfBi0Xc8q8TL+OO+0i7b/fm0Uklui9Tsh3HBtTekxg4IECWL6u
	 pOTG0RoE7AnWtPAq6f9h5hOegpugIHgjD5h8OmTu/1ORPleh7vw1pONtdKVPvBQK58L9L
	 06X5ZjPrYBYToWnGd5K4X/m/dGfIiFvVHMyFU2O33kLFIEuNCnHoioz2jYG5tw/p70w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp54J+PI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D56C606A31A;
	Wed, 28 Oct 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp54J+PI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A57C1F01825;
	Wed, 28 Oct 2026 19:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216953;
	bh=Pssnl7d53xlnbK5oBdxAlVFJYjsDSQpLAbpD0DSho8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp54J+PIaJIQWEoM0IriDAKoZBK+cffO+cdbXdigLvx8RdnqNn8sXLLxvndYsqbQP
	 0KhJX11mBQALVmHgRnmjWzG8DA5TXI9Lwd13Ed3oYbC87YgHdTLJq5NzhZJYb63ZuH
	 w0Fl57ISVHGXAbB8liDklpkCxNlCm2nwS8MCzPUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 1735/1887] net/sched: fix use-after-free in __tcf_action_put()
Date: Wed, 28 Oct 2026 18:03:51 +0100
Message-ID: <20261028170538.936097798@linuxfoundation.org>
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
@@ -378,9 +378,10 @@ static int __tcf_action_put(struct tc_ac
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
 
@@ -388,9 +389,7 @@ static int __tcf_action_put(struct tc_ac
 		return 1;
 	}
 
-	if (bind)
-		atomic_dec(&p->tcfa_bindcnt);
-
+	mutex_unlock(&idrinfo->lock);
 	return 0;
 }
 


