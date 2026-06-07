Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E246A36DA14;
	Sun,  7 Jun 2026 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830107; cv=none; b=ZWj/xxUSmAoDRyDWstMlqVS0ahNTS0UkzFR0Y4nEXausAS1eXYTlhuZZFkNFMv2Qn2HKhPOODHyb/SkqKn53lhkwQNbtY95DYjr5NDItNCPB7iM1NINSSLGp7ma24DDwx7kbCTPamiud/AKvrexAge3py6dLSNgYPSbmmOVsevc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830107; c=relaxed/simple;
	bh=atsR76PubCXy/cOlKygtjtL5eQVRSh/JcoQjEWgmWAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6h/6QLFEN2aDfyEZvfuCW4XF0KgH04CJUVJgDFIDUgUh5xRZ2mM8Oh7MHk2fsjj+SX2nkc/PyWSdCZifZrP0HQR9ir/YPx7C4fDK1Of8//p+eBHbnxCb+oaXAnYEIxB6Y8RokXJ1nKEb3xGbW2Zq73EigW/nWaywe9s2bkG1Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDw/di4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDw/di4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D331F00893;
	Sun,  7 Jun 2026 11:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830106;
	bh=a1i/K/4SmXdBrn5c0e3VzTcwjmxJZc1p+MtS7ZkjE6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDw/di4b5IW4NnXCPegQx20Rw1wISSNiEFSLTM1TLvD2VvXA6DLfUqoCjfDIg7qpH
	 FGK5s3KgriTsYZEGdjJyAzE/wciLa5g80NcAC33bHlbhdmuG2pA5oALFDtG67dZVNi
	 lYdIlY1EwP4d45KNrLcZuWTJ9bhmcqOb9vjwh9Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/307] mptcp: reset rcv wnd on disconnect
Date: Sun,  7 Jun 2026 12:01:20 +0200
Message-ID: <20260607095738.125325952@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 0981f90e1a05773a4c29c6e720f5ea1e3c8f1876 ]

If the MPTCP socket fallback to TCP before the MP handshake completion,
the IASN remain 0, and the rcv_wnd_sent field is not explicitly
initialized, just incremented over time with the data transfer.

At disconnect time such value is not cleared. If the next connection falls
back to TCP before the MP handshake completion, the data transfer will
keep incrementing the receive window end sequence starting from the last
value used in the previous connection: the announced window will be
unrelated from the actual receiver buffer size and likely too big.

Address the issue zeroing the field at disconnect time.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-4-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3371,6 +3371,7 @@ static int mptcp_disconnect(struct sock
 
 	/* for fallback's sake */
 	WRITE_ONCE(msk->ack_seq, 0);
+	atomic64_set(&msk->rcv_wnd_sent, 0);
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);


