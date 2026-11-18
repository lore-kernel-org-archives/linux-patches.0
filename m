Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039721;
	b=QKsdp6NSSAU2Gx/xhvnqYXlvDQvgwMDb4QbtGPHU9nXRDquihsWIztzF/OaDABx4+w67
	 U/GqC6DAgBgy7DY9yfITMIwA+Hp40jyJEZ1fE5rELace2dsAFa0jk9Cm+Kc3mljvaqVZL
	 VemM9LTsQ5C/njCtn1c9LAUaSQJ1WrgCdzkhQRaFoDag396ZHMmGW2BCWLidrkK3VMRFu
	 RcrT1rztJGvE69igKN7aVUmatY24FMmPaG67nMQW74Zw7TuE96VRxCqBmnP72KzouBUNo
	 ayXRETrkPsNDUUYHIW1sxfxiPtAWuEoaKWcHGYLu7s/eHJsQUrDBwn2MZbNeZR/SSfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHkJn1+FnBsoq0EdKYiYyk0lPSGNZZsPiNuQAdDBdI8=;
	b=azEVGjfxlKFVERlJ8mTbs1ZSgS0uOiJPJ0CofuuI1ltspVZwERBUy2paayMV3t2tkY3p
	 HsuUheDVY46YSaJG8CA6TTzLzAIHX/oxreAB7zx3ASL1THOML+pDcd08VORw1RL2w+nLL
	 +tK0HzH+Sjsu9eXPE4Za4SZ4hpSCIAW5/VwykSjoXjk/F2TIuOuohTbY6Pkm48UU85rSn
	 EzvY1p0w/zwHoVlMMGEBnV4MifyvmYuHbmCEElzK+j1TH8bVQQ58Ry9+oI12eFxZ2UdEx
	 vzKmAx4tOpS9xEErsOPhyIEapKhzkKTqLMXvmt6httK1nMx+nrAjW1lUEkHarnGSWRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyHWiPE1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17164606A32F;
	Wed, 18 Nov 2026 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyHWiPE1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6633B1F000CF;
	Wed, 18 Nov 2026 22:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039720;
	bh=oHkJn1+FnBsoq0EdKYiYyk0lPSGNZZsPiNuQAdDBdI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyHWiPE1f2gpJe0GuFp34jYYfo1IH6gFe8/3JIyeoDsB7DouYZa7hVggN2mUS6OM4
	 8P73fpoz3kvjvhOEMlvu4B2OXsCcW+7f7er7Xl97FNtR6vy8e3jvSWTHzyAZ0ZpL1h
	 OrLX4hIxMy5Q+6LSHPZ8S9EN1Ck5Mq6nEdfqWn4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2184/3318] bpf: Fix program BTF use-after-free in sleepable programs
Date: Wed, 18 Nov 2026 15:46:46 +0100
Message-ID: <20261118150427.482422412@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 88c9c6d0a766dd146545990053e8a04422ccb367 ]

Object kfunc calls embed metadata owned by the program BTF. A sleepable
program can remain active under Tasks Trace RCU after its last reference is
dropped, while program teardown releases the BTF through ordinary RCU. The
invocation can then dereference freed metadata in bpf_obj_new().

Move btf_put() into __bpf_prog_put_rcu(), the callback that frees the
program. When teardown is deferred, that callback runs after the program's
own grace period (Tasks Trace RCU for sleepable programs and ordinary RCU
otherwise), so the BTF outlives every active invocation. The non-deferred
path invokes the callback synchronously, so load-error cleanup stays direct.

Fixes: 958cf2e273f0 ("bpf: Introduce bpf_obj_new")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260901014829.3504342-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 599ae0b135916..c92ee2b5c315e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2144,6 +2144,7 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 {
 	struct bpf_prog_aux *aux = container_of(rcu, struct bpf_prog_aux, rcu);
 
+	btf_put(aux->btf);
 	kvfree(aux->func_info);
 	kfree(aux->func_info_aux);
 	free_uid(aux->user);
@@ -2154,7 +2155,6 @@ static void __bpf_prog_put_rcu(struct rcu_head *rcu)
 static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 {
 	bpf_prog_kallsyms_del_all(prog);
-	btf_put(prog->aux->btf);
 	module_put(prog->aux->mod);
 	kvfree(prog->aux->jited_linfo);
 	kvfree(prog->aux->linfo);
-- 
2.53.0



