Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77251396D35;
	Wed, 21 Jan 2026 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019896; cv=none; b=p4J2daq9wguB7kmi1bCOvo0jY4cU8rDKU03+soVfJr8ESxwpO02DMyYyFC5YEPt4fKAzxchQik8FbHPO+QPKW4I6kR4KE6SsQlhdYtCLunLqOIHLzcw8J6zktS1N9GyrsKugZkZ2k8vDx1zQ66kjfr/0hMBnUqY/0yCYwn/Usrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019896; c=relaxed/simple;
	bh=pwJDo1qMxRQpgmcvchlKMTP9nEWFLkBvJqpP/ETonH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJVRFxB0Sdhdl0Ma3u/yrZUc38lra48tYkMLzoIhFfsj+c8my9gQQ6Dam40DOGGAnfwZzwc0WJMWsknn9YjbFE3+J86BEPO9SVLMHoThBECDTIrAbCS7QS80fIV8fmQZQ/nwO2faVfLlAcERz8Rttzzi8mpJxKuZH4zgZyxVix8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6Pcg6s8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6Pcg6s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AB7C4CEF1;
	Wed, 21 Jan 2026 18:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019896;
	bh=pwJDo1qMxRQpgmcvchlKMTP9nEWFLkBvJqpP/ETonH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6Pcg6s8ZyE/uCvfyOKv6L12uAc5FMs+QM1dsmCPOXKD+/DQjuveM0WvLbzwFM2Px
	 53R3c95dfmtYbtLgXQ+vnNVfc6mSPtaXqsEcJ7XEMC35SZQwXLUBD4ROMBE+xIshR1
	 dZefAwvR5Yq7avIpdL+rW62rnYJ22VCwj68dXO3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 129/139] selftests/bpf: Test invalid narrower ctx load
Date: Wed, 21 Jan 2026 19:16:17 +0100
Message-ID: <20260121181416.095033810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

commit ba578b87fe2beef95b37264f8a98c0b505b93de9 upstream.

This patch adds selftests to cover invalid narrower loads on the
context. These used to cause kernel warnings before the previous patch.
To trigger the warning, the load had to be aligned, to read an affected
context field (ex., skb->sk), and not starting at the beginning of the
field.

The nine new cases all fail without the previous patch.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/44cd83ea9c6868079943f0a436c6efa850528cc1.1753194596.git.paul.chaignon@gmail.com
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_ctx.c |   25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_ctx.c
+++ b/tools/testing/selftests/bpf/progs/verifier_ctx.c
@@ -218,4 +218,29 @@ __naked void null_check_8_null_bind(void
 	: __clobber_all);
 }
 
+#define narrow_load(type, ctx, field)					\
+	SEC(type)							\
+	__description("narrow load on field " #field " of " #ctx)	\
+	__failure __msg("invalid bpf_context access")			\
+	__naked void invalid_narrow_load##ctx##field(void)		\
+	{								\
+		asm volatile ("						\
+		r1 = *(u32 *)(r1 + %[off]);				\
+		r0 = 0;							\
+		exit;"							\
+		:							\
+		: __imm_const(off, offsetof(struct ctx, field) + 4)	\
+		: __clobber_all);					\
+	}
+
+narrow_load("cgroup/getsockopt", bpf_sockopt, sk);
+narrow_load("cgroup/getsockopt", bpf_sockopt, optval);
+narrow_load("cgroup/getsockopt", bpf_sockopt, optval_end);
+narrow_load("tc", __sk_buff, sk);
+narrow_load("cgroup/bind4", bpf_sock_addr, sk);
+narrow_load("sockops", bpf_sock_ops, sk);
+narrow_load("sockops", bpf_sock_ops, skb_data);
+narrow_load("sockops", bpf_sock_ops, skb_data_end);
+narrow_load("sockops", bpf_sock_ops, skb_hwtstamp);
+
 char _license[] SEC("license") = "GPL";


