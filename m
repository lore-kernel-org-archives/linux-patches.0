Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAFB1A9FB0;
	Wed, 21 Jan 2026 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019882; cv=none; b=ocAoncpEPKp7MHVCCUl+zawG4BbtK1hUuuyHSmB0mIWfTNYvk4f4FW4MT45PNWZb5IjS1eMygVt9lv70AYavnoVKBDBatXIXQp7JS0nNv2/z0eHyp6QviWteWn6eqt0AtSWqMItOgKeSR/ynm3XN0C7dfqQG0Hfq6OrcJKnmfgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019882; c=relaxed/simple;
	bh=9z9itUdbjo+0nledQlq4BdW/YsFkLAbEsF8ATrBoW1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQBwCFXD1BYbwkx0nsNcbhuN01xZz3sCO37csSX/1lBg3hs6DP9AWZt8iBnRfHQ3QqqDCM9ABN/qq7FGz5KdcyFU/Z2ZeYkH59Q8iK/Tx+yzIPnIuvbxBLtSag7Q1scqAKM+tfJbraDUzzltpxXCOP3LNqzefAe01z292DRTeik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX3hhzPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX3hhzPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52053C4CEF1;
	Wed, 21 Jan 2026 18:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019882;
	bh=9z9itUdbjo+0nledQlq4BdW/YsFkLAbEsF8ATrBoW1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lX3hhzPkRXiSKnbnm/B+yZQFpac0Cdo3jw6DgPN8OESHxhIyNl6y/0ESxkhoisDSu
	 aicT4g8NseWWr1FVmgstl235Eyjp7cGq8/X6Dkofxl5lYDxGFIpaNYBIR7ZtPZu6d0
	 tYfRa6FCL3PEwrDg6sX0WyvETYPJzHn9qGtm0p1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ef84a7bdf5301d4cbec@syzkaller.appspotmail.com,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 128/139] bpf: Reject narrower access to pointer ctx fields
Date: Wed, 21 Jan 2026 19:16:16 +0100
Message-ID: <20260121181416.059774080@linuxfoundation.org>
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

commit e09299225d5ba3916c91ef70565f7d2187e4cca0 upstream.

The following BPF program, simplified from a syzkaller repro, causes a
kernel warning:

    r0 = *(u8 *)(r1 + 169);
    exit;

With pointer field sk being at offset 168 in __sk_buff. This access is
detected as a narrower read in bpf_skb_is_valid_access because it
doesn't match offsetof(struct __sk_buff, sk). It is therefore allowed
and later proceeds to bpf_convert_ctx_access. Note that for the
"is_narrower_load" case in the convert_ctx_accesses(), the insn->off
is aligned, so the cnt may not be 0 because it matches the
offsetof(struct __sk_buff, sk) in the bpf_convert_ctx_access. However,
the target_size stays 0 and the verifier errors with a kernel warning:

    verifier bug: error during ctx access conversion(1)

This patch fixes that to return a proper "invalid bpf_context access
off=X size=Y" error on the load instruction.

The same issue affects multiple other fields in context structures that
allow narrow access. Some other non-affected fields (for sk_msg,
sk_lookup, and sockopt) were also changed to use bpf_ctx_range_ptr for
consistency.

