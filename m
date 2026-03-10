Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEC637B413;
	Tue, 10 Mar 2026 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142038; cv=none; b=by/asZo+docbudlFMiIMvfjdydo4zgiRGVQfWN191foithJL+b9cZ9/23Wccgc9rdXa4pWlITWL1up4qDDKaJa3X64OhZDw2YKT91iqa2dOo3Gh6EGnXZjfxpRgSbUL/VZubLYT8ls44uTJOpSywI0nvY+BlHzuey+Y1eBxvqbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142038; c=relaxed/simple;
	bh=+51xsvygzXq3L1GFYHomxX1bx4fE60VGQGJfpi/uhRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoFyKz/81/q7cqYYdwH7WUmHwjgivLH5Y2ZbDliTFb9YklHkZ+NGy8LlleWhFxQNW5PV4dTNvJYOxr4/807wiOUDcOjfIvFFieNgP8iyxvKYVUunw26aV+SeTV012llVD4bDa5hV0K3rx4CkubP9XVpnl9A0DuKZboNlizY35wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNT9lT5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNT9lT5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB78C2BC86;
	Tue, 10 Mar 2026 11:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142038;
	bh=+51xsvygzXq3L1GFYHomxX1bx4fE60VGQGJfpi/uhRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNT9lT5JQXZgAaaz42Ru47eWUz+koEjNrh86eUhDkI5ZMGwOaRKsxlh0aGunu7Kib
	 V9EjysGuLpPlTfJUwEygbexcJpPETVLkBLMVw5xxD5D0HGIC+19sK7dxehs54W5dms
	 ePZwbeR7/XwTKUMqDi9By8d2bpSLtkkAHHQTjRedX1FP0U0rUbV5mNDJKvxthNTnEL
	 S6LR9X8XAeEGSJvFISOmAy6469nE5mwemEufcDgORxEWa6tEXoFFKl8zP2U0g5uw7Z
	 AG5MrIiYVtQyz1tvdZMEsBY5g/x7OBFZhARaCtz12jK+YA2XFWn3YfLEcSmruT95Mg
	 MXldDDa9YF1UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heitor Alves de Siqueira <halves@igalia.com>,
	syzbot+7ff4013eabad1407b70a@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 166/314] Bluetooth: purge error queues in socket destructors
Date: Tue, 10 Mar 2026 07:17:05 -0400
Message-ID: <c7775a2a6b778652e3d16b91531fd5da61fd5ae0.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 21e4271e65094172aadd5beb8caea95dd0fbf6d7 upstream.

When TX timestamping is enabled via SO_TIMESTAMPING, SKBs may be queued
into sk_error_queue and will stay there until consumed. If userspace never
gets to read the timestamps, or if the controller is removed unexpectedly,
these SKBs will leak.

Fix by adding skb_queue_purge() calls for sk_error_queue in affected
bluetooth destructors. RFCOMM does not currently use sk_error_queue.

Fixes: 134f4b39df7b ("Bluetooth: add support for skb TX SND/COMPLETION timestamping")
Reported-by: syzbot+7ff4013eabad1407b70a@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=7ff4013eabad1407b70a
Cc: stable@vger.kernel.org
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c   | 1 +
 net/bluetooth/iso.c        | 1 +
 net/bluetooth/l2cap_sock.c | 1 +
 net/bluetooth/sco.c        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index ad19022ae127a..5295ff001e38c 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -2166,6 +2166,7 @@ static void hci_sock_destruct(struct sock *sk)
 	mgmt_cleanup(sk);
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static const struct proto_ops hci_sock_ops = {
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 616c2fef91d24..46ebd69026fe2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -728,6 +728,7 @@ static void iso_sock_destruct(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static void iso_sock_cleanup_listen(struct sock *parent)
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index c877fe5aed07d..ab86aeef98d18 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1806,6 +1806,7 @@ static void l2cap_sock_destruct(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static void l2cap_skb_msg_name(struct sk_buff *skb, void *msg_name,
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 298c2a9ab4df8..49a47eaa674da 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -470,6 +470,7 @@ static void sco_sock_destruct(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static void sco_sock_cleanup_listen(struct sock *parent)
-- 
2.51.0

