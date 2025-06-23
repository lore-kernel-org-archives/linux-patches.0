Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19079250C06;
	Mon, 23 Jun 2025 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686213; cv=none; b=DieozVAnK3RjOA8UHnFadqnqjFtpppiUADiMo3yaChNTFWabs2GlrvJ71lFd4DCX/2ma9yW0bmSDovxdlJydIJDbSFWM6WR1VNBdT3ZBVDWdzmTK1CdUb+RzW5KJh6zVFyfQh86g9ucFG4dqd95D0j8z+Et6BPYaJ7V62bh/Yy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686213; c=relaxed/simple;
	bh=zYAjwshePavOLH3WNWgqmUnOH/FRWT8ItNO9LFA2yAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RenEcdXOKGP7ZapJJFXFCWK0nvy2oeXxzZ2kEEtI2bdw7WP7CB6wYdOj4h6ZYqDNY6jUP+LxYN2KFdUzGDFlGMbF/dLOs/hNmk+KpYnuF8ientG66AYDjdOferN60a7OmDOJMIlaZ70IJ+hiSz2oylpuoMi3eILB9Q6Ll5AzxLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa8ngsZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa8ngsZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCE5C4CEEA;
	Mon, 23 Jun 2025 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686213;
	bh=zYAjwshePavOLH3WNWgqmUnOH/FRWT8ItNO9LFA2yAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa8ngsZev5B7ynD6U2qF86uuasMaLtJ55G8yP7zZaAR07xQYbCkRwVctEhWsgKDeg
	 qsPn8NLRRKvR7O3zv/bs4TQj3tJZMUhFT3WDN0vRWt6k7y6uCOMJIKoDjP4t3uP2eD
	 KR9cPXzBY1cMCo+nzVXcJgrktZ911atsplOXQXXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/222] tcp: always seek for minimal rtt in tcp_rcv_rtt_update()
Date: Mon, 23 Jun 2025 15:08:19 +0200
Message-ID: <20250623130617.011527020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5923261312912..d07aa23943c13 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -539,10 +539,12 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
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
@@ -553,17 +555,9 @@ static void tcp_rcv_rtt_update(struct tcp_sock *tp, u32 sample, int win_dep)
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



