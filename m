Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B288626F46F;
	Wed, 25 Feb 2026 01:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983578; cv=none; b=XCMgjHJbw0hHjLZK+Kv6hf3wPIcf53GvxkoqewmmH/qpNEVrcHqqObCWGa//saBSOXsDcKImOEHdyTM6PzUi81nPFltIqWmfVhFt5hOqdggbxiFhEMXriGOk5B85gWXBHSiB6TBFNAlM5zTPTJxsK3KoPaF33WdgawPm8uDL5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983578; c=relaxed/simple;
	bh=6xPJx/2bjWdsQv+CRL94bbTMgmYSduqPVuxF39rX1yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGIeCn9u1qtGwZRFs1rjUQAZWRxv6ojpdv9n/ncVpXshBwjxI3y39KJXZDuScqHK/gC8wqZTSQOtTIH/gB1xdZH4v3RgA32LbkkP7taiRKXEG2JLGG3FXUL0WS2wNjBGpRS+PV6vjVfE9SejWZG5e8OZCY2nlirqT7dhtaiCQKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYIGUGCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYIGUGCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74675C116D0;
	Wed, 25 Feb 2026 01:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983578;
	bh=6xPJx/2bjWdsQv+CRL94bbTMgmYSduqPVuxF39rX1yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYIGUGCFBHyN8zoEaY0/5e92vpV2jpG3fy551PX+fyjc6OHz71leHBtJ6CHZtgMwD
	 J+CE4UfMNQqQAQXgmn2pvNh+K1s/evozBz/A4U4P4K59wankEtpI3ziScRvvqBCAFc
	 /paOprZJAJn/bNmNNpwLRlHYBtX6yWnnhqeSjkaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 679/781] inet: move icmp_global_{credit,stamp} to a separate cache line
Date: Tue, 24 Feb 2026 17:23:08 -0800
Message-ID: <20260225012416.432169765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2dbd46fc4734b..8e971c7bf1646 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -88,6 +88,12 @@ struct netns_ipv4 {
 	int sysctl_tcp_rcvbuf_low_rtt;
 	__cacheline_group_end(netns_ipv4_read_rx);
 
+	/* ICMP rate limiter hot cache line. */
+	__cacheline_group_begin_aligned(icmp);
+	atomic_t	icmp_global_credit;
+	u32		icmp_global_stamp;
+	__cacheline_group_end_aligned(icmp);
+
 	struct inet_timewait_death_row tcp_death_row;
 	struct udp_table *udp_table;
 
@@ -141,8 +147,7 @@ struct netns_ipv4 {
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



