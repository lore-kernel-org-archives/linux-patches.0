Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BC7157E82;
	Mon,  6 Jan 2025 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178103; cv=none; b=l2/Z4652e3U9WhH6037RaUVAn0FmTV49MUy7/PMC1qcjqHKK3MGGy9Szl2GA8NQq/5JIb8ob0ypRrYTKi0CKpD88uUGdwMQMTlC9X0tq8TwXDENkgBGWiOdT/Bk/FXLITJozloC5vuZsBayYHZAa4JuqS39PkY/IMKBbXXDrL54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178103; c=relaxed/simple;
	bh=pbgTJ41lEZczWOhBpP853vh122i1b6LCSfKAP3NTgks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtYO2M94d4Cpn/rBiBd9xKU92fUXuns3L+dyd19SJ2u+mp3r8YCyZ1CF4dArwP8k0y7KWvrFv7KQqg5jywmW9cuWvv9Xi223sydYbDFsc6oXzevi0ItAMfVW0EGwZGha3xU33exACr5kGekHCclBN0T7g4+Z2/PyPYl1mJJaY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QISCunls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QISCunls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6462C4CED2;
	Mon,  6 Jan 2025 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178103;
	bh=pbgTJ41lEZczWOhBpP853vh122i1b6LCSfKAP3NTgks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QISCunlsCO8gan84dkSgL/09g2OZAJkzXkJXN5pvHkHUQlndddr29izMwxxcNJ0mL
	 UJnfRchqXvMtG2+B/eRCVWfE6OVbIj6JDsBxesd5Wdw/zYYIXt0sXNIQ1fHNW5Su48
	 0M1pXgb+8AH1fkIH5nGxVJYmGgf99jzp/WiT0kHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 155/156] mptcp: fix recvbuffer adjust on sleeping rcvmsg
Date: Mon,  6 Jan 2025 16:17:21 +0100
Message-ID: <20250106151147.568443598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1939,6 +1939,8 @@ do_error:
 	goto out;
 }
 
+static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
+
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len, int flags,
@@ -1992,6 +1994,7 @@ static int __mptcp_recvmsg_mskq(struct m
 			break;
 	}
 
+	mptcp_rcv_space_adjust(msk, copied);
 	return copied;
 }
 
@@ -2268,7 +2271,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 
 		pr_debug("block timeout %ld\n", timeo);
-		mptcp_rcv_space_adjust(msk, copied);
 		err = sk_wait_data(sk, &timeo, NULL);
 		if (err < 0) {
 			err = copied ? : err;
@@ -2276,8 +2278,6 @@ static int mptcp_recvmsg(struct sock *sk
 		}
 	}
 
-	mptcp_rcv_space_adjust(msk, copied);
-
 out_err:
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)


