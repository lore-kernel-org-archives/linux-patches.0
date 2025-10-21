Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1279527815E;
	Tue, 21 Oct 2025 20:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077082; cv=none; b=fsSHLPj4apHu7F0BwSbzaRtJeEfq2rFbPTNTmPzJnWPYqZbotqm8icRqZtU+sILNRFV7X0KmMDD7EHaoxwafdifRwT3m0lJPbpUXKgbk/uN3P8o+LjAD6GxLj00SxmDG2nrIa9i+rCrbRoAioLzz23Ldb8yPM5wACrrJoXTpj08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077082; c=relaxed/simple;
	bh=6YEDFmJNQayL1TWBo39454LEvHaX5RuB68yz+X8sBAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcswqRV3N0k3RWWUJ7wlSvRhpErIBpPFB0V/Uur4nD5yLjLXVQ5qrvm75ACpOoxTx2YWNwX/RlTQPcpTfP6TAeC1meJTORCrd2oUAs8zbVdSgLDEj/EX+aJw0fiOA0PG3dnSQ8hSy/+O8xvBK45rU821VXTbgZlQlad4Ff7hQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1ABVvj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1ABVvj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9ADC4CEF1;
	Tue, 21 Oct 2025 20:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077081;
	bh=6YEDFmJNQayL1TWBo39454LEvHaX5RuB68yz+X8sBAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1ABVvj6bRdY2ecIyZTcLnRHPodHKLFFusVXppFmqNhSLdpnR1bnUVo70fhzCW2Fo
	 d0QB/2VD65xGXKaxsR3VX1Z7vuUMPBMX/oaFb9B0m2/XDF/6S6YlGWf8Z9QwSZh3p9
	 plhpwfDbVEYLlSB7ChTx+pGm/G3S9PZRlc+E38+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/136] mptcp: Use __sk_dst_get() and dst_dev_rcu() in mptcp_active_enable().
Date: Tue, 21 Oct 2025 21:51:57 +0200
Message-ID: <20251021195039.088834210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 893c49a78d9f85e4b8081b908fb7c407d018106a ]

mptcp_active_enable() is called from subflow_finish_connect(),
which is icsk->icsk_af_ops->sk_rx_dst_set() and it's not always
under RCU.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dst_dev_rcu().

Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-8-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 833d4313bc1e ("mptcp: reset blackhole on success with non-loopback ifaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -381,12 +381,15 @@ void mptcp_active_enable(struct sock *sk
 	struct mptcp_pernet *pernet = mptcp_get_pernet(sock_net(sk));
 
 	if (atomic_read(&pernet->active_disable_times)) {
-		struct dst_entry *dst = sk_dst_get(sk);
+		struct net_device *dev;
+		struct dst_entry *dst;
 
-		if (dst && dst->dev && (dst->dev->flags & IFF_LOOPBACK))
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
+		if (dev && (dev->flags & IFF_LOOPBACK))
 			atomic_set(&pernet->active_disable_times, 0);
-
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 


