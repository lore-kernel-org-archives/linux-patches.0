Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFDE3A1E92;
	Sat, 17 Oct 2026 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258570; cv=none; b=sPtFTj6mWjpCOpOBMlLVlXh9fstmTsKDy5x4WvUr3w5DjEhZ40Ctf9YI64V4PNTRlL14LSN11tSdVREo83EIwjbN1UD770KrZ3vVI9NhGdcweWePd7GbsSg0S90s19kMYih7thlucTO3M/xjRKi2te5TSu9UnmGNkG3cS1F/cnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258570; c=relaxed/simple;
	bh=We9cKLSzvX3pjUF5xaJ4aXy1nNoC6MaeTO/warIOZHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCl2e3/5ET/qmsQx8RaE0V/cYSrI2TUZyN5MzRWWTVZzz4gY4s8ZgthNx4Kj2oThjUapS8nPNil31cU8F4dtJ/qgXY44KXP5UoLzhnY0tbWlE38RNx0q3BTa1gHYrbgXVsxsYcezlLq62L1sV74wiQpeeqkNZs2+dRTZJZmjdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A68rPXcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A68rPXcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89AA1F000C5;
	Sat, 17 Oct 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258569;
	bh=7Y7qsKL8iC2XBPG9VnDDmHMVTJUBbOSEBGuMuXXqN5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A68rPXcWa7oE6dgPJaMBpx+XvWCRfJYGtP3EZ9+OF66bBVdLdD+RK8lrmiAs+mI0c
	 VsPtWmq30ZEwopNr25Fx1HNZIigZY3y5TaRXioy1aCwZTFuxXdSCyoF5kq37GJ7nGo
	 Ehdh6V4oByo2sbnE0eBNnrQ96EouqRqUTgNL8gJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0926/1674] kcm: fix zero-frag skb in frag_list on partial sendmsg error
Date: Sat, 17 Oct 2026 17:53:18 +0200
Message-ID: <20261017160454.901931776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 93b1c499d76d1..f8a960c7d1684 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -630,7 +630,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			skb = txm->frag_skb;
 		}
 
-		if (WARN_ON(!skb_shinfo(skb)->nr_frags)) {
+		if (WARN_ON_ONCE(!skb_shinfo(skb)->nr_frags)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -750,7 +750,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	struct sk_buff *skb = NULL, *head = NULL;
+	struct sk_buff *skb = NULL, *head = NULL, *frag_prev = NULL;
 	size_t copy, copied = 0;
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	int eor = (sock->type == SOCK_DGRAM) ?
@@ -825,6 +825,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 				else
 					skb->next = tskb;
 
+				frag_prev = skb;
 				skb = tskb;
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				continue;
@@ -935,6 +936,22 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
2.53.0



