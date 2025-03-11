Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4D614BF89;
	Tue, 11 Mar 2025 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707210; cv=none; b=ual348BR6UklR7zO6NwbXiDeTjPykPFfkSnoG4JzA0XaoogP5Y9OAHjrRfu1oKVOcyux1m/Isc9wf4bQ9fXqJHr+8sJClRXNM4fZ+NMypvuIekzqfmfoiidTfly2LBSu+cMvrleufpUcrP44oAVF/XY90UrmeHg40pd6EHhabEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707210; c=relaxed/simple;
	bh=6IrJRoj46zAbOk88yTfLdQpGlJyXoniUg9GMywWzW5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRbIUxOBhpORaj71pbPZtwHpNRSIjEMzYTfG4/zj3ANh7eENltAFpJqIT+N5MbFeXd7U3D31Ax1tD8nVvVa1/cP5Ney28DkiNFuvTx0xE6hKLjFSB5wggWUgIKwNTXqLhCGqw3PesVo8N7k2WXXhV+AJTa9oqnBwkirz77d8/mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nm7yZjmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nm7yZjmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F33C4CEE9;
	Tue, 11 Mar 2025 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707210;
	bh=6IrJRoj46zAbOk88yTfLdQpGlJyXoniUg9GMywWzW5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nm7yZjmFrLfCWmVOlLdLlhhxTazUDzdNlHi7h9rmRwIkRTpsYzsbjVMp3phH6cRKh
	 55VkqF6kxm+BNMwFjgSHttguNMHZpYyRoZwD0Swv9jJjwzl1Ux6/ZimYkk53mDaxzY
	 fMl1+vuHVTNv5jD0qlPJLCERU0Gbreywd5hz9Bhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/462] ipv4: use RCU protection in rt_is_expired()
Date: Tue, 11 Mar 2025 15:59:07 +0100
Message-ID: <20250311145809.475251883@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c34386a9d99b4..a2a7f2597e201 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -423,7 +423,13 @@ static inline int ip_rt_proc_init(void)
 
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



