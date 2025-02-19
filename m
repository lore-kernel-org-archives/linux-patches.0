Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521981DFDB3;
	Wed, 19 Feb 2025 08:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954487; cv=none; b=WpzaT5SZ6yZo89hm8weMhvR2WWptQSdkaJS1zCSdQ5ZjxpD2Bys+1sdeHGM6YYanC7TrDtpGbkoHiuDTaP8uB/NaGpLkF8d+tPaQmIcmu1tUinp+z8mAcyoUzvS7MuEwWdDTvpusGmLbc3ZVkCg0qgrOyczXZ3B2Tv5PWGpsZYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954487; c=relaxed/simple;
	bh=Scs4kuHz2GWOJDQ3IcE855t/HIrFjg2btZcPng4TS0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhObaHEeh4TKbb0E2BGF07/6d+b3UxxqcU2qhgbRQy8XWdlL12kic719bGMrDmDawgQ5ffrn0wJ36nh2Zd6FWeVLBpcW3rFNZFCCa3io5toxev6D0wI/7KyqP3Md6NhFFv1W1yZqB5AN7UEuRS++CyfU5mGs228HLfLeDbiPikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjmmjZ+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjmmjZ+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2822C4CED1;
	Wed, 19 Feb 2025 08:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954487;
	bh=Scs4kuHz2GWOJDQ3IcE855t/HIrFjg2btZcPng4TS0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjmmjZ+NZdj/xIjALced27q+vkzAczfNVl47i5Dr8HhOleaZI/cyhkjGMqIK1pYCt
	 0E+dXK7Of8XK5sLl+caBdlqGkJ5nqfL6cffF8kcZubkTeA1vkCd2eZm9k1Qs1aVuyE
	 QszrAnVftYAjJoh2K7LstFlVFglK8kZHrjnCWq+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 218/274] ipv4: use RCU protection in rt_is_expired()
Date: Wed, 19 Feb 2025 09:27:52 +0100
Message-ID: <20250219082618.109285092@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dd205fcc33d92d54eee4d7f21bb073af9bd5ce2b ]

rt_is_expired() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: e84f84f27647 ("netns: place rt_genid into struct net")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 829c8d41aaae2..152697459e918 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -390,7 +390,13 @@ static inline int ip_rt_proc_init(void)
 
 static inline bool rt_is_expired(const struct rtable *rth)
 {
-	return rth->rt_genid != rt_genid_ipv4(dev_net(rth->dst.dev));
+	bool res;
+
+	rcu_read_lock();
+	res = rth->rt_genid != rt_genid_ipv4(dev_net_rcu(rth->dst.dev));
+	rcu_read_unlock();
+
+	return res;
 }
 
 void rt_cache_flush(struct net *net)
-- 
2.39.5



