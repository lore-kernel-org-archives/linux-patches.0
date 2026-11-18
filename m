Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041869;
	b=xQZ4rmQTIpsGgpMI/amPwYpcXEntCH6Ty5v7V2kBkC8lqnwigfEtfU2M65CTLYLt+Hka
	 ImevdnT3cDTlqywO9y53GdfZ43QDaOyCUDwA9C0dwih+i5tnOE0YcdEW9CRmXLSdZ67Vs
	 /JNilyNNVaxSZICv3hABUjUrBFxkpHYAhX1SgQLQPUfXTQWaSkjAvZMp93+rHm8dmfz23
	 PYqwUeXw5k3+iChab7JYsj6RERNNSbwLgVZ3vps/7FvGPtTAptcmZnWMLt8UrlEmWhYwJ
	 08D+YWWi+tbRjBMT6Qlm3oxVSIhpFP0q21H54TJctDBBbEqqumGw88ZlhdRfizenbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bhq+w0ihkX7JyVP5XEUaArh/jg+bGX2Au3NjwV8kYTQ=;
	b=DuxKSUq0sn8KtWd0fT9s1UrK7NCvBru0bODNmtGW4qgWDKzuWBWMTKD+0Fe2WMSeggL0
	 Ap92KK2oZVNq83ozGNtZlE1I2r/OlGC4LZyHjChNxbiRSjRhMbwv+HOo4HkWaYV76KdgV
	 jdOpHwpSzoIAgkO/6oqEfr4hic8vNhby8htf69wvQlXVOsYpACxdJfC4FOJjRiZvd6aPq
	 ExTaV4yF6kmdlSjDRnIsSib6ajBMlyyTqbApbnA6uY5ht5F5MysC0mbLUzurplm3jAmpf
	 FZLY9Wreci7wgRHSZyKnOjifiHXOPeZrTdmYDwXeAoTBySDhA8NSnbbtdHM/hH47+mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuNmvRMn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFA0606A32A;
	Wed, 18 Nov 2026 22:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuNmvRMn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515161F000C5;
	Wed, 18 Nov 2026 22:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041868;
	bh=bhq+w0ihkX7JyVP5XEUaArh/jg+bGX2Au3NjwV8kYTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuNmvRMn+LbXCLcnp9A5U6KVlfdLJFZsqFBWsbYrILbkZiJ5C+1p+4DoxvWjcylMr
	 TaNuAy9oPamFTk2CiRuJleuFf6L10cCCPrHT2U/g8/nwMv6XrSbJYn2htTORXN74cV
	 ZS7DkTFSjXniSq8FvtfjlylKYuFBhNO5JpWPYJHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <pengdonglin@xiaomi.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2966/3318] tracing: Avoid BTF lookup in atomic context
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150449.270312688@linuxfoundation.org>
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
index 43e3798011776..2fcb1efe49abf 100644
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



