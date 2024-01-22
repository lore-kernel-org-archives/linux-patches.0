Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5287C62802;
	Tue, 23 Jan 2024 01:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974967; cv=none; b=TVqRL5Yw38kO9U83Tsom5gqeo65/J0vwGw5FaYZ5fYb4xMacPlLY3pHtY1M77pJj6Wh4LzCUD5BqC5+Vew6PMiZfk+el/RUi5FqsZgVvxhxFeiKRO0NSCtThDlnc+zgA41qkzyklMkD4DgBLhtWwVBKZrNSroF4Ub+IFJwXRsvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974967; c=relaxed/simple;
	bh=9euEvJDHHCKRYYfvlVPZjpLF246FPE37+8xxsWd/d3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH6Oanj4uvGNbfBmtV7TpB4hZf7SuuDTShbgz+ubKO81rvKC9i79gi3L6BC0NiyBeqnWTH1/Fh2uQeo13koXQ0P+ffYS3KKHfvqAS9xFbVCdHYCGWz+T6hOaQOOA3nBMee1Vjyl6HCS+LeUJ7xS5KHXLTswM6lx56iltARXjrHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZ7Vc/iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZ7Vc/iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18676C433F1;
	Tue, 23 Jan 2024 01:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974967;
	bh=9euEvJDHHCKRYYfvlVPZjpLF246FPE37+8xxsWd/d3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZ7Vc/iOEaPxEymLIHZM/XNYEsp0uXYnFq9WyJj9KB0k+8lzFve+uIP0/FDLm5XWo
	 /shizZbl+OPUxncI1oa2DMl+II8A7oBP8ylEYPDZC9nNLV3MUAJ7ls9kLPVbGqoNiW
	 2z2FarRIJGDE2lwfMAOJxTiocyPwNt0nfKfpCvWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/583] bpf: Limit the number of kprobes when attaching program to multiple kprobes
Date: Mon, 22 Jan 2024 15:53:43 -0800
Message-ID: <20240122235817.292147893@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39c4cef98b95..1d76f3b014ae 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -42,6 +42,7 @@
 	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
 
 #define MAX_UPROBE_MULTI_CNT (1U << 20)
+#define MAX_KPROBE_MULTI_CNT (1U << 20)
 
 #ifdef CONFIG_MODULES
 struct bpf_trace_module {
@@ -2897,6 +2898,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	cnt = attr->link_create.kprobe_multi.cnt;
 	if (!cnt)
 		return -EINVAL;
+	if (cnt > MAX_KPROBE_MULTI_CNT)
+		return -E2BIG;
 
 	size = cnt * sizeof(*addrs);
 	addrs = kvmalloc_array(cnt, sizeof(*addrs), GFP_KERNEL);
-- 
2.43.0



