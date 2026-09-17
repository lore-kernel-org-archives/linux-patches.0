Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6414D487C;
	Thu, 17 Sep 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670413; cv=none; b=mSHicYZmQ0bcmKj1kM1mkiwAQh0C2rqXUbIY0A6yMacNfAjmH2uF1xzxnTNkbkTT2tucRyxwVMQH6dhefHupfXaz9hJF3KPA/QwURECE2zxPaJsjqY6hhcVKuWwkrgDldiExV8OUAgPgJ94iGwuq6eoTS2loLxhGrcffYYOlYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670413; c=relaxed/simple;
	bh=pH7LiiTzuF0JabfUajgiZhH7Xr+9EZCGBk1YCHKUFdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsTe8FJ2ed3yq5SSBGkym6JK9gFPXPcFK/W53KRWMD6R/HUimZl3FBNf85Xgs3EufcjVhv5ofwyb6eR6kXN+nmFCQVLiUHUuGFFtp03NLD17OgTCV5aQwDPPdsf0Cf8Ex4QjikXaO8Gncdgp0JB31qZCNXmHnjhx0Wgjnz/Et5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJPFYdp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJPFYdp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ADD1F000FF;
	Thu, 17 Sep 2026 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670410;
	bh=X9GuOHLeWFh6nANEABPajYBitw7t8FioyjJEgDpSI9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJPFYdp3xqPdb6DQdRfrazqhOlmOXNXIvvnyYc8cwZNpAkyW5VZ7eG+YQf+Ma1Lvs
	 UHBKDJv9+IuEoa1UcMG73HdXXRTtoPMnJEe31fBli2N3vVlSedEeYsYHVgCDLHwAq2
	 4mf6scEdMDU7kQ5e79tbXoOe+hxvKuhOMtNSVM5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0654/1102] bpf: Mark bpf_btf_find_by_name_kind() as sleepable
Date: Thu, 17 Sep 2026 16:09:57 +0100
Message-ID: <20260917151556.589279922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 15e9fd471a05d..f219a03ceefff 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8253,6 +8253,7 @@ BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int
 const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 	.func		= bpf_btf_find_by_name_kind,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
-- 
2.53.0



