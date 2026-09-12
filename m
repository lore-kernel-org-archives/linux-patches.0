Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F76242D65;
	Sat, 12 Sep 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212343; cv=none; b=XqDiLupP58rPWB4XGbTbE3e1GJ7kI6O7uc4z31x8NLKTI3hX97/g4q3fWO9944AwtgpYEtcJrRgcnhlKna2bTHRBHQGFSGJtOlTX8TWluwlO+aYP8C1rhDJU5TEa5/wtHm0ZZMa+3zP5Vy2p8ZadG4/XRyv0lkaR/kTNMbd1FRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212343; c=relaxed/simple;
	bh=nq8QxZvrMbm7dhYNc4DL9QmE/WTehNbZGxi3fjz6+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0JDl5Cge1gUaY8J2pq9Ca4u8zwYe9+FbGtn5oITIEAC4vjKhmeV9dsJhKXPtxYPgHSFsCpn63rgIHM6EakJP19ZWCegR5C4daHet0CyDAy+ZQDQQMB/P6iIa8E8JPuY70n6ukPO2CS1Wsp+lHj0eia4qeIefOlwAgpZeRy8wto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOiOueT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOiOueT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FB31F000FF;
	Sat, 12 Sep 2026 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212341;
	bh=xHs9b4UKt9ejY74KupHD9zdYAnpm39Ve0JNIRFHU0qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOiOueT+1M2fEW1S2gNpkODULOwMyD55MKWE/AHqY3qOA5NfVc9q0Tn1Iv9hE9bQI
	 e9Ns4VMWSKXmcT6LRMkcoZalGxH2H3JT0CMMPSmaqWTLO+v7JU3zXx/8uYlrW27pNl
	 FzmsLGUmRd/pRSN1J32ZvKLdZKllERiXltsQGVJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1380/1518] net_sched: sch_fq: fix pacing delay underflow with pacing offload
Date: Sat, 12 Sep 2026 08:59:09 +0200
Message-ID: <20260912065654.761783436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 137b8ae233cabe7fc77cce86f5ba33bf1b369e26 ]

When pacing offload is enabled (q->offload_horizon > 0),
FQ can dequeue packets early (now < f->time_next_packet).

In this case, the drift calculation (now - f->time_next_packet)
underflows to a large unsigned value.

min(len/2, now - f->time_next_packet) then evaluates to len/2,
incorrectly halving the pacing delay for the next packet.

Fix this by only applying drift compensation if now > f->time_next_packet.

This bug was triggered when flow_max_rate was set on the qdisc
or for non EDT packets (packets with a zero skb->tstamp).

Fixes: f26080d47007 ("net_sched: sch_fq: add the ability to offload pacing")
Reported-by: Willem de Bruijn <willemb@google.com>
Closes: https://lore.kernel.org/netdev/CANn89iK6O7ujR9zCJzd04MNLQoDi3mA+HWsR-hgQWYzLS3gZfw@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260820120706.1995449-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 5e41930079948..2736d98b978dd 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -771,8 +771,12 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 		 * f->time_next_packet was set when prior packet was sent,
 		 * and current time (@now) can be too late by tens of us.
 		 */
-		if (f->time_next_packet)
-			len -= min(len/2, now - f->time_next_packet);
+		if (f->time_next_packet) {
+			s64 drift = now - f->time_next_packet;
+
+			if (drift > 0)
+				len -= min_t(u64, len / 2, drift);
+		}
 		f->time_next_packet = now + len;
 	}
 out:
-- 
2.53.0



