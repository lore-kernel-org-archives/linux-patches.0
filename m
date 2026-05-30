Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1A432ED24;
	Sat, 30 May 2026 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158343; cv=none; b=qWHYo2m/V+R2ewLznteHVqDIMEBCOWTskwzH8LpB9W1JgDRogTrcNrtEKSxegLIrktHmkJo4TK6P7N610DPaA+fSzd2GUcbIBm4XXHN/plZPzS5CFyTOCI44vw/GD4ZcBFyUIeIruf+en6+sZ2DlLEdBPWzfL4UiZrnfSaKL9ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158343; c=relaxed/simple;
	bh=6uRRNmdHUp9ynxxHUZWz7vvENTqbTt4ZQJyPwHDzB1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alFSOPGMBpYYH+Yby33kP7ZyzZQKJ74jR5uMj2O8aZdg+pwE5oca3VURkaDEUO2WuBNTqdNgKJO+OsXg4kePHN2er2SZgyQA8dbGXHDWEvKNqQWxYMwXvOR2pZRj930CANDk9MVS4HojL4RtJMyfUJIASX/DyGr1luqdnNXuTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBDbLhoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBDbLhoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B681F00893;
	Sat, 30 May 2026 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158342;
	bh=Bil/9ydlQaIUJxlTVqPH617sOXAaBH0NU4p85zB4oiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBDbLhoVpKvJC0t+YY3zo+5mbvGd4eGI2GY/ikCBURzYFSiz/f+jzk/gvyjZJtG7I
	 bve/ZXZvhiAJvo7LvmxlmOjbK2LapWMz5HEmazHCw5T4jm1WYzrZxEApPNxwR6MCwF
	 EylqGS/+8EWrRei3UXOsVJxUJHWpR+x2d+izJTbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/969] xfrm: Wait for RCU readers during policy netns exit
Date: Sat, 30 May 2026 17:52:46 +0200
Message-ID: <20260530160301.579066204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]

xfrm_policy_fini() frees the policy_bydst hash tables after flushing the
policy work items and deleting all policies, but it does not wait for
concurrent RCU readers to leave their read-side critical sections first.

The policy_bydst tables are published via rcu_assign_pointer() and are
looked up through rcu_dereference_check(), so netns teardown must also
wait for an RCU grace period before freeing the table memory.

Fix this by adding synchronize_rcu() before freeing the policy hash tables.

Fixes: e1e551bc5630 ("xfrm: policy: prepare policy_bydst hash for rcu lookups")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index cd534803a0e42..7b9151f4eccfd 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4129,6 +4129,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0



