Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3751433F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301112; cv=none; b=K1uk1DISdjZNe+cAK9URoi6rtrdv0yJ0qmse+w7uHBfoNeXHcJCvH+s44OeJJim9fAQvLfxYwjUkWbeyF7JX0FJ+XZckDAZnUlwPeLO17/AYYaX4kwHdVx/BXPmjh7Qt/QJBa0ici4nKGdXJ1tr8QXVBfH/rbfsy4W3sLX0x30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301112; c=relaxed/simple;
	bh=fT5XQ90LQsVw7mKPiPlUtlk1NvZ5frplEmUQTEt3UJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaPz89DJw42s27vONAGMhPyD4rjLQob1/btEQ7Z/EsY5ViBNsIihXD35k+zbikTXEv+gnFCe7x3l6CXsrlh/MiRl8ITsYeb6+y48wVV9h1xUGv3XZ1nC15TMBUmhZse0Zj6W5pqI4h4eAa2nfg083i1nJstrAkm6WUATAKHcYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJeXGiL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJeXGiL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DD8C19425;
	Sat, 28 Feb 2026 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301112;
	bh=fT5XQ90LQsVw7mKPiPlUtlk1NvZ5frplEmUQTEt3UJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJeXGiL+S1zPAQ7B9WWhAyUSFSPNW4Nkl9vIixCSDz9iuLuEAJ5WQoclBqkz5nR1e
	 oeIJ5g2KaYPCpGgcoKCrbI3m22oUAkt+7v5pJkveYhblUAlnH8h4MJJ3NP9OT/q4PL
	 PmLeAFk7DpS12fQ4hwhdjDyaWsg7t89FcXx8hEBRMgEqQOzR7Aj/KIY9F0WS9OR0/n
	 orZ25URUw86/RWFkspT8g+VZ2hcgpPpnZeiFjhZavLjTtqrMWnc3pPozF1zo+5OnG6
	 9JMT86bSb4yoD4mj8mhyF64wS7IwgjufzKyYw3JAr89Tnv0uh4irKzn44ixHxbKjPh
	 lBOiJKthsT09w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/752] ipv4: igmp: annotate data-races around idev->mr_maxdelay
Date: Sat, 28 Feb 2026 12:39:38 -0500
Message-ID: <20260228174750.1542406-267-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e4faaf65a75f650ac4366ddff5dabb826029ca5a ]

idev->mr_maxdelay is read and written locklessly,
add READ_ONCE()/WRITE_ONCE() annotations.

While we are at it, make this field an u32.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260122172247.2429403-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h | 2 +-
 net/ipv4/igmp.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 5730ba6b1cfaf..dccbeb25f7014 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -38,11 +38,11 @@ struct in_device {
 	struct ip_mc_list	*mc_tomb;
 	unsigned long		mr_v1_seen;
 	unsigned long		mr_v2_seen;
-	unsigned long		mr_maxdelay;
 	unsigned long		mr_qi;		/* Query Interval */
 	unsigned long		mr_qri;		/* Query Response Interval */
 	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
+	u32			mr_maxdelay;
 	u32			mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
 	struct timer_list	mr_ifc_timer;	/* interface change timer */
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7182f1419c2a4..0adc993c211d7 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -227,7 +227,7 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 
 static void igmp_gq_start_timer(struct in_device *in_dev)
 {
-	int tv = get_random_u32_below(in_dev->mr_maxdelay);
+	int tv = get_random_u32_below(READ_ONCE(in_dev->mr_maxdelay));
 	unsigned long exp = jiffies + tv + 2;
 
 	if (in_dev->mr_gq_running &&
@@ -1009,7 +1009,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		max_delay = IGMPV3_MRC(ih3->code)*(HZ/IGMP_TIMER_SCALE);
 		if (!max_delay)
 			max_delay = 1;	/* can't mod w/ 0 */
-		in_dev->mr_maxdelay = max_delay;
+		WRITE_ONCE(in_dev->mr_maxdelay, max_delay);
 
 		/* RFC3376, 4.1.6. QRV and 4.1.7. QQIC, when the most recently
 		 * received value was zero, use the default or statically
-- 
2.51.0

