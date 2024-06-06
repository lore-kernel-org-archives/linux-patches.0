Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF351A2FDD;
	Thu,  6 Jun 2024 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683225; cv=none; b=AcsiUNnvJd5HHguNUAjmpa20UU7Ek616wnsG5H3d/T0NelbGn621Rt5Td4t4b19xvvl8AFaQbgRjhx3vb1uojKO2eKUl9droOP0vCawxt0Rkqqh5ODPYuRLbtiQhqcWxdTgrIIhKRSiF6ucArIO5qVXuZ8/kF0SuRsiHtTMMXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683225; c=relaxed/simple;
	bh=zYMc2Hm/8uMjWYlhAWp+1nf7aZP/kJQ13p1byyM41vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlxGCGTuSoSsTQQFeHfwbZyvciDZ3b2aJEex7rYx5HQE40GRDensv1s574FpwpGwkIEPtU3sAYZHKZl3NFaIh8tfQT8Pv+heTVDU7yXSAcaed7KVJf+Yecq7qQi1y9NLgHMpZwlGMUdhJXMVMRRXd9IzCTcREcsE3q/QPqPYEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lI3Gzc2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lI3Gzc2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4C5C32781;
	Thu,  6 Jun 2024 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683225;
	bh=zYMc2Hm/8uMjWYlhAWp+1nf7aZP/kJQ13p1byyM41vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI3Gzc2QHRJP/jn6dc3DTZBPclTrlq9s2ZZbiYb2OrRE710IKPf5G9K8y2Fkh7pt4
	 QYfptawoqPU7bMEkNZSz/dpgi11nWB8kF0x6L0hlI3iPN+bJaIT0z6M+b74j9IGOsu
	 OvdSda/4/mf4oYCu/5ScvG/9AS8knRsGGiPliBcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/744] tcp: define initial scaling factor value as a macro
Date: Thu,  6 Jun 2024 15:57:19 +0200
Message-ID: <20240606131737.783576116@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 849ee75a38b297187c760bb1d23d8f2a7b1fc73e ]

So that other users could access it. Notably MPTCP will use
it in the next patch.

No functional change intended.

Acked-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231023-send-net-next-20231023-2-v1-4-9dc60939d371@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 697a6c8cec03 ("tcp: increase the default TCP scaling ratio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a3840a2749c19..343cd0a5e8e17 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1460,13 +1460,15 @@ static inline int tcp_space_from_win(const struct sock *sk, int win)
 	return __tcp_space_from_win(tcp_sk(sk)->scaling_ratio, win);
 }
 
+/* Assume a conservative default of 1200 bytes of payload per 4K page.
+ * This may be adjusted later in tcp_measure_rcv_mss().
+ */
+#define TCP_DEFAULT_SCALING_RATIO ((1200 << TCP_RMEM_TO_WIN_SCALE) / \
+				   SKB_TRUESIZE(4096))
+
 static inline void tcp_scaling_ratio_init(struct sock *sk)
 {
-	/* Assume a conservative default of 1200 bytes of payload per 4K page.
-	 * This may be adjusted later in tcp_measure_rcv_mss().
-	 */
-	tcp_sk(sk)->scaling_ratio = (1200 << TCP_RMEM_TO_WIN_SCALE) /
-				    SKB_TRUESIZE(4096);
+	tcp_sk(sk)->scaling_ratio = TCP_DEFAULT_SCALING_RATIO;
 }
 
 /* Note: caller must be prepared to deal with negative returns */
-- 
2.43.0



