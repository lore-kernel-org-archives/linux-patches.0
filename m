Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DBB197A91;
	Thu,  6 Jun 2024 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683297; cv=none; b=To1xmoM47m5EaQFnQvOgoMfELDcrPuvTwYiLspp8xbzkKGwWrZzNVzf6J+o0rktcieWHFgUEhKiJNAfcmTU2/93d+vWkvCEXvThkQhvLlZ9I0Lp3XPQOxLCb7mJUgfbBBpr/rGbAQw7+rL326VX6Jqr54d9/21+m2pFMElj+cNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683297; c=relaxed/simple;
	bh=biQkYOL6sgcE3+LFYr0KE87xvThIfthZ/ZtsvoaJT0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVn2zlC+5TWPwimYckoFvvlKe7RAyNWjbxo0pMlEjc9NHEOuz1oNOphI4+tPpwOm+nmZH7psS4dXNeyNdMqycQ+hHlUjfB8TnlrKxgo/1+6lhlRV4yUKzTo/DrIM+zZGziQsJa5wvrmDbgn526/GfRLx8WmzohyDoKLke/frVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZ6/odn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZ6/odn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A46C2BD10;
	Thu,  6 Jun 2024 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683296;
	bh=biQkYOL6sgcE3+LFYr0KE87xvThIfthZ/ZtsvoaJT0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ6/odn1CXFMcsUTpraQLquszkjaqUvc4oHfvQfeEOMz0yB+aNQRwECWsnWxGyiOX
	 wodlJhtO2pIxQ7wWqySd3snAVD25DTkdlKH/aePV/8zXsNNyiDT6pvllNQMLypXUnt
	 GkT1agkFm0fCrBLa+9W622oB1TypuXoRsmLt/eBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/744] net: give more chances to rcu in netdev_wait_allrefs_any()
Date: Thu,  6 Jun 2024 15:58:00 +0200
Message-ID: <20240606131739.071762486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd42ba1c8ac9deb9032add6adf491110e7442040 ]

This came while reviewing commit c4e86b4363ac ("net: add two more
call_rcu_hurry()").

Paolo asked if adding one synchronize_rcu() would help.

While synchronize_rcu() does not help, making sure to call
rcu_barrier() before msleep(wait) is definitely helping
to make sure lazy call_rcu() are completed.

Instead of waiting ~100 seconds in my tests, the ref_tracker
splats occurs one time only, and netdev_wait_allrefs_any()
latency is reduced to the strict minimum.

Ideally we should audit our call_rcu() users to make sure
no refcount (or cascading call_rcu()) is held too long,
because rcu_barrier() is quite expensive.

Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/28bbf698-befb-42f6-b561-851c67f464aa@kernel.org/T/#m76d73ed6b03cd930778ac4d20a777f22a08d6824
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f6c8945f2eca..5a5bd339f11eb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10430,8 +10430,9 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 			rebroadcast_time = jiffies;
 		}
 
+		rcu_barrier();
+
 		if (!wait) {
-			rcu_barrier();
 			wait = WAIT_REFS_MIN_MSECS;
 		} else {
 			msleep(wait);
-- 
2.43.0



