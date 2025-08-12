Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DCF2F4A0A;
	Tue, 12 Aug 2025 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024063; cv=none; b=Q3hV2HOmzTD3H5kK/VBlKRaRZ0Q7VfvHrmhqUiSKOadnGPxSZ+dqU+8VG549NAaJa7keQerX6U0Dbt4TJ/cZQNbBlfIs+gJ41ngsa7cWWZE8K5gEkWIAa9+6iU4hgbNpgfkTkxFtILFBf+gE29UZI7wgQcF3bO/3pYasBH2yWT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024063; c=relaxed/simple;
	bh=ERHIsji9gqL1E/SnrHFAIxMB4AGH9/qJ9BPdVinrxcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnFAYzv91okAmHefkrEl8ybdESi5EAbkZJlfZQPzPWgMbgsQE3zx0p30Q6KbM6dlnlGN+bzpk+DnzMPFyjoBqVkPXshT9Bw8FoRX+QfWUgXgjHEUoNX4U6u7KuEbTKbR6s5a+wBd6X//Vmpmm/OeagUlXFTEmwpsnCq9NsslB3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8awz1kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8awz1kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2018C4CEF0;
	Tue, 12 Aug 2025 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024063;
	bh=ERHIsji9gqL1E/SnrHFAIxMB4AGH9/qJ9BPdVinrxcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8awz1kfNLhilCsTkliDTi2dK0AYz+lvYf3oxywuNDO58GqFf6nvaTOPi3AbMyuCB
	 jylkqrLsM0UpHUE+swoc4rhaDY7wnw3AJEg2H2h/MVCU5WIQxlcjccRUbyCaZdVBCZ
	 WPzc6Jj7RvEGsjB0sNcX6zGKhAjaJWYng9nU/FW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0ef84a7bdf5301d4cbec@syzkaller.appspotmail.com,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 262/627] bpf: Reject narrower access to pointer ctx fields
Date: Tue, 12 Aug 2025 19:29:17 +0200
Message-ID: <20250812173429.282959908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit e09299225d5ba3916c91ef70565f7d2187e4cca0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c |  8 ++++----
 net/core/filter.c   | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index f4885514f007..deb88fade249 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2440,22 +2440,22 @@ static bool cg_sockopt_is_valid_access(int off, int size,
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 7a72f766aacf..47073a0180a4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8690,7 +8690,7 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 		if (size != sizeof(__u64))
 			return false;
 		break;
-	case offsetof(struct __sk_buff, sk):
+	case bpf_ctx_range_ptr(struct __sk_buff, sk):
 		if (type == BPF_WRITE || size != sizeof(__u64))
 			return false;
 		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
@@ -9268,7 +9268,7 @@ static bool sock_addr_is_valid_access(int off, int size,
 				return false;
 		}
 		break;
-	case offsetof(struct bpf_sock_addr, sk):
+	case bpf_ctx_range_ptr(struct bpf_sock_addr, sk):
 		if (type != BPF_READ)
 			return false;
 		if (size != sizeof(__u64))
@@ -9318,17 +9318,17 @@ static bool sock_ops_is_valid_access(int off, int size,
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
@@ -9337,7 +9337,7 @@ static bool sock_ops_is_valid_access(int off, int size,
 			bpf_ctx_record_field_size(info, size_default);
 			return bpf_ctx_narrow_access_ok(off, size,
 							size_default);
-		case offsetof(struct bpf_sock_ops, skb_hwtstamp):
+		case bpf_ctx_range(struct bpf_sock_ops, skb_hwtstamp):
 			if (size != sizeof(__u64))
 				return false;
 			break;
@@ -9407,17 +9407,17 @@ static bool sk_msg_is_valid_access(int off, int size,
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
@@ -11623,7 +11623,7 @@ static bool sk_lookup_is_valid_access(int off, int size,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_sk_lookup, sk):
+	case bpf_ctx_range_ptr(struct bpf_sk_lookup, sk):
 		info->reg_type = PTR_TO_SOCKET_OR_NULL;
 		return size == sizeof(__u64);
 
-- 
2.39.5



