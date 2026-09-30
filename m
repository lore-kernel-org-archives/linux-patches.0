Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39D33D3CF5;
	Wed, 30 Sep 2026 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795217; cv=none; b=vFx5mK0zQc711N5ZDZFw6NluPvt5CZFTcDXbneMM+uFhNHmlI87qp0f3KeaH1PeQVQeB9sSvqF1XOcmSRmJj0Mes4w6ouUBp9/sxjosO+90UFJoNsmah/700P1MJgm+yJd5tbc087P4p91lI+Gge/zOINHyIRxx21/a/uZRTTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795217; c=relaxed/simple;
	bh=32jCyFWGKLjA//RCSWEvI9/R/AG3MqIc/ZRIgZiancU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec0xYCQH38eAj0ViCY1oVoBeK7p2bJGlNBTKndzAzOmYsvdHHBgZ3ocG33+WIR/JL9D0vimd1A4AvTqwM3UtH1r5YN2DWDJYQLBFSueIWEoXpEJ/nVivhhenO8Ods2sIA1j+YsV0JmXTNT0ZbEFpic2HB24kcwn0z4Y0CmUQC1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwiegYem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwiegYem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD2F1F000FF;
	Wed, 30 Sep 2026 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795216;
	bh=S9pCNa0AfvNCJTig3RTZt5eiErpnLkJgi8qkF3Bt28c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwiegYemKQDNseozwf6gmqBgRSu5yCXe00RlDVx40IDEAOJv4pLaSHCpDcheqmL+x
	 wxxR8Vzdgz1RDki4WZKZL1A0XAogTFuErrbZc+CG77K/F3CNk04BtyeQ4lUX5nLyvv
	 fcQGzKJM57C0rqCQqjiZvDsBRwlfjN9y68aAXWg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0485/1193] bpf: Mark bpf_btf_find_by_name_kind() as sleepable
Date: Wed, 30 Sep 2026 17:19:29 +0200
Message-ID: <20260930152444.930273956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 620614bf7672130c43b3cff375525a2202f61979 ]

When bpf_btf_find_by_name_kind() finds a type in module BTF, it
returns a new BTF object fd through __btf_new_fd(). This reaches
anon_inode_getfd(), which can sleep while allocating or expanding the
current task fd table.

The helper prototype does not set might_sleep, so the verifier allows
the helper in non-sleepable contexts such as BPF timer callbacks. The
fd allocation can then sleep in softirq context and install the fd into
the interrupted task.

Mark the helper as sleepable. This preserves calls from the main body
of a sleepable syscall program while rejecting calls from its
non-sleepable regions.

Fixes: 3d78417b60fb ("bpf: Add bpf_btf_find_by_name_kind() helper.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/bpf/20260903155150.D57251F000E9@smtp.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903214758.2727663-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3ae36f9f6c303..1c9119f0dfd72 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7594,6 +7594,7 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
 const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
-- 
2.53.0



