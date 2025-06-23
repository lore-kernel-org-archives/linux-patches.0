Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B13D21FF2B;
	Mon, 23 Jun 2025 21:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715934; cv=none; b=MB+dy4v9hQU2uMQ9m0MLRDWTRlJ1RKgW7fqp5gysoBA3KAmvQuyV3iM/6dZAAgmUcSKUeEKxIR13w+RoLg/emfEYWYZmi8+dMotx7+jPBvtRbnGVb82cIMV2wseDWVR4g3Y3Nky1wrP1ThO9L3owJlQq51yHT3FsZseS4Fr9GY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715934; c=relaxed/simple;
	bh=6d9nqRmmeLYcB2IeuOhhPghpWSZVOWGHtoSZmL+xDBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8GVyeTOHDqimYRfm/BhtGnvhGvjM0JsEDtTsPOezLUXqpgXh/x1Eja0sKzBCe1WMC36QL6W4t+J1sTJ21Dcu1YxIGejhVaG1eaqCQpZ0nq4RbxNMpjdoroe152TUNOEL1Q31Kt8W+GmXON8LY8vLJfrQdvLcRwjYEB6PKSE/rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rzGW70A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rzGW70A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12525C4CEEA;
	Mon, 23 Jun 2025 21:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715934;
	bh=6d9nqRmmeLYcB2IeuOhhPghpWSZVOWGHtoSZmL+xDBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rzGW70Ad/3e1GZyd1sRLBWwPof0EL8i94uq/EHBddtZRrSJz8hJ+tWtc/YjSb9Ec
	 TOa0DbIKAb4kuje39RAW8yEMqPoKknOl7cbf9hNkHXmNmQaJvSovazAdEho+F+0YB6
	 sILIjQdrkeapqmLWBdrbqvl5l8H17+cJqCksqsPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/414] tcp: always seek for minimal rtt in tcp_rcv_rtt_update()
Date: Mon, 23 Jun 2025 15:05:54 +0200
Message-ID: <20250623130647.441060691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b879dcb1aeeca278eacaac0b1e2425b1c7599f9f ]

tcp_rcv_rtt_update() goal is to maintain an estimation of the RTT
in tp->rcv_rtt_est.rtt_us, used by tcp_rcv_space_adjust()

When TCP TS are enabled, tcp_rcv_rtt_update() is using
EWMA to smooth the samples.

Change this to immediately latch the incoming value if it
is lower than tp->rcv_rtt_est.rtt_us, so that tcp_rcv_space_adjust()
does not overshoot tp->rcvq_space.space and sk->sk_rcvbuf.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d29219e067b7f..cf4fef18a9cad 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -665,10 +665,12 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
  */
 static void tcp_rcv_rtt_update(struct tcp_sock *tp, u32 sample, int win_dep)
 {
-	u32 new_sample = tp->rcv_rtt_est.rtt_us;
-	long m = sample;
+	u32 new_sample, old_sample = tp->rcv_rtt_est.rtt_us;
+	long m = sample << 3;
 
-	if (new_sample != 0) {
+	if (old_sample == 0 || m < old_sample) {
+		new_sample = m;
+	} else {
 		/* If we sample in larger samples in the non-timestamp
 		 * case, we could grossly overestimate the RTT especially
 		 * with chatty applications or bulk transfer apps which
@@ -679,17 +681,9 @@ static void tcp_rcv_rtt_update(struct tcp_sock *tp, u32 sample, int win_dep)
 		 * else with timestamps disabled convergence takes too
 		 * long.
 		 */
-		if (!win_dep) {
-			m -= (new_sample >> 3);
-			new_sample += m;
-		} else {
-			m <<= 3;
-			if (m < new_sample)
-				new_sample = m;
-		}
-	} else {
-		/* No previous measure. */
-		new_sample = m << 3;
+		if (win_dep)
+			return;
+		new_sample = old_sample - (old_sample >> 3) + sample;
 	}
 
 	tp->rcv_rtt_est.rtt_us = new_sample;
-- 
2.39.5



