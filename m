Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215085;
	b=AU1rTE1cfX8zFo4BgXTRrb+LaV9Z08X3gijajfzoGtIZia/GtTpyqn054g8gfNoQzZ4r
	 qOiSxaMoaOefKINTjywxlBWIyf/tiwrFHHwefX5pHlJJmAkRR3QMHdNYzxcT0YlIt6VH5
	 nJF92HtKYgh6kvmR+PBYyyreR31Sdi9Otq6vjhTotsn7Ot6iV5xBRFEXuwyKAgrBUH00T
	 775+Nu4CsQO2ljO8+94yizJOfeMeT747GSWZgWbY60l7lmnEuKpAG0LD5Uga2WnfEIJMk
	 TiWqk7wq+DcgzU5v8szC4K0wWowtD6R0c+LsdeKOdqLDY2QGLmkWydPCfPlzIs0GI5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGHzK9FS+fD9hpLldIzpZh4R0GE/DkqHNP34XnGeKuc=;
	b=c8HbVuaiHpVcBa/BP+xvTWTZbweI2O6WiWE8LsBJrqR7gv17YLJlkBxbL3kyXUMHdAUb
	 SvrQhGQuZz56xKLaAVgMik8L2ZVlJNvd3uYSBTQY2Wlr2kF2LtGUvhywDohlDSC9MN2Ns
	 qUsxokP4fJiO5kyr5Ow3viqpDQGVNyd+GtUCD79FQoe6/8EsLnM9Ev69LdZ6I38Bthrag
	 rENkhf7e76MXJ6AYScQi2X9TD3TPpFTe+wIXyWhwei62AtUZ8Gl/G78Pv2KjCgccmLN6g
	 NVsxuhMNEXpzNoOfUJrgsjEbeG5yQStTa1UD72qnnFzPHJ0S0irqRayb2iBfUGlGNCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/gRcB3P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68691606A31A;
	Wed, 28 Oct 2026 19:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/gRcB3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6511F01825;
	Wed, 28 Oct 2026 19:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215085;
	bh=CGHzK9FS+fD9hpLldIzpZh4R0GE/DkqHNP34XnGeKuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/gRcB3PJ/KKJIqTJ8qZgb82cb8DV25Ufe4sv8IBjXpVvMjEvAFYhuzeW/TnOOAAG
	 DD0evgBe5JDqS+1UYfamSEIixtKA8hctQLpztxg1ZCFuaNA2OxiIBdflizt78Vg6BU
	 x6Xvmy0fibd8rGmHTD29wmYCCfqBYequ4qallvPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <kaiyanm@hust.edu.cn>,
	Lang Xu <xulang@uniontech.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1085/1887] bpf: Fix OOB in pcpu_init_value
Date: Wed, 28 Oct 2026 17:53:01 +0100
Message-ID: <20261028170524.096560885@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Xu <xulang@uniontech.com>

[ Upstream commit 576afddfee8d1108ee299bf10f581593540d1a36 ]

An out-of-bounds read occurs when copying element from a
BPF_MAP_TYPE_CGROUP_STORAGE map to another pcpu map with the
same value_size that is not rounded up to 8 bytes.

The issue happens when:
1. A CGROUP_STORAGE map is created with value_size not aligned to
   8 bytes (e.g., 4 bytes)
2. A pcpu map is created with the same value_size (e.g., 4 bytes)
3. Update element in 2 with data in 1

pcpu_init_value assumes that all sources are rounded up to 8 bytes,
and invokes copy_map_value_long to make a data copy, However, the
assumption doesn't stand since there are some cases where the source
may not be rounded up to 8 bytes, e.g., CGROUP_STORAGE, skb->data.
the verifier verifies exactly the size that the source claims, not
the size rounded up to 8 bytes by kernel, an OOB happens when the
source has only 4 bytes while the copy size(4) is rounded up to 8.

Fixes: d3bec0138bfb ("bpf: Zero-fill re-used per-cpu map element")
Reported-by: Kaiyan Mei <kaiyanm@hust.edu.cn>
Closes: https://lore.kernel.org/all/14e6c70c.6c121.19c0399d948.Coremail.kaiyanm@hust.edu.cn/
Link: https://lore.kernel.org/r/420FEEDDC768A4BE+20260402074236.2187154-1-xulang@uniontech.com
Signed-off-by: Lang Xu <xulang@uniontech.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 36c44451b0911..efe73a684c48d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -963,8 +963,8 @@ static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
 
 		for_each_possible_cpu(cpu) {
 			if (cpu == current_cpu)
-				bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value,
-						size);
+				memcpy(per_cpu_ptr(pptr, cpu), value,
+				       htab->map.value_size);
 			else
 				memset(per_cpu_ptr(pptr, cpu), 0, size);
 		}
-- 
2.53.0



