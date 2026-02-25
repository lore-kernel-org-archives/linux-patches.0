Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A103C2D7810;
	Wed, 25 Feb 2026 06:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002737; cv=none; b=UcLvctBFuO8/e7UbFlqWzMXPEWaYV6twbCOrqfg3FujLgCeNYNXQ86YwW4bTXkdHRt2nAiEghYviV4yaH6KgWPz9jlAv5GwromEBZEM3BMBx5MsR9JBoCdStF5W3TISa+hRYp/ly0jr9iSbw5Y9OrRuYH3TsaUS4lbm2lfvpPJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002737; c=relaxed/simple;
	bh=hdNXIHtPxc+CHzvcoHe7vGk3k7vsyQeXseGXe4e3W+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKsNq/iVE/WdInoVCU9RBF205pLjABy/HZNvOlr90wMvUMcrXsood4UAmwTErBaRCGqkLE0aZ9+5nU/J5ovVslW6E8oxkfegFPUC3u92HezRLLgIXXUqPZ1tcoeJWYOv99C9xu07SkS4DJ/qMSy/pN2Bp2DB/TVOFDfeNO7G0/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzP/GDY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzP/GDY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78875C116D0;
	Wed, 25 Feb 2026 06:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002737;
	bh=hdNXIHtPxc+CHzvcoHe7vGk3k7vsyQeXseGXe4e3W+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzP/GDY7b0FBVuwYxWO7pLWXgYjOMR4tk2QDQfXUJ7FfKm0cOPywYgL19Mu4uW85z
	 cfyWNJT8ot6I70B+mCHjkkYHGA+FnCPbfC68rkP1HvBqguBdTG8Qsk818hLsKoa45W
	 MI11UYq8zgOQGKjPVcsyVYl5UsuIZzsk5Noa/pGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 553/641] inet: move icmp_global_{credit,stamp} to a separate cache line
Date: Tue, 24 Feb 2026 17:24:39 -0800
Message-ID: <20260225012401.925629174@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

[ Upstream commit 87b08913a9ae82082e276d237ece08fc8ee24380 ]

icmp_global_credit was meant to be changed ~1000 times per second,
but if an admin sets net.ipv4.icmp_msgs_per_sec to a very high value,
icmp_global_credit changes can inflict false sharing to surrounding
fields that are read mostly.

Move icmp_global_credit and icmp_global_stamp to a separate
cacheline aligned group.

Fixes: b056b4cd9178 ("icmp: move icmp_global.credit and icmp_global.stamp to per netns storage")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260216142832.3834174-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 34eb3aecb3f21..62166da045548 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -87,6 +87,12 @@ struct netns_ipv4 {
 	int sysctl_tcp_rmem[3];
 	__cacheline_group_end(netns_ipv4_read_rx);
 
+	/* ICMP rate limiter hot cache line. */
+	__cacheline_group_begin_aligned(icmp);
+	atomic_t	icmp_global_credit;
+	u32		icmp_global_stamp;
+	__cacheline_group_end_aligned(icmp);
+
 	struct inet_timewait_death_row tcp_death_row;
 	struct udp_table *udp_table;
 
@@ -139,8 +145,7 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratemask;
 	int sysctl_icmp_msgs_per_sec;
 	int sysctl_icmp_msgs_burst;
-	atomic_t icmp_global_credit;
-	u32 icmp_global_stamp;
+
 	u32 ip_rt_min_pmtu;
 	int ip_rt_mtu_expires;
 	int ip_rt_min_advmss;
-- 
2.51.0



