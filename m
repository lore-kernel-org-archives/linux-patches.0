Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5D4A9AB;
	Wed, 20 Dec 2023 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkhYGfEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49076C433C7;
	Wed, 20 Dec 2023 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088735;
	bh=BqxKPyz8IzlVfOEtd3PmChy8yMFYeFF6I8EK8VAC6aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkhYGfEqiSWhsrEo/Bx0YFvTOKnPHuKsODKtYTzZEj7yFPWdyHW6ww6dkCut0s0Kk
	 dAqKJHBcgWpkZtoEGd8S5OQeOQAigLdugWt9ywnmA/mVPgARTok2nX6BiA8j0axN2S
	 4l6soHxnJ3BxNXxO3eESQftoLymL4za8733LjJFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufan Chen <wiz.chen@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 040/159] ksmbd: smbd: fix connection dropped issue
Date: Wed, 20 Dec 2023 17:08:25 +0100
Message-ID: <20231220160933.166630566@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 5366afc4065075a4456941fbd51c33604d631ee5 ]

When there are bursty connection requests,
RDMA connection event handler is deferred and
Negotiation requests are received even if
connection status is NEW.

To handle it, set the status to CONNECTED
if Negotiation requests are received.

Reported-by: Yufan Chen <wiz.chen@gmail.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -576,6 +576,7 @@ static void recv_done(struct ib_cq *cq,
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;


