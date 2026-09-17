Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515551814C;
	Thu, 17 Sep 2026 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665778; cv=none; b=dwQD4ftFXKThqCPaLOF1YW6ZYKwXvAK6G1SHs6+q6uhBo6LZIcc2DTaua+7meV1BirxK5OrGNTMoIQMjJhVugOah6Se+Xv8NHRpOV+1uOo+PtVMmP9wIUXderM4HbNMI6wVInAiWMX8QAl/BzPEx3z/VfXC76O4OlJYgN2nf1zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665778; c=relaxed/simple;
	bh=NIxekK9iPud6rnjA22r7Ptf3QcF/vB9hShNyZpBQq2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiEy+Re5fN2HeDmBYoK2+uNxvJzHoV08L8EP1p7WJP/P5f7HIbK9qrMrDL/gYeVJwkeUhcDgURVf0QdZpQW5oHlN4JDcFv2ptB5wXZvF05trc+4mJ4p67tyYzp3uMBVvmvJvVMFKxoU3yexcLoKUo8o31ij4Pi1c+7tiQNvzfJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMG8tHQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMG8tHQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78441F000FF;
	Thu, 17 Sep 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665777;
	bh=JG7AF0LhsX118oYwjY57ieoX7w+UPBgUjDXWw7jIL74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMG8tHQHrJGr0OvDwvbBWurWXwoTAiyDfHOyI8fgY1aAF2x1TDOCjohvbiFMHgEd+
	 a2izweDUqkaZc6GPrX4G773kvb2gbzqFjmKbUUzO+JGBR4/nzXgc9ONG/ZWMr8NDq7
	 cs38BZ3bQEv2fNVi8fqKTa/RU2rSuJNissA57BwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0778/1250] bpf: Mark bpf_btf_find_by_name_kind() as sleepable
Date: Thu, 17 Sep 2026 16:09:33 +0100
Message-ID: <20260917151612.976885570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d3fa25a315361..f92e1c16c3569 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8430,6 +8430,7 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
 const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
-- 
2.53.0



