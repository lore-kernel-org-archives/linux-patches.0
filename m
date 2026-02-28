Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2DB359A71
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302394; cv=none; b=KJ2NHufk87IIYr+QTQg61lKFmtjGqlPQpVBwBVjvdNmjCvXkBUwz/TPNpSqTdnjfSE8rN2Qwj5exk462w1hl+sHvTfXIa+zv7HrOr7+3c9IzKqeWFTurYgscJTDk3YIMmIwHXJ9UXUvwwLXWQhD6G6HhDt5/Qh1IJGMeXg/X/UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302394; c=relaxed/simple;
	bh=xXbVhbL7EiIbb7vtMnisjiKX3lPlhLgMp9+x2b/veOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNo8q5vdy3cbb0R7Ss5yxS1HZFsyXY/8SrjH3MNU4ggkwDVEt2zttjb+Qy6qeHYWiqh9LY14rwKgAxyd4Q/rWqIV4p72Ew3u8b4b2GE4TOF5UGKGDbmveLF1AJR27wb094n9OXLuLUz0jYgfizmh/LXtmVYj4U/mUeFq68NIC6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1Nv2Wf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1Nv2Wf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCC3C19423;
	Sat, 28 Feb 2026 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302394;
	bh=xXbVhbL7EiIbb7vtMnisjiKX3lPlhLgMp9+x2b/veOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1Nv2Wf07iSTLmN78hvL7Gp6kMu/j1bjTytFmI7euvQQiN70tZPSaX0nALFfNWWtH
	 hWWV3voOhzG4RVHTMGLRstI8JiVwNMBjhjUjPwTS0oDywWB/Eu6hs0OablmjqRh73j
	 Vc4vBNjyduSQ867uzSEqqY3lgR0o8/LYM+mKVLhAzJ/ylA8/uZbeEoHW+JW5Rj2dos
	 7NwI80DF3+ygwPnduPxLUNQ0nJUjRqGOZs44XRNX+p9bkbRKJ0zY26SZClCXLwFT2a
	 c8yuWChNoWr9wDXqr64GHcxt2i+pUv5IZcTLHeOZpwjOgfCgi/6Px0MfJImcEvrLLI
	 SuO2O/t9oTyyg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+1f22cb1769f249df9fa0@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/232] net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
Date: Sat, 28 Feb 2026 13:09:36 -0500
Message-ID: <20260228181127.1592657-123-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

[ Upstream commit ae88a5d2f29b69819dc7b04086734439d074a643 ]

Reproducer available at [1].

The ATM send path (sendmsg -> vcc_sendmsg -> sigd_send) reads the vcc
pointer from msg->vcc and uses it directly without any validation. This
pointer comes from userspace via sendmsg() and can be arbitrarily forged:

    int fd = socket(AF_ATMSVC, SOCK_DGRAM, 0);
    ioctl(fd, ATMSIGD_CTRL);  // become ATM signaling daemon
    struct msghdr msg = { .msg_iov = &iov, ... };
    *(unsigned long *)(buf + 4) = 0xdeadbeef;  // fake vcc pointer
    sendmsg(fd, &msg, 0);  // kernel dereferences 0xdeadbeef

In normal operation, the kernel sends the vcc pointer to the signaling
daemon via sigd_enq() when processing operations like connect(), bind(),
or listen(). The daemon is expected to return the same pointer when
responding. However, a malicious daemon can send arbitrary pointer values.

Fix this by introducing find_get_vcc() which validates the pointer by
searching through vcc_hash (similar to how sigd_close() iterates over
all VCCs), and acquires a reference via sock_hold() if found.

Since struct atm_vcc embeds struct sock as its first member, they share
the same lifetime. Therefore using sock_hold/sock_put is sufficient to
keep the vcc alive while it is being used.

Note that there may be a race with sigd_close() which could mark the vcc
with various flags (e.g., ATM_VF_RELEASED) after find_get_vcc() returns.
However, sock_hold() guarantees the memory remains valid, so this race
only affects the logical state, not memory safety.

