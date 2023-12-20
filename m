Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE564184A;
	Wed, 20 Dec 2023 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfB4TTjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705D2C433C7;
	Wed, 20 Dec 2023 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088872;
	bh=NWvajO27qtx+f89lUQN0pGRx1e/MyLFOPii3ntKT38E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfB4TTjBdM3KEui9WoZwlvuaQYIpj+sTL9jNhGVRg1UeUo1OVea93MouXt7zKbJTM
	 loWPF46B1JHH3hdObscxIy9sWvC+i13zVGmpOda7kp3ZJWbYvkbFB5GB2QKdwpyuxL
	 ZBXDOqvLrlXnxqsa5/1iXBEVm49oBKxAZ20igEJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 062/159] ksmbd: call ib_drain_qp when disconnected
Date: Wed, 20 Dec 2023 17:08:47 +0100
Message-ID: <20231220160934.247706671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 141fa9824c0fc11d44b2d5bb1266a33e95fa67fd ]

When disconnected, call ib_drain_qp to cancel all pending work requests
and prevent ksmbd_conn_handler_loop from waiting for a long time
for those work requests to compelete.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1527,6 +1527,8 @@ static int smb_direct_cm_handler(struct
 	}
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
+		ib_drain_qp(t->qp);
+
 		t->status = SMB_DIRECT_CS_DISCONNECTED;
 		wake_up_interruptible(&t->wait_status);
 		wake_up_interruptible(&t->wait_reassembly_queue);


