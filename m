Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D3C7C09A;
	Wed, 21 Feb 2024 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524382; cv=none; b=CeXaRWls4wYak7QxmAKey6CmiVKal5PH7O/YWmFd+0hFsn5rVWLnibBu1hxu9J0iKl1yQ90jLU/oKKIspaQxvK8mFHwISNXluwauGGVt67kikrxY2Q7uFCBRnkL1pVjGYCBZMiBSGOjKnSml11T+yOvzZs2GOIlv2U3HdDCU2Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524382; c=relaxed/simple;
	bh=I2WpASzRV60LC6TTkX6zxn8viD+1XhUjbRzE7zkGXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mipUWvsp/2oI1Pzj3Mr+Jlygk4b5zIfL5fXXxUlbwAY4nnTLCSw7muoZJkxmicbDYTucMkIGBr3SNzjnXc1qbgcFPV2FsSFwgxMoIF0PgzF7y5P2/WUALcFGSGrMThynT59YB02M00ZtF51GHJC0D51d3JwrSCXcxHRQ4peuPYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKuKXV94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKuKXV94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB82C433C7;
	Wed, 21 Feb 2024 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524382;
	bh=I2WpASzRV60LC6TTkX6zxn8viD+1XhUjbRzE7zkGXgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKuKXV94szSZJTnmUJza5/Ek6tlEEcVX07X8mHml5DTd0dbXk7I7n4ZZB0nPeXxAN
	 poZtFS375Wo9enRJ2FJiS2vSDkcQBb4GGaTWnzXNXaIAaljUIRNQA4mnYDiLeMTjBM
	 Ko4qGJr/ZryEJz1VBfgcG33ERxbbE6cjvUt/kCo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/379] net-zerocopy: Refactor frag-is-remappable test.
Date: Wed, 21 Feb 2024 14:06:47 +0100
Message-ID: <20240221130001.642129937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit 98917cf0d6eda01e8c3c34d35398d46b247b6fd3 ]

Refactor frag-is-remappable test for tcp receive zerocopy. This is
part of a patch set that introduces short-circuited hybrid copies
for small receive operations, which results in roughly 33% fewer
syscalls for small RPC scenarios.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 577e4432f3ac ("tcp: add sanity checks to rx zerocopy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 27e0d3dfc5bd..18541527abce 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1778,6 +1778,26 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 	return frag;
 }
 
+static bool can_map_frag(const skb_frag_t *frag)
+{
+	return skb_frag_size(frag) == PAGE_SIZE && !skb_frag_off(frag);
+}
+
+static int find_next_mappable_frag(const skb_frag_t *frag,
+				   int remaining_in_skb)
+{
+	int offset = 0;
+
+	if (likely(can_map_frag(frag)))
+		return 0;
+
+	while (offset < remaining_in_skb && !can_map_frag(frag)) {
+		offset += skb_frag_size(frag);
+		++frag;
+	}
+	return offset;
+}
+
 static int tcp_copy_straggler_data(struct tcp_zerocopy_receive *zc,
 				   struct sk_buff *skb, u32 copylen,
 				   u32 *offset, u32 *seq)
@@ -1903,6 +1923,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	ret = 0;
 	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
+		int mappable_offset;
+
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			u32 offset_frag;
 
@@ -1930,15 +1952,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			if (!frags || offset_frag)
 				break;
 		}
-		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
-			int remaining = zc->recv_skip_hint;
 
-			while (remaining && (skb_frag_size(frags) != PAGE_SIZE ||
-					     skb_frag_off(frags))) {
-				remaining -= skb_frag_size(frags);
-				frags++;
-			}
-			zc->recv_skip_hint -= remaining;
+		mappable_offset = find_next_mappable_frag(frags,
+							  zc->recv_skip_hint);
+		if (mappable_offset) {
+			zc->recv_skip_hint = mappable_offset;
 			break;
 		}
 		pages[pg_idx] = skb_frag_page(frags);
-- 
2.43.0



