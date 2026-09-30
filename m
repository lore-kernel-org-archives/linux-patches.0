Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD69C50E580;
	Wed, 30 Sep 2026 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785274; cv=none; b=URMmFqgHOBqo+Sy3sLZXDnpQzcaw7mpOP9qwJlhKqjlYCxo2PBSZ5ox0WZk5LybPGt8qD24+NXAgJXSv7FKaeOXDq+lzF/dzxUxRX+NIScx+k1INpyrzVAXu5uLmGo9+PE5wiPGzk1oB82IREHIw/mMQDS546WoDbqIwSdD+Y70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785274; c=relaxed/simple;
	bh=CijVzu6EiIkDZ1HTkryyblrsOhd7jST2zwey/u5EfUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afPOlmsIrLmZu0XloH0PKxGz1hjsE+jltqyt0oW/lp9oFxWh6cqp9xN/6Zjx2VTl5Rl8LuIi7h8OMlMkflJg77KAZtr8u4oNRcj5+38fIcmRzArgrGUBenJCeyyfyC0bjYKwbh1FHw4d8Hsi/SRdKByC/NxW1CI1D14SdcgP2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxCY9NxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxCY9NxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E7E1F00899;
	Wed, 30 Sep 2026 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785271;
	bh=hhotIdXcN1h+9lBXQ08TGTylzDlq8ADs7/W2ZHhiUg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxCY9NxXAGSVAxhCvWy93iVBsx7+pjssC9mbwgup0oSML6MGV9Zu+IEWMq4hqH6Ii
	 lqsxjeC5OwSnB4GT6bwKmv6XWkqCFkDyK+7SKQQhULmpubcwe6RShC/WPdwtm7BCP+
	 r8ZX9hTzsIiQCKygBj7ZqKgafwuJgXOWDNNkJ8H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/982] bpf: Mark bpf_btf_find_by_name_kind() as sleepable
Date: Wed, 30 Sep 2026 17:19:01 +0200
Message-ID: <20260930152425.509160703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf6883e7b158f..4fa37f58d97dd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7328,6 +7328,7 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
 const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
-- 
2.53.0



