Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027140;
	b=kRawExA5SUuUhdRpm9vXUhxu063+jpfoKNoN6aM9BkdI+r0itffKI8vMxbN5HSsLxNYU
	 dn1iN0JKizmtkYo+B7ObhQ1pBZVvzDkbw9Ooxv2jCFDBdjTOy5S/3NfQKXSM7MqXzhLu7
	 CmTM9R4cPImWPIf5cEQttyoxi9I+Myt1rmg5FQNWYF86SyquRp3psCCiP0eweex5Esdeb
	 GTdeUgr2Ow37eeo0Sq4Riw/Ial9OpVphW6DB95sAAVyy/M07PCC4sS8thbtmZG2WkA25M
	 7w+cUQ+1CISk5HzHZiRXyvFICK4KvXCTu1rYZil9fb2EEymX5GPlZmk9B67VZ6buFPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmyfzD229e2OVdx3biIbjP1Ox8GqQOPriOOodL7lUpQ=;
	b=l2OJXD/6d3x021A0JDz/gwz1Pqf5H5de59TXHJHjJt8R+lc7KySVmPhC1Fp0p26aVK3f
	 8qi5XIqeoQKSF+4Oi5B3nKryCb97VGqLE/Ot41NQye2Ns49ZhOmhXvmJPmHFPhvnf5VNY
	 YP330xA9/KeC9IgDzJBbdZ5ezcKqYljWXE3YN299xNtlqQTTRGepwA+jJQYrpWuIwDGeC
	 WI6jmULa/7XuaVkJqR3cVzOd5i++cJoo8jIrjRcET81xrpWunsVH3WGJpJCtq1j2E0iSn
	 UW+4dwAAbDdI3eHzKYDLbEoyk39XRxQ1XGClF6d5HPCqD4bltJ46JM/Q0lfqxAX6Q0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZ5iAA5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A21606A31C;
	Wed, 18 Nov 2026 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZ5iAA5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36A01F000C4;
	Wed, 18 Nov 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027140;
	bh=dmyfzD229e2OVdx3biIbjP1Ox8GqQOPriOOodL7lUpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZ5iAA5wWvLfIyRURTemodS0ouwuTJyoRi92G1nwHX5a+uivhgao1t5ZyXvnV5O93
	 drRXUaxMRiPEnsxtxVEPYnxc7PvrW23t2YVUUmyt/P+Aw/BNBzDE6BM+UwhqlwUn2N
	 ggbK5ETYgym0ZPXvueSmhZ56WH+ODkwFMhPZwPvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pengdonglin <pengdonglin@xiaomi.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1647/2151] tracing: Avoid BTF lookup in atomic context
Date: Wed, 18 Nov 2026 15:56:22 +0100
Message-ID: <20261118150221.846490994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