[1]: https://gist.github.com/mrpre/1ba5949c45529c511152e2f4c755b0f3
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+1f22cb1769f249df9fa0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69039850.a70a0220.5b2ed.005d.GAE@google.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260205095501.131890-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/signaling.c | 56 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/net/atm/signaling.c b/net/atm/signaling.c
index 5de06ab8ed752..5a5d8b1fa8be8 100644
--- a/net/atm/signaling.c
+++ b/net/atm/signaling.c
@@ -22,6 +22,36 @@
 
 struct atm_vcc *sigd = NULL;
 
+/*
+ * find_get_vcc - validate and get a reference to a vcc pointer
+ * @vcc: the vcc pointer to validate
+ *
+ * This function validates that @vcc points to a registered VCC in vcc_hash.
+ * If found, it increments the socket reference count and returns the vcc.
+ * The caller must call sock_put(sk_atm(vcc)) when done.
+ *
+ * Returns the vcc pointer if valid, NULL otherwise.
+ */
+static struct atm_vcc *find_get_vcc(struct atm_vcc *vcc)
+{
+	int i;
+
+	read_lock(&vcc_sklist_lock);
+	for (i = 0; i < VCC_HTABLE_SIZE; i++) {
+		struct sock *s;
+
+		sk_for_each(s, &vcc_hash[i]) {
+			if (atm_sk(s) == vcc) {
+				sock_hold(s);
+				read_unlock(&vcc_sklist_lock);
+				return vcc;
+			}
+		}
+	}
+	read_unlock(&vcc_sklist_lock);
+	return NULL;
+}
+
 static void sigd_put_skb(struct sk_buff *skb)
 {
 	if (!sigd) {
@@ -69,7 +99,14 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 
 	msg = (struct atmsvc_msg *) skb->data;
 	WARN_ON(refcount_sub_and_test(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc));
-	vcc = *(struct atm_vcc **) &msg->vcc;
+
+	vcc = find_get_vcc(*(struct atm_vcc **)&msg->vcc);
+	if (!vcc) {
+		pr_debug("invalid vcc pointer in msg\n");
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	pr_debug("%d (0x%lx)\n", (int)msg->type, (unsigned long)vcc);
 	sk = sk_atm(vcc);
 
@@ -100,7 +137,16 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		clear_bit(ATM_VF_WAITING, &vcc->flags);
 		break;
 	case as_indicate:
-		vcc = *(struct atm_vcc **)&msg->listen_vcc;
+		/* Release the reference from msg->vcc, we'll use msg->listen_vcc instead */
+		sock_put(sk);
+
+		vcc = find_get_vcc(*(struct atm_vcc **)&msg->listen_vcc);
+		if (!vcc) {
+			pr_debug("invalid listen_vcc pointer in msg\n");
+			dev_kfree_skb(skb);
+			return -EINVAL;
+		}
+
 		sk = sk_atm(vcc);
 		pr_debug("as_indicate!!!\n");
 		lock_sock(sk);
@@ -115,6 +161,8 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		sk->sk_state_change(sk);
 as_indicate_complete:
 		release_sock(sk);
+		/* Paired with find_get_vcc(msg->listen_vcc) above */
+		sock_put(sk);
 		return 0;
 	case as_close:
 		set_bit(ATM_VF_RELEASED, &vcc->flags);
@@ -131,11 +179,15 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		break;
 	default:
 		pr_alert("bad message type %d\n", (int)msg->type);
+		/* Paired with find_get_vcc(msg->vcc) above */
+		sock_put(sk);
 		return -EINVAL;
 	}
 	sk->sk_state_change(sk);
 out:
 	dev_kfree_skb(skb);
+	/* Paired with find_get_vcc(msg->vcc) above */
+	sock_put(sk);
 	return 0;
 }
 
-- 
2.51.0

