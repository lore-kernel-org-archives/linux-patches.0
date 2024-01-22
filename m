Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363AC15445E;
	Tue, 23 Jan 2024 00:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969389; cv=none; b=Hwb3rz3PXr8ix4zl7F5BEi0CnzGLbLTX57ZRrY8j+lCj5hO/KlkvFIQRda6NeOYdSWgDK8cn1nKAfpRmBxm8c+THyIT+EiEgMyUFheGM56Sad/DRoQXSBeiHdySqZLP4NGuX5pU/b/8h+GSeN408X2iGcbGGlMZ0zx2MHh6nJW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969389; c=relaxed/simple;
	bh=K64sTdcl62y6k9V5I03ndE7m/OthFa0fAfQKMIKdYSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXw97aGYZmwR0JVQIVXqPISvyiOMq+JSNoFkU26PQTpvAU3sGC39yao5D1ei4edcc2vjM+x4tTN9dPu2z2DUgM2PXkdacN0Hy/Dl/ueE1Y3S1iGAWrpmcSMJ39/h2bT1HtBu+st2a+DbuQFlA23SIFNnT4zWHA4nmw65oFAPT3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lU+1NTOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lU+1NTOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1062C433A6;
	Tue, 23 Jan 2024 00:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969389;
	bh=K64sTdcl62y6k9V5I03ndE7m/OthFa0fAfQKMIKdYSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lU+1NTOqx248Yn+rEU2STPCGCTlCkc3+Ha+ZZBCad4eT9TseiuaEzOw/EK4bWsUjO
	 M+z//A4YPuBNzx4LeP15h2+S+Wjm+xdaLpmQddOcYL/Hy2OkmRec5K4bMdTns8+Tm8
	 ee5CItcZ0B/O0oXVHBtpti26XKtbD71s3fKeXQ+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 190/641] bpf: Limit the number of kprobes when attaching program to multiple kprobes
Date: Mon, 22 Jan 2024 15:51:34 -0800
Message-ID: <20240122235823.917785608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit d6d1e6c17cab2dcb7b8530c599f00e7de906d380 ]

An abnormally big cnt may also be assigned to kprobe_multi.cnt when
attaching multiple kprobes. It will trigger the following warning in
kvmalloc_node():

	if (unlikely(size > INT_MAX)) {
	    WARN_ON_ONCE(!(flags & __GFP_NOWARN));
	    return NULL;
	}

Fix the warning by limiting the maximal number of kprobes in
bpf_kprobe_multi_link_attach(). If the number of kprobes is greater than
MAX_KPROBE_MULTI_CNT, the attachment will fail and return -E2BIG.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231215100708.2265609-3-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 640b08818afa..652c40a14d0d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -42,6 +42,7 @@
 	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
 
 #define MAX_UPROBE_MULTI_CNT (1U << 20)
+#define MAX_KPROBE_MULTI_CNT (1U << 20)
 
 #ifdef CONFIG_MODULES
 struct bpf_trace_module {
@@ -2901,6 +2902,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	cnt = attr->link_create.kprobe_multi.cnt;
 	if (!cnt)
 		return -EINVAL;
+	if (cnt > MAX_KPROBE_MULTI_CNT)
+		return -E2BIG;
 
 	size = cnt * sizeof(*addrs);
 	addrs = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
-- 
2.43.0



