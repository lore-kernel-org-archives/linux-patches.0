Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00A5848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181EAC433D2;
	Fri, 10 Mar 2023 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458339;
	bh=673vXCtGS1xPmJCtJG0R0xisxCiwYt4Q7vdWp2HMpnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLVwbJT4mJTKnsbgpH9Fm5avWc7zTb1Ft97FexnsRJmAIWVbIqf2SSPYCl+bVR8aW
	 jp/lXaX7AQVIZqI0Mu6Ili88C0CQDO+sqwbN5fhgoqqw9TaSMKfvrEsso6gs742vGL
	 I49j5N/wpJrXT9FA5s6MUprt4ej7WV0t0hElBK+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com,
	Marcel Holtmann <marcel@holtmann.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 4.19 245/252] Bluetooth: hci_sock: purge socket queues in the destruct() callback
Date: Fri, 10 Mar 2023 14:40:15 +0100
Message-Id: <20230310133726.958956162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit 709fca500067524381e28a5f481882930eebac88 upstream.

The receive path may take the socket right before hci_sock_release(),
but it may enqueue the packets to the socket queues after the call to
skb_queue_purge(), therefore the socket can be destroyed without clear
its queues completely.

Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
issue, because nothing is referencing the socket at this point.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -881,10 +881,6 @@ static int hci_sock_release(struct socke
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -1985,6 +1981,12 @@ done:
 	return err;
 }
 
+static void hci_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_write_queue);
+}
+
 static const struct proto_ops hci_sock_ops = {
 	.family		= PF_BLUETOOTH,
 	.owner		= THIS_MODULE,
@@ -2035,6 +2037,7 @@ static int hci_sock_create(struct net *n
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;


