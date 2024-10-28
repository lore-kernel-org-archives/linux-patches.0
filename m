Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0A18CC1F;
	Mon, 28 Oct 2024 06:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096838; cv=none; b=RX9bULBzUnJFvuvcVUv3Mdkgl/FnDXT86TcAuTbubIzIxgVlAGhKCqjU7QZGyS/o6VIW1izxb8ezdks3M2LVdhLcKHv0iwX6n6X+ixHBe0UUUP9nAaweKS05MVIwOWOtH6q3QaO/0/7FoY9ziiRUuX/a4UV5AqyvrBHjtN9cP9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096838; c=relaxed/simple;
	bh=/+wPeJATp7RnuRWaN+Kf3Dj6GFYhdnotYv9qGZSBW0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cte794zyO7X68tu4HUqEzD5Os+T1Y9fM+zB5mUnFu5+FCJmBAjJCnjuQwleKqGl82qHbqW7GXr0t/e9gc8RSrAzrlKVeu9Amhzz7loXNPE5z7jlOKyKqZI3m6TBdj/dfg2L39d3RKXNOJCx+8IFZN7FAh2KLtTXC4puIFvHzmg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khD9b4ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khD9b4ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D580C4CEC3;
	Mon, 28 Oct 2024 06:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096837;
	bh=/+wPeJATp7RnuRWaN+Kf3Dj6GFYhdnotYv9qGZSBW0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khD9b4haVT1pVuHEEnH9nLin+e0KFUOcM5H2ShrhQyBXJ/b7XH2/loD2VJUfdPwLx
	 m383UcgnkdiTzDdiYBzjYmRI0JOlNRMJW/zlkFz3IjrRYQAWley4co3GDmevbx9Fwu
	 7HGIhL9UbbW2vbU5/bAj98xSf+7A0sbz+nvW6Um4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cca39e6e84a367a7e6f6@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/80] bpf: Make sure internal and UAPI bpf_redirect flags dont overlap
Date: Mon, 28 Oct 2024 07:24:41 +0100
Message-ID: <20241028062252.653783649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 09d88791c7cd888d5195c84733caf9183dcfbd16 ]

The bpf_redirect_info is shared between the SKB and XDP redirect paths,
and the two paths use the same numeric flag values in the ri->flags
field (specifically, BPF_F_BROADCAST == BPF_F_NEXTHOP). This means that
if skb bpf_redirect_neigh() is used with a non-NULL params argument and,
subsequently, an XDP redirect is performed using the same
bpf_redirect_info struct, the XDP path will get confused and end up
crashing, which syzbot managed to trigger.

With the stack-allocated bpf_redirect_info, the structure is no longer
shared between the SKB and XDP paths, so the crash doesn't happen
anymore. However, different code paths using identically-numbered flag
values in the same struct field still seems like a bit of a mess, so
this patch cleans that up by moving the flag definitions together and
redefining the three flags in BPF_F_REDIRECT_INTERNAL to not overlap
with the flags used for XDP. It also adds a BUILD_BUG_ON() check to make
sure the overlap is not re-introduced by mistake.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Reported-by: syzbot+cca39e6e84a367a7e6f6@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://syzkaller.appspot.com/bug?extid=cca39e6e84a367a7e6f6
Link: https://lore.kernel.org/bpf/20240920125625.59465-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h | 13 +++++--------
 net/core/filter.c        |  8 +++++---
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6bfb510656abe..0bdeeabbc5a84 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5108,11 +5108,6 @@ enum {
 	BPF_F_MARK_ENFORCE		= (1ULL << 6),
 };
 
-/* BPF_FUNC_clone_redirect and BPF_FUNC_redirect flags. */
-enum {
-	BPF_F_INGRESS			= (1ULL << 0),
-};
-
 /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
 enum {
 	BPF_F_TUNINFO_IPV6		= (1ULL << 0),
@@ -5251,10 +5246,12 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
-/* Flags for bpf_redirect_map helper */
+/* Flags for bpf_redirect and bpf_redirect_map helpers */
 enum {
-	BPF_F_BROADCAST		= (1ULL << 3),
-	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+	BPF_F_INGRESS		= (1ULL << 0), /* used for skb path */
+	BPF_F_BROADCAST		= (1ULL << 3), /* used for XDP path */
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4), /* used for XDP path */
+#define BPF_F_REDIRECT_FLAGS (BPF_F_INGRESS | BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
 };
 
 #define __bpf_md_ptr(type, name)	\
diff --git a/net/core/filter.c b/net/core/filter.c
index a92a35c0f1e72..b5e1e087a2b92 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2405,9 +2405,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
 
 /* Internal, non-exposed redirect flags. */
 enum {
-	BPF_F_NEIGH	= (1ULL << 1),
-	BPF_F_PEER	= (1ULL << 2),
-	BPF_F_NEXTHOP	= (1ULL << 3),
+	BPF_F_NEIGH	= (1ULL << 16),
+	BPF_F_PEER	= (1ULL << 17),
+	BPF_F_NEXTHOP	= (1ULL << 18),
 #define BPF_F_REDIRECT_INTERNAL	(BPF_F_NEIGH | BPF_F_PEER | BPF_F_NEXTHOP)
 };
 
@@ -2417,6 +2417,8 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
 	struct sk_buff *clone;
 	int ret;
 
+	BUILD_BUG_ON(BPF_F_REDIRECT_INTERNAL & BPF_F_REDIRECT_FLAGS);
+
 	if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
 		return -EINVAL;
 
-- 
2.43.0



