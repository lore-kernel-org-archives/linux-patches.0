Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE6C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6ACC433EF;
	Mon, 16 Jan 2023 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888815;
	bh=ukihnZczW+ImpiuJlAqLtc7JU3W2WJrVZRxV0L63ZZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr0gNpb0PUfCg3efXoMhO9FK3CoxIa+9PhY08AKstbIWz43KF26b4cZEgY2STP14o
	 Zk+/PeKOw0ULQ+FIt5roeHB4BuYu8ubz4hJNtdjRfuiMab6BQdj9MUOK97PFK+klri
	 lh+59zN6O1LQMJqdCyH0taDmqagKNKcB3FpZcfFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Vishnu Dasa <vdasa@vmware.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/338] net: vmw_vsock: vmci: Check memcpy_from_msg()
Date: Mon, 16 Jan 2023 16:49:52 +0100
Message-Id: <20230116154826.031566567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 44aa5a6dba8283bfda28b1517af4de711c5652a4 ]

vmci_transport_dgram_enqueue() does not check the return value
of memcpy_from_msg().  If memcpy_from_msg() fails, it is possible that
uninitialized memory contents are sent unintentionally instead of user's
message in the datagram to the destination.  Return with an error if
memcpy_from_msg() fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vmci_transport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index c1da1ce3d36e..da17b4c153b1 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1730,7 +1730,11 @@ static int vmci_transport_dgram_enqueue(
 	if (!dg)
 		return -ENOMEM;
 
-	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	err = memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	if (err) {
+		kfree(dg);
+		return err;
+	}
 
 	dg->dst = vmci_make_handle(remote_addr->svm_cid,
 				   remote_addr->svm_port);
-- 
2.35.1