Note this syzkaller crash was reported in the "Closes" link below, which
used to be about a different bug, fixed in
commit fce7bd8e385a ("bpf/verifier: Handle BPF_LOAD_ACQ instructions
in insn_def_regno()"). Because syzbot somehow confused the two bugs,
the new crash and repro didn't get reported to the mailing list.

Fixes: f96da09473b52 ("bpf: simplify narrower ctx access")
Fixes: 0df1a55afa832 ("bpf: Warn on internal verifier errors")
Reported-by: syzbot+0ef84a7bdf5301d4cbec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0ef84a7bdf5301d4cbec
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/3b8dcee67ff4296903351a974ddd9c4dca768b64.1753194596.git.paul.chaignon@gmail.com
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/cgroup.c |    8 ++++----
 net/core/filter.c   |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2418,22 +2418,22 @@ static bool cg_sockopt_is_valid_access(i
 	}
 
 	switch (off) {
-	case offsetof(struct bpf_sockopt, sk):
+	case bpf_ctx_range_ptr(struct bpf_sockopt, sk):
 		if (size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_SOCKET;
 		break;
-	case offsetof(struct bpf_sockopt, optval):
+	case bpf_ctx_range_ptr(struct bpf_sockopt, optval):
 		if (size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_PACKET;
 		break;
-	case offsetof(struct bpf_sockopt, optval_end):
+	case bpf_ctx_range_ptr(struct bpf_sockopt, optval_end):
 		if (size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_PACKET_END;
 		break;
-	case offsetof(struct bpf_sockopt, retval):
+	case bpf_ctx_range(struct bpf_sockopt, retval):
 		if (size != size_default)
 			return false;
 		return prog->expected_attach_type == BPF_CGROUP_GETSOCKOPT;
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8655,7 +8655,7 @@ static bool bpf_skb_is_valid_access(int
 		if (size != sizeof(__u64))
 			return false;
 		break;
-	case offsetof(struct __sk_buff, sk):
+	case bpf_ctx_range_ptr(struct __sk_buff, sk):
 		if (type == BPF_WRITE || size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
@@ -9232,7 +9232,7 @@ static bool sock_addr_is_valid_access(in
 				return false;
 		}
 		break;
-	case offsetof(struct bpf_sock_addr, sk):
+	case bpf_ctx_range_ptr(struct bpf_sock_addr, sk):
 		if (type != BPF_READ)
 			return false;
 		if (size != sizeof(__u64))
@@ -9286,17 +9286,17 @@ static bool sock_ops_is_valid_access(int
 			if (size != sizeof(__u64))
 				return false;
 			break;
-		case offsetof(struct bpf_sock_ops, sk):
+		case bpf_ctx_range_ptr(struct bpf_sock_ops, sk):
 			if (size != sizeof(__u64))
 				return false;
 			info->reg_type = PTR_TO_SOCKET_OR_NULL;
 			break;
-		case offsetof(struct bpf_sock_ops, skb_data):
+		case bpf_ctx_range_ptr(struct bpf_sock_ops, skb_data):
 			if (size != sizeof(__u64))
 				return false;
 			info->reg_type = PTR_TO_PACKET;
 			break;
-		case offsetof(struct bpf_sock_ops, skb_data_end):
+		case bpf_ctx_range_ptr(struct bpf_sock_ops, skb_data_end):
 			if (size != sizeof(__u64))
 				return false;
 			info->reg_type = PTR_TO_PACKET_END;
@@ -9305,7 +9305,7 @@ static bool sock_ops_is_valid_access(int
 			bpf_ctx_record_field_size(info, size_default);
 			return bpf_ctx_narrow_access_ok(off, size,
 							size_default);
-		case offsetof(struct bpf_sock_ops, skb_hwtstamp):
+		case bpf_ctx_range(struct bpf_sock_ops, skb_hwtstamp):
 			if (size != sizeof(__u64))
 				return false;
 			break;
@@ -9375,17 +9375,17 @@ static bool sk_msg_is_valid_access(int o
 		return false;
 
 	switch (off) {
-	case offsetof(struct sk_msg_md, data):
+	case bpf_ctx_range_ptr(struct sk_msg_md, data):
 		info->reg_type = PTR_TO_PACKET;
 		if (size != sizeof(__u64))
 			return false;
 		break;
-	case offsetof(struct sk_msg_md, data_end):
+	case bpf_ctx_range_ptr(struct sk_msg_md, data_end):
 		info->reg_type = PTR_TO_PACKET_END;
 		if (size != sizeof(__u64))
 			return false;
 		break;
-	case offsetof(struct sk_msg_md, sk):
+	case bpf_ctx_range_ptr(struct sk_msg_md, sk):
 		if (size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_SOCKET;
@@ -11598,7 +11598,7 @@ static bool sk_lookup_is_valid_access(in
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_sk_lookup, sk):
+	case bpf_ctx_range_ptr(struct bpf_sk_lookup, sk):
 		info->reg_type = PTR_TO_SOCKET_OR_NULL;
 		return size == sizeof(__u64);
 


