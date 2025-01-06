Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4B1155300;
	Mon,  6 Jan 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177610; cv=none; b=ZAZFUdaui8ed3tSGV/IBdx7JzdHUn4+R8WFHS032J7VK/YNITIsps26vkphOJ318XAWo9PaFzbJnIyYiFqLuBP1QjD6o4djeUCMNTLAqapoHPY8Pa8TL7Pd5h3fDozKaZlxV34K0HXqNJlCxX63d3gJaSZp7gmUJP+debrWVUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177610; c=relaxed/simple;
	bh=2vrKGt1RgcsT8aPoRFqmPjb8mcfbwmNU+l10Owdqvp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECE/iNf4l+DtaPvAb5je1ZZKYI3kqYaRIC+B4doOgOMM8vYnJKUcB2+ez94yKQcwl6VVy4bQTOI7TSzYQdna/YvIZCGUMGp7R5ylS6WSI1ECvLehNiDQS1Nf8OKhthV9bhIkKIpIwLs1M+5aSm/2/im7Jjq0ELvt+ejOKDr0sEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbTsLUeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbTsLUeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2785FC4CED2;
	Mon,  6 Jan 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177608;
	bh=2vrKGt1RgcsT8aPoRFqmPjb8mcfbwmNU+l10Owdqvp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbTsLUeoC9J85TnxcRiEo2SdzO5VENeTAAC7yaqvTz8rfCPvJIbJ+nr7xek4guPom
	 TdQubRZpHVsGFQWZa/rC5q73YfjznH9B2Tep48ymwWurrme3NOCZPjWImF7y1r815v
	 NanhcERNYP1QnHPyoqYxB1NB2ePzB/l2v0ZgSRMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 219/222] mptcp: fix recvbuffer adjust on sleeping rcvmsg
Date: Mon,  6 Jan 2025 16:17:03 +0100
Message-ID: <20250106151159.054331643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1902,6 +1902,8 @@ do_error:
 	goto out;
 }
 
+static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
+
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len, int flags,
@@ -1955,6 +1957,7 @@ static int __mptcp_recvmsg_mskq(struct m
 			break;
 	}
 
+	mptcp_rcv_space_adjust(msk, copied);
 	return copied;
 }
 
@@ -2231,7 +2234,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 
 		pr_debug("block timeout %ld\n", timeo);
-		mptcp_rcv_space_adjust(msk, copied);
 		err = sk_wait_data(sk, &timeo, NULL);
 		if (err < 0) {
 			err = copied ? : err;
@@ -2239,8 +2241,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 	}
 
-	mptcp_rcv_space_adjust(msk, copied);
-
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)


