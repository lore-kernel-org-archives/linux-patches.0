Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431782FA65D;
	Tue, 17 Jun 2025 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178978; cv=none; b=qBLXGjHRmA6b7JNa5iLSwRqOrSEzJUQvA01VWWHV3voDgvrhNnJlimTz3y14orOsEXFTeKGDydJVOUzfCosAMSjw7e3DkQMJT/R+h8YheCRD5uPl7JvQHkwftzgUVR/0ifvlRMxF4lLtRDcWAtQDf51SmtOCDoRGqwIQzhbBNIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178978; c=relaxed/simple;
	bh=ys135BNKUproTt24qYOuosMVydW/04e1ehygwyd7MeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfPC8ZkS8XAN/Oq6xwaAWHeWdhO5y2GCcLG7ggpWVFn+6iHQqSQnPijFjDdLjiOUiJL1WhsR8Py8wS/f4Twpb4yAbrveuujmMSoLRa2WXn2xA/Z0TjuOBFV+GgElqDPJS0zJdm7hqPe1GHApX7P4CW6PMrFfT2jlV3Rz+H8P7QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbtLQst3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbtLQst3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A523AC4CEE3;
	Tue, 17 Jun 2025 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178978;
	bh=ys135BNKUproTt24qYOuosMVydW/04e1ehygwyd7MeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbtLQst3I5VYc6RBYq/tdy3DAnkX8v1fShDj91/BHeq1z9g537Z9x0dOMsbcc9GMb
	 vempmsh1+gVXp9xNnwqTX2Lf7D+SaJXjTNAJxQu/Pql2CgWH0jQYIBVER4ECOpgDS5
	 59cHbJxEfDuUlINOPvg2I74YkfAvi28ZoMRwoJEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 581/780] bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE
Date: Tue, 17 Jun 2025 17:24:49 +0200
Message-ID: <20250617152515.143932201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit ead7f9b8de65632ef8060b84b0c55049a33cfea1 ]

In Cilium, we use bpf_csum_diff + bpf_l4_csum_replace to, among other
things, update the L4 checksum after reverse SNATing IPv6 packets. That
use case is however not currently supported and leads to invalid
skb->csum values in some cases. This patch adds support for IPv6 address
changes in bpf_l4_csum_update via a new flag.

When calling bpf_l4_csum_replace in Cilium, it ends up calling
inet_proto_csum_replace_by_diff:

    1:  void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
    2:                                       __wsum diff, bool pseudohdr)
    3:  {
    4:      if (skb->ip_summed != CHECKSUM_PARTIAL) {
    5:          csum_replace_by_diff(sum, diff);
    6:          if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
    7:              skb->csum = ~csum_sub(diff, skb->csum);
    8:      } else if (pseudohdr) {
    9:          *sum = ~csum_fold(csum_add(diff, csum_unfold(*sum)));
    10:     }
    11: }

The bug happens when we're in the CHECKSUM_COMPLETE state. We've just
updated one of the IPv6 addresses. The helper now updates the L4 header
checksum on line 5. Next, it updates skb->csum on line 7. It shouldn't.

For an IPv6 packet, the updates of the IPv6 address and of the L4
checksum will cancel each other. The checksums are set such that
computing a checksum over the packet including its checksum will result
in a sum of 0. So the same is true here when we update the L4 checksum
on line 5. We'll update it as to cancel the previous IPv6 address
update. Hence skb->csum should remain untouched in this case.

The same bug doesn't affect IPv4 packets because, in that case, three
fields are updated: the IPv4 address, the IP checksum, and the L4
checksum. The change to the IPv4 address and one of the checksums still
cancel each other in skb->csum, but we're left with one checksum update
and should therefore update skb->csum accordingly. That's exactly what
inet_proto_csum_replace_by_diff does.

This special case for IPv6 L4 checksums is also described atop
inet_proto_csum_replace16, the function we should be using in this case.

This patch introduces a new bpf_l4_csum_replace flag, BPF_F_IPV6,
to indicate that we're updating the L4 checksum of an IPv6 packet. When
the flag is set, inet_proto_csum_replace_by_diff will skip the
skb->csum update.

