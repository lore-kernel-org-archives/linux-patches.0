Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C575A146D6B;
	Mon,  6 Jan 2025 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176942; cv=none; b=NvOVEY3lvUEsTKXvS18186T9vmgr3vUjwHivE3H66zQ5vU6LZSX8iDqGfIPmQxVM/5ypx6TCPeEf1Pp3I6Rk486k0KSMHN9PSKlAONAzQpfHPqEZNB6JEc6VKOLMAPMhcxuK0MZrXWq9SMP9IlqcjesSs8e868PJQEUvfxyUOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176942; c=relaxed/simple;
	bh=ABMTbRpk6DrJp5228zrYqj0zspZrmNc781gXQOhuOD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCvk+GKE6ZArblTfY+2QWg6dpVEkOp2FfU5Z1CXDTV0RDtHJUqKcIW8MT166wCovnHlDkvkoOP7dPxebb2tVAQHgBoXYT4kp1q1w7IUiLK1OVGv7RFQ5rElkG+6UYHYs0OdO4f64Qut/iReoEow3lcJd/oifx/8vjFM3k7uGtcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFYF0v/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFYF0v/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE412C4CED2;
	Mon,  6 Jan 2025 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176942;
	bh=ABMTbRpk6DrJp5228zrYqj0zspZrmNc781gXQOhuOD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFYF0v/QqQV9XylqGp0UrcrHUgnnrG8dEP7adWj3M53/Dfxr4FE+ajX/Cjx8M5DIN
	 Y6jq/Vj0QRBREJ2h527h8C0JMbMuvHGBtd6opwGAQ0L47oH8EgwI+5d4WGYT5oZZY8
	 wsF+iFXIPNg6hGU0cV+j+FFd7OktTydER8ORQpDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 80/81] mptcp: fix recvbuffer adjust on sleeping rcvmsg
Date: Mon,  6 Jan 2025 16:16:52 +0100
Message-ID: <20250106151132.447248963@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 449e6912a2522af672e99992e1201a454910864e upstream.

If the recvmsg() blocks after receiving some data - i.e. due to
SO_RCVLOWAT - the MPTCP code will attempt multiple times to
adjust the receive buffer size, wrongly accounting every time the
cumulative of received data - instead of accounting only for the
delta.

Address the issue moving mptcp_rcv_space_adjust just after the
data reception and passing it only the just received bytes.

This also removes an unneeded difference between the TCP and MPTCP
RX code path implementation.

Fixes: 581302298524 ("mptcp: error out earlier on disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241230-net-mptcp-rbuf-fixes-v1-1-8608af434ceb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1917,6 +1917,8 @@ do_error:
 	goto out;
 }
 
+static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
+
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len, int flags,
@@ -1968,6 +1970,7 @@ static int __mptcp_recvmsg_mskq(struct m
 			break;
 	}
 
+	mptcp_rcv_space_adjust(msk, copied);
 	return copied;
 }
 
@@ -2246,7 +2249,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 
 		pr_debug("block timeout %ld\n", timeo);
-		mptcp_rcv_space_adjust(msk, copied);
 		err = sk_wait_data(sk, &timeo, NULL);
 		if (err < 0) {
 			err = copied ? : err;
@@ -2254,8 +2256,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 	}
 
-	mptcp_rcv_space_adjust(msk, copied);
-
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)


