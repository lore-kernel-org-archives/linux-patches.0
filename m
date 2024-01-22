Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B53664CC9;
	Tue, 23 Jan 2024 01:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975047; cv=none; b=Mcioieq49kVaM/MGdujhvOnP6qG1ZcxAknluYTxDi8Az35oV+MYQ8jYqHV6Ewk22M81Nk0XXyI3E6H+D0FRK2kVG0J32lEsYYc98mR8a8GKdZEjG0Aj85QAS0TZ7F1PeLGempu+bbuXoT69YS6gJMD4c70TcPYCDKwpOLMH/DoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975047; c=relaxed/simple;
	bh=X7PgeLi2SXzy5Fxof7xWoLD4FRyEyM5+xt1RPv/8M2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClVyi6VRAXYSIyb0sQGaAodZAuR5Ki+8TiUucJIFuFyA1PzarA49S75PnvQWpeLUGR+2iLn5WDlSWFaMQ/cuj6Q7AuwP13rkFHolLOA72mib3jWgtD3+WPgAi/wSztoIUNSqWeCHZtTNGxARs77MHbhJ8YFrh0fdkcMXnHJXNqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cF2/rVZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cF2/rVZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE14FC433C7;
	Tue, 23 Jan 2024 01:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975046;
	bh=X7PgeLi2SXzy5Fxof7xWoLD4FRyEyM5+xt1RPv/8M2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cF2/rVZQzim5QKBj58WEKt1Hl3obx4y7TIGO0jeIceb6+d497WfT1U/R7aVLqxon4
	 SuAmKkDzRsUDwmTsFZKkccgag7moHjyr+NPyl5mWpz9XCtlg+Gxd1hvldGrccgyiRh
	 lUw5svKZ6eGcIRNM22NKRPAuk1ZIQol5GpuHZatk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingwei Lee <xrivendell7@gmail.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/583] bpf: sockmap, fix proto update hook to avoid dup calls
Date: Mon, 22 Jan 2024 15:54:23 -0800
Message-ID: <20240122235818.499934945@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 16b2f264983dc264c1560cc0170e760dec1bf54f ]

When sockets are added to a sockmap or sockhash we allocate and init a
psock. Then update the proto ops with sock_map_init_proto the flow is

  sock_hash_update_common
    sock_map_link
      psock = sock_map_psock_get_checked() <-returns existing psock
      sock_map_init_proto(sk, psock)       <- updates sk_proto

If the socket is already in a map this results in the sock_map_init_proto
being called multiple times on the same socket. We do this because when
a socket is added to multiple maps this might result in a new set of BPF
programs being attached to the socket requiring an updated ops struct.

This creates a rule where it must be safe to call psock_update_sk_prot
multiple times. When we added a fix for UAF through unix sockets in patch
4dd9a38a753fc we broke this rule by adding a sock_hold in that path
to ensure the sock is not released. The result is if a af_unix stream sock
is placed in multiple maps it results in a memory leak because we call
sock_hold multiple times with only a single sock_put on it.

Fixes: 8866730aed51 ("bpf, sockmap: af_unix stream sockets need to hold ref for pair sock")
Reported-by: Xingwei Lee <xrivendell7@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20231221232327.43678-2-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/unix_bpf.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 7ea7c3a0d0d0..bd84785bf8d6 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -161,15 +161,30 @@ int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool r
 {
 	struct sock *sk_pair;
 
+	/* Restore does not decrement the sk_pair reference yet because we must
+	 * keep the a reference to the socket until after an RCU grace period
+	 * and any pending sends have completed.
+	 */
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
 		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
-	sk_pair = unix_peer(sk);
-	sock_hold(sk_pair);
-	psock->sk_pair = sk_pair;
+	/* psock_update_sk_prot can be called multiple times if psock is
+	 * added to multiple maps and/or slots in the same map. There is
+	 * also an edge case where replacing a psock with itself can trigger
+	 * an extra psock_update_sk_prot during the insert process. So it
+	 * must be safe to do multiple calls. Here we need to ensure we don't
+	 * increment the refcnt through sock_hold many times. There will only
+	 * be a single matching destroy operation.
+	 */
+	if (!psock->sk_pair) {
+		sk_pair = unix_peer(sk);
+		sock_hold(sk_pair);
+		psock->sk_pair = sk_pair;
+	}
+
 	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
 	sock_replace_proto(sk, &unix_stream_bpf_prot);
 	return 0;
-- 
2.43.0