Fixes: 7d672345ed295 ("bpf: add generic bpf_csum_diff helper")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://patch.msgid.link/96a6bc3a443e6f0b21ff7b7834000e17fb549e05.1748509484.git.paul.chaignon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 2 ++
 net/core/filter.c              | 5 +++--
 tools/include/uapi/linux/bpf.h | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bceb1950ec204..fe5df2a9fe8ee 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2052,6 +2052,7 @@ union bpf_attr {
  * 		for updates resulting in a null checksum the value is set to
  * 		**CSUM_MANGLED_0** instead. Flag **BPF_F_PSEUDO_HDR** indicates
  * 		that the modified header field is part of the pseudo-header.
+ * 		Flag **BPF_F_IPV6** should be set for IPv6 packets.
  *
  * 		This helper works in combination with **bpf_csum_diff**\ (),
  * 		which does not update the checksum in-place, but offers more
@@ -6068,6 +6069,7 @@ enum {
 	BPF_F_PSEUDO_HDR		= (1ULL << 4),
 	BPF_F_MARK_MANGLED_0		= (1ULL << 5),
 	BPF_F_MARK_ENFORCE		= (1ULL << 6),
+	BPF_F_IPV6			= (1ULL << 7),
 };
 
 /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
diff --git a/net/core/filter.c b/net/core/filter.c
index 3c93765742c9c..357d26b76c22d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1968,10 +1968,11 @@ BPF_CALL_5(bpf_l4_csum_replace, struct sk_buff *, skb, u32, offset,
 	bool is_pseudo = flags & BPF_F_PSEUDO_HDR;
 	bool is_mmzero = flags & BPF_F_MARK_MANGLED_0;
 	bool do_mforce = flags & BPF_F_MARK_ENFORCE;
+	bool is_ipv6   = flags & BPF_F_IPV6;
 	__sum16 *ptr;
 
 	if (unlikely(flags & ~(BPF_F_MARK_MANGLED_0 | BPF_F_MARK_ENFORCE |
-			       BPF_F_PSEUDO_HDR | BPF_F_HDR_FIELD_MASK)))
+			       BPF_F_PSEUDO_HDR | BPF_F_HDR_FIELD_MASK | BPF_F_IPV6)))
 		return -EINVAL;
 	if (unlikely(offset > 0xffff || offset & 1))
 		return -EFAULT;
@@ -1987,7 +1988,7 @@ BPF_CALL_5(bpf_l4_csum_replace, struct sk_buff *, skb, u32, offset,
 		if (unlikely(from != 0))
 			return -EINVAL;
 
-		inet_proto_csum_replace_by_diff(ptr, skb, to, is_pseudo, false);
+		inet_proto_csum_replace_by_diff(ptr, skb, to, is_pseudo, is_ipv6);
 		break;
 	case 2:
 		inet_proto_csum_replace2(ptr, skb, from, to, is_pseudo);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bceb1950ec204..fe5df2a9fe8ee 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2052,6 +2052,7 @@ union bpf_attr {
  * 		for updates resulting in a null checksum the value is set to
  * 		**CSUM_MANGLED_0** instead. Flag **BPF_F_PSEUDO_HDR** indicates
  * 		that the modified header field is part of the pseudo-header.
+ * 		Flag **BPF_F_IPV6** should be set for IPv6 packets.
  *
  * 		This helper works in combination with **bpf_csum_diff**\ (),
  * 		which does not update the checksum in-place, but offers more
@@ -6068,6 +6069,7 @@ enum {
 	BPF_F_PSEUDO_HDR		= (1ULL << 4),
 	BPF_F_MARK_MANGLED_0		= (1ULL << 5),
 	BPF_F_MARK_ENFORCE		= (1ULL << 6),
+	BPF_F_IPV6			= (1ULL << 7),
 };
 
 /* BPF_FUNC_skb_set_tunnel_key and BPF_FUNC_skb_get_tunnel_key flags. */
-- 
2.39.5



