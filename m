Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032177;
	b=k0NzOgA5lndnCyazQ44fVu46iQgnysq7bb8DqutAlXCaRV9UsEsymE80husJNJ1B0tr6
	 YPx/SPl5X95Ubgh8FWOv3sFAXeGmHtgMqxeFbOk/N2J8jn922ovBraQmiXSL50uM6dvVq
	 0U8To4Hm33xDv1c38mrllS7CuEigLoAXZR2i/fWixk4jzLqmZZp9WXWU42sPti8M5BR5s
	 tKsv/oddA8o+5fSvgL+dbKOInbeyUSYHc2tKyHD4N3qmF3b3jPikdhd9DDxqx1qVC5OZo
	 AeYyonQEhNBUYxzAlZV+c0Ktq8aCGQwWWbMfs+AM4MCc+CIsIDwHG60EkX/WkaaX3Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldY6qbV9qN47Qh5KEcPTJXNLRTizFWcf4QOwIBbXbAA=;
	b=c/gqnQINpYFdmQa9y3yEQ1NB4OwRDEwF2Kb7Nl1Kmb1m7vE7Ivno8qozSdWajN08ApIa
	 M+ZVruAC0SDK63eaVRQZ6a6+prS3zTRjN8+21/Znr+ffx0i9G5jGFQ1vTSXdvlw+SDc0c
	 d4UJl0eVdQZrsUAOIdLyaCbihdN1aNkeFiHIbILSYGV+7IWneV3NwGzRxjysVmE+DqIJs
	 RP1NzgZhQ//DwV71TCmaVix2I3DGopQ7mLvvU6CFqSXh/bBsCDDkzUynE3ZHE0FK2fpgZ
	 T2ySfISp+wuqOw0yBbaNH4DGQ0bd25rsXJvCS0JSiL2RaDpk4858neflKehrfwH62wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mR5FsWU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26158606A31C;
	Wed, 18 Nov 2026 20:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mR5FsWU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780AE1F000C4;
	Wed, 18 Nov 2026 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032177;
	bh=ldY6qbV9qN47Qh5KEcPTJXNLRTizFWcf4QOwIBbXbAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mR5FsWU/OIrCbmBCLxHBy/uiMN/MSa0aUWgIUlGEcQLJu1i6t311e3ADhxcLRH75h
	 edSqN5iwLH27FjZRY/LdvV89eG9oBbnPmvyn4JcMoemXWx3VX9LXpk93CAP27ft9h5
	 UD/0+0eNoseo5u4xCyeHPymTyZO32DnTbQnBVBJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <pengdonglin@xiaomi.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1318/1756] tracing: Avoid BTF lookup in atomic context
Date: Wed, 18 Nov 2026 15:57:25 +0100
Message-ID: <20261118150101.915761395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



