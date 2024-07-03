Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E47172BCD;
	Wed,  3 Jul 2024 10:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003370; cv=none; b=W2i1KBY8AXOWNnT5+eDkT+VMej6KI90NVBUVwoIZ3hhXQSTSw4/lfKV/GKdmZyjLIffDfXg+NVzExweoW4+NiUt8ClxVV2v3dQ4/nwL2mQgdwBiY+NRDtkJejskKEKEz/jW8LEKvd+83oLcpwWueF9vfIzssqCbO7mPmuTMLTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003370; c=relaxed/simple;
	bh=7NL08pdKXtxhYmrrOqodX67E2h2Y2OSPmafi9mdLpQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE3MB3mVXd48s5RxDcIXcig+jfApQNna1PcKktImy4uoqNLaRkbUHL3fMjdyYA4CVa7FM53EwZ4ep9I0EK2C2EWHvM3+K8Jk38/vhBkm4cgDTDiZiRoVyA5E37yLPlat9qhUqgVrG/lHOAQMawlDthzUOv1PBpRGMr7gIQRxcVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYqSCLQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYqSCLQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17D5C2BD10;
	Wed,  3 Jul 2024 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003370;
	bh=7NL08pdKXtxhYmrrOqodX67E2h2Y2OSPmafi9mdLpQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYqSCLQvNw10JBpaRzzsbi164/I2EiJdgGvDT1DPO95qLDofPm84VtUVyMDCVirKf
	 QahXFcnEWz93vn75p3PHctU6SjZ4TtQ2ddoqNngokLxkysFIVDya8v7NL0QUFOSGEe
	 AvE9sqzkibf1g1t/iIUXT3dZ3GozS9rZXi8lhY4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/139] af_unix: Annotate data-race of sk->sk_state in unix_inq_len().
Date: Wed,  3 Jul 2024 12:38:26 +0200
Message-ID: <20240703102830.788948230@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3a0f38eb285c8c2eead4b3230c7ac2983707599d ]

ioctl(SIOCINQ) calls unix_inq_len() that checks sk->sk_state first
and returns -EINVAL if it's TCP_LISTEN.

Then, for SOCK_STREAM sockets, unix_inq_len() returns the number of
bytes in recvq.

However, unix_inq_len() does not hold unix_state_lock(), and the
concurrent listen() might change the state after checking sk->sk_state.

If the race occurs, 0 is returned for the listener, instead of -EINVAL,
because the length of skb with embryo is 0.

We could hold unix_state_lock() in unix_inq_len(), but it's overkill
given the result is true for pre-listen() TCP_CLOSE state.

So, let's use READ_ONCE() for sk->sk_state in unix_inq_len().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 02100e62bf608..d363a268f272e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2584,7 +2584,7 @@ long unix_inq_len(struct sock *sk)
 	struct sk_buff *skb;
 	long amount = 0;
 
-	if (sk->sk_state == TCP_LISTEN)
+	if (READ_ONCE(sk->sk_state) == TCP_LISTEN)
 		return -EINVAL;
 
 	spin_lock(&sk->sk_receive_queue.lock);
-- 
2.43.0



