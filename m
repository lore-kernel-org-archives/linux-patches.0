Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CF718E36D;
	Mon, 28 Oct 2024 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097193; cv=none; b=AKfKuWlsIyOiKEQMR9LUAc98usgcXHBceuw/KpkJh8Bhj0cVzGn9R6r5AcJ2F3hnNpGK0qPkFJtlOcu/ESgz/bXZeIXUQGgzUixXtd8B4VjSBcMI97Bvfcy3fGMNSds3tssgQ0iXcaAEo+CaXJXqSHW7KJTcLV53E0iQPvIFiVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097193; c=relaxed/simple;
	bh=Y8SAEwjIKOirkQgmmmy8Gzv0i8ErJchx3wnEzCOUTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rG3HWZjj1cVOqpLx0TYVhSN0esZSMGfHEGaaIwz9y9yhFQXe6Q4NtPylB/VlvPnN4m/PXflXGVDZJGa90OLn+KuRltzRSlzAekg2aaOXCHGNzVb9rzuVW9MoyzKbLW4im/HhuPYkx9Z8slanr+gMGAxfX/DOakjucSunTiC0sHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRT8GjQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRT8GjQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288F1C4CEC7;
	Mon, 28 Oct 2024 06:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097192;
	bh=Y8SAEwjIKOirkQgmmmy8Gzv0i8ErJchx3wnEzCOUTZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRT8GjQaaTsku8gTP2QDnW31ICAPVV+9HEHJkgbdAHYTUGAJJCWuRcQvFlxH6uN5p
	 FkPQLlaFzosgYguZroaiJvmXis95SVB4JX8Mnnxkv8jV6Qq8/cQRiv0IPnfMDn3vrd
	 PUGXnQHaWmwui0GAX4MwoFZva+I04kWoTx7vwKIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cca39e6e84a367a7e6f6@syzkaller.appspotmail.com,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/137] bpf: Make sure internal and UAPI bpf_redirect flags dont overlap
Date: Mon, 28 Oct 2024 07:24:00 +0100
Message-ID: <20241028062258.802804529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 58c7fc75da752..667f49a64a50b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5717,11 +5717,6 @@ enum {
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
@@ -5865,10 +5860,12 @@ enum {
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
index 6f65c6eb0d90d..3f3286cf438e7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2416,9 +2416,9 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
 
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
 
@@ -2428,6 +2428,8 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
 	struct sk_buff *clone;
 	int ret;
 
+	BUILD_BUG_ON(BPF_F_REDIRECT_INTERNAL & BPF_F_REDIRECT_FLAGS);
+
 	if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
 		return -EINVAL;
 
-- 
2.43.0



