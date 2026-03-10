Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837E352C4F;
	Tue, 10 Mar 2026 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141133; cv=none; b=m/9llGyvamxDWDM27Xr/LRPoAtIRKdKDWIt0IGgDL1BP2VT5YU6mKdn/pTnE591jV1bd/TCS4lk7c8dSlOzeMEsLE9nen+B9hqA6ObDgKqMFXRLKeLAM8SXlscB39hF8pxr16e6vxBrvY2K4P1kP320fi8jIgM8r8xV9r6r/YjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141133; c=relaxed/simple;
	bh=ufVtza5xnnSAhp6kUDtS7tyPcpNKc+gKl8a5yrSx4pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxOWV5W8JFwSNlYTf71YPYen8p+/YZKMmRwaTA8Oy+0pRtIymuhpWq+9Ot7e9l2nm6DR6Nrjdms5J/Ec9K/vF2Zqz3TivFfvdcpsuLuLAIeq9Apu+9D6ju402NMdbsZ8Mz1WzakN1M5ncQlLwuYNJk1omodL02CUTE0kuf+2/2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWG1wXgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWG1wXgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0649C2BC9E;
	Tue, 10 Mar 2026 11:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141133;
	bh=ufVtza5xnnSAhp6kUDtS7tyPcpNKc+gKl8a5yrSx4pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWG1wXgXLLjU/yBfpU/0Uaaj/SW0SdfXZUfU/7qg2srNS7OTanC6kyeQEE9qlVxEQ
	 W0vmFZ3JNXqRZaF660PFe9YMfvzpWvvJ6HNDL+3+KCEGIhbB/nVeCBzpBA0tYtn0Rg
	 4GlmNXE+K/6ViTq8R2ehJAnN8MyacXmHwrVNbLIDdEFQ+uQ2lkUxMtOc8m613jgJB1
	 AsFPMmc+KS5cfFYmnekDks71C7mD312rz+P6FUmpwIFbweeJjux8Wya4FC9MPQR6bn
	 Yo5nr9SiPUKUUvCr7GmX7naCHq/y9bBIIjYg+DeJ3G3IajoDUScHFd6crDWJdwDchU
	 qyHmXTt+jkBvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heitor Alves de Siqueira <halves@igalia.com>,
	syzbot+7ff4013eabad1407b70a@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 137/311] Bluetooth: purge error queues in socket destructors
Date: Tue, 10 Mar 2026 07:03:04 -0400
Message-ID: <d4d90135368adf02b891a79dac05185ac9283558.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 4e7bf63af9c5f..0290dea081f62 100644
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
index e36d24a9098b9..0f07f05c15577 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -746,6 +746,7 @@ static void iso_sock_destruct(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static void iso_sock_cleanup_listen(struct sock *parent)
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 66ab2754594d6..bc9760e0abaf8 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1806,6 +1806,7 @@ static void l2cap_sock_destruct(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_write_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static void l2cap_skb_msg_name(struct sk_buff *skb, void *msg_name,
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 87ba90336e803..cccfaf5603174 100644
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

