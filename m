Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70043314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301246; cv=none; b=YA+Z4vEbiTF8uWanQzmozT1t5GY8fcrH3QkluIxgetha0Jtzm1BzKXPHcix9FzF49RfTpwQeXYkhevysDqUVnCetwMVJzjEbaEhagq+1zMp/mjWWotUSByntmKe3dtN3wQ556oWOfbGNXBSCkPHGlFg8WQPDVMYCBuAhKBoniRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301246; c=relaxed/simple;
	bh=xaFRN1f9Mf1+D3TQxJtcwOodaDxq9QJkm7qNWrMGVV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIqFxqPiZi1wKg1grLG+T5E/r11HvhJKRwAREotYVFliiCqVLb4iI6ay1EsEfyJoMTDn/7m0gzMUQBcNiFP1o0/xhE/0w7yMKmoOwng1hqPRonZ2elkWRzEWUl3mFZ0q4rXc6/X9PNc283RnEoNQ4jjhxmQJ0aZDLFECIeyuC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKY9j9Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKY9j9Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43248C19425;
	Sat, 28 Feb 2026 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301245;
	bh=xaFRN1f9Mf1+D3TQxJtcwOodaDxq9QJkm7qNWrMGVV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKY9j9Xhsg7uZ2eMUdSfmvhq0nV7A8TAAnkvafHQpbk8M+jufhD6vxLgnQD0wtQ/K
	 LhET0CLvb/aLx1AlveVtMqofGSSeFdLORdxrAtVzgEly1W3e1JSFSqmNCm7zZYJqWi
	 UaNmCQ7RgbgVCJkWWfbHMWF3trXI8JV11Hy4PsUSjwocXnvfd27YWCveVkKmNINljD
	 gzRC7z71vkJrw61xwUhjcdm6WZmWCEi1HSJop9jsiNqeuEdTYkWESjrax3zdNSzIfQ
	 qpqjZD9H6aU0LrLmfkCxinVMzJ9ZFmZR9T0Nk6fnHy9+06ajQ/HzM1DtL98FGaZOBV
	 TPgeRFx2wyGLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/752] kcm: fix zero-frag skb in frag_list on partial sendmsg error
Date: Sat, 28 Feb 2026 12:42:18 -0500
Message-ID: <20260228174750.1542406-427-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit ca220141fa8ebae09765a242076b2b77338106b0 ]

Syzkaller reported a warning in kcm_write_msgs() when processing a
message with a zero-fragment skb in the frag_list.

When kcm_sendmsg() fills MAX_SKB_FRAGS fragments in the current skb,
it allocates a new skb (tskb) and links it into the frag_list before
copying data. If the copy subsequently fails (e.g. -EFAULT from
user memory), tskb remains in the frag_list with zero fragments:

  head skb (msg being assembled, NOT yet in sk_write_queue)
  +-----------+
  | frags[17] |  (MAX_SKB_FRAGS, all filled with data)
  | frag_list-+--> tskb
  +-----------+    +----------+
                   | frags[0] |  (empty! copy failed before filling)
                   +----------+

For SOCK_SEQPACKET with partial data already copied, the error path
saves this message via partial_message for later completion. For
SOCK_SEQPACKET, sock_write_iter() automatically sets MSG_EOR, so a
subsequent zero-length write(fd, NULL, 0) completes the message and
queues it to sk_write_queue. kcm_write_msgs() then walks the
frag_list and hits:

  WARN_ON(!skb_shinfo(skb)->nr_frags)

TCP has a similar pattern where skbs are enqueued before data copy
and cleaned up on failure via tcp_remove_empty_skb(). KCM was
missing the equivalent cleanup.

Fix this by tracking the predecessor skb (frag_prev) when allocating
a new frag_list entry. On error, if the tail skb has zero frags,
use frag_prev to unlink and free it in O(1) without walking the
singly-linked frag_list. frag_prev is safe to dereference because
the entire message chain is only held locally (or in kcm->seq_skb)
and is not added to sk_write_queue until MSG_EOR, so the send path
cannot free it underneath us.

Also change the WARN_ON to WARN_ON_ONCE to avoid flooding the log
if the condition is somehow hit repeatedly.

There are currently no KCM selftests in the kernel tree; a simple
reproducer is available at [1].

[1] https://gist.github.com/mrpre/a94d431c757e8d6f168f4dd1a3749daa

Reported-by: syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000269a1405a12fdc77@google.com/T/
Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260219014256.370092-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index b4f01cb075615..f6d44481954cd 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -628,7 +628,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			skb = txm->frag_skb;
 		}
 
-		if (WARN_ON(!skb_shinfo(skb)->nr_frags) ||
+		if (WARN_ON_ONCE(!skb_shinfo(skb)->nr_frags) ||
 		    WARN_ON_ONCE(!skb_frag_page(&skb_shinfo(skb)->frags[0]))) {
 			ret = -EINVAL;
 			goto out;
@@ -749,7 +749,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	struct sk_buff *skb = NULL, *head = NULL;
+	struct sk_buff *skb = NULL, *head = NULL, *frag_prev = NULL;
 	size_t copy, copied = 0;
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	int eor = (sock->type == SOCK_DGRAM) ?
@@ -824,6 +824,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 				else
 					skb->next = tskb;
 
+				frag_prev = skb;
 				skb = tskb;
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				continue;
@@ -933,6 +934,22 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 out_error:
 	kcm_push(kcm);
 
+	/* When MAX_SKB_FRAGS was reached, a new skb was allocated and
+	 * linked into the frag_list before data copy. If the copy
+	 * subsequently failed, this skb has zero frags. Remove it from
+	 * the frag_list to prevent kcm_write_msgs from later hitting
+	 * WARN_ON(!skb_shinfo(skb)->nr_frags).
+	 */
+	if (frag_prev && !skb_shinfo(skb)->nr_frags) {
+		if (head == frag_prev)
+			skb_shinfo(head)->frag_list = NULL;
+		else
+			frag_prev->next = NULL;
+		kfree_skb(skb);
+		/* Update skb as it may be saved in partial_message via goto */
+		skb = frag_prev;
+	}
+
 	if (sock->type == SOCK_SEQPACKET) {
 		/* Wrote some bytes before encountering an
 		 * error, return partial success.
-- 
2.51.0

