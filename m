Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020620;
	b=K02PXGobFEiauQIoSh/ZitO3TZEOXsm3Mu1iQfnr/Q+fhTvq98rMwLgOsN9JBqC1e6hU
	 3R1ve4mIQ5k2qq2dhl1TIWs0uZzCtEOiqdoWZDbmQpIDS+Ok8uLZTR/Td75sZcWXssIR0
	 VB8KyRRblIdYxMGALYu9GjoDDaX/N6dkg5011tNU+KGQesBIfcKqa2W+dMdi5OJlf69fS
	 JpV7CDB2qisShwg0YPxHGBGYbIa/QO81r0ZKQgJr5jxWcKrAyaI1kUdZUN/3C1f+N6i4+
	 7xnxp/73tie42xNzKhu3G1sMnQxZon3JT167aLy19IgABCWuuRViE4lz33rUm9kCpqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oz4PZvvos1uJxR0++NL0Uhfd/aZmDV8EN7EAvbyyua8=;
	b=fwu/w3F09g4kLYndkOnLPUuHyADvMGntAAIAWXOoftWzjnSGbrUwFFVWeNd3ps7Yneep
	 652/GG9ykj/dU8fbJi7UazYmZ8SnzbtrEsQ2bcDj9e8uw52wK5uRNVPGIJ+4Z8LUmSGDX
	 6y0N3RnBEHL0rMah9ZTpeYV/pOM5RthYUriCJhrnklXUa7A6Zk1wnbqy0a6egJ0IvhF4P
	 2OKXVVZIZMHnswT1QOYERvWat3AhDp2YLLkpOBHl3CgE5A7rwDrVy8c8hgcez7B3yJxbZ
	 SU1uQc0LRF4/BHqYYNdLRPiEd10XLLXPesl7MEV/iZi0ajj9ZLN/dgKc27CCE7lLuAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVZdJk57;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE30606A33B;
	Wed, 18 Nov 2026 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVZdJk57
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B9E1F000C7;
	Wed, 18 Nov 2026 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020619;
	bh=oz4PZvvos1uJxR0++NL0Uhfd/aZmDV8EN7EAvbyyua8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVZdJk57BoOvuZlf4m5Jtgkpj593IAhL3OHTlZ4uePfVdK618g6sakTjhik4n+RyB
	 h4H/dLP2Ubc65Q5s6PHd6J0OKUtJ9NLm0Agjeg/OJDs2LYLWruqiEuCytExftvrdGU
	 you7rGey4MR6kBTzF8LMV68Cl0noXSfNiZzum1eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <pengdonglin@xiaomi.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2009/2651] tracing: Avoid BTF lookup in atomic context
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150358.600732249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: pengdonglin <pengdonglin@xiaomi.com>

[ Upstream commit 42643ba35deb8ad1821acfc0577b445ee7ad7548 ]

The function graph trace formatter can be called from ftrace_dump_one()
with interrupts disabled. When ftrace_dump_on_oops is enabled, the trace
panic notifier can reach ftrace_dump() from the panic path, including the
nmi_panic() path used by the hard lockup detector.

btf_find_func_proto() calls bpf_find_btf_id(), which may initialize vmlinux
BTF under a mutex. Skip the BTF lookup when running in an atomic context
or with interrupts disabled, and fall back to the existing return value
formatting.

Link: https://patch.msgid.link/20260916133218.1282590-2-dolinux.peng@gmail.com
Fixes: ebeed8d4a555 ("tracing/probes: Move finding func-proto API and getting func-param API to trace_btf")
Signed-off-by: pengdonglin <pengdonglin@xiaomi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_btf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_btf.c b/kernel/trace/trace_btf.c
index ee7a04886bf67..b8370ae9bd547 100644
--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -15,6 +15,9 @@ const struct btf_type *btf_find_func_proto(const char *func_name, struct btf **b
 	const struct btf_type *t;
 	s32 id;
 
+	if (unlikely(in_atomic() || irqs_disabled()))
+		return NULL;
+
 	id = bpf_find_btf_id(func_name, BTF_KIND_FUNC, btf_p);
 	if (id < 0)
 		return NULL;
-- 
2.53.0



