Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B99947A0C2;
	Mon, 20 Apr 2026 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691854; cv=none; b=hSxtA6imS1Mx6amtcYrQaTpNaMyTO3fVWz6L40gRm6de5FOL8FdQ1cbfhusoQtuVHWRoNFZJWZKMfxISISP2HPRSBJT5GwSaiIqHwT6CPiBgbhOff7tScjphV1J/ZisHIBoniBx5vFh1XhvMmCgOjPVCVwK0zDMREYK+E9rCdn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691854; c=relaxed/simple;
	bh=i3z/MH0IEZxhDzM54gF7iCei9vLPN0gkXIOAbBTs7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcJNwqS1aAjOO/VqfZv3xplGJcAKqxtGX0MIiP7VaGLm5lYTrPuW3Xv6uCZcqVyX2nAIUmf+wSqIytgVTcMlncNzMFjtxHKt2QAplwmVZrYGtQ3e9Qtiby47XORkdM3/Nk/nb3SOxrMNQjdcqKOl+mzO3Zl5KWRFlYwYb+KNIDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K00IvnKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K00IvnKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484DDC2BCB7;
	Mon, 20 Apr 2026 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691854;
	bh=i3z/MH0IEZxhDzM54gF7iCei9vLPN0gkXIOAbBTs7L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K00IvnKmjKxahsf49A58osImBuEd4CO6MvFUOSpbyVg6KHQhP++ZoYyrNKxmtuaf1
	 f8naxo3cIEDeR6taIplCE8hkpfro/tOB00+WDgPJ3okVBqa7eLjDdOO4insfrespSn
	 REGygjdupZTUxZyDJjKngdpxmH1CzNDgyO3DdfbUyhuy5BbxxLRd5u5qgQFr+ClBPp
	 WCRcKeae5Y24kXyJn87D3TaQkS8gRArNyS4XUYFrp5t7dAlmNYDOb9M0jD8zfCx6hS
	 KFxyDKi/gB/xYp63id9U2iR4SSHvoKDtiOhLYXkwSzptwHKa8Qnd9sGjm/KNcZESSc
	 O81l2t8wkCCDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	jannh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] eventpoll: defer struct eventpoll free to RCU grace period
Date: Mon, 20 Apr 2026 09:20:27 -0400
Message-ID: <20260420132314.1023554-233-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 07712db80857d5d09ae08f3df85a708ecfc3b61f ]

In certain situations, ep_free() in eventpoll.c will kfree the epi->ep
eventpoll struct while it still being used by another concurrent thread.
Defer the kfree() to an RCU callback to prevent UAF.

Fixes: f2e467a48287 ("eventpoll: Fix semi-unbounded recursion")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 fs/eventpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bcc7dcbefc419..a8e30414d996c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -226,6 +226,9 @@ struct eventpoll {
 	 */
 	refcount_t refcount;
 
+	/* used to defer freeing past ep_get_upwards_depth_proc() RCU walk */
+	struct rcu_head rcu;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -819,7 +822,8 @@ static void ep_free(struct eventpoll *ep)
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
 	wakeup_source_unregister(ep->ws);
-	kfree(ep);
+	/* ep_get_upwards_depth_proc() may still hold epi->ep under RCU */
+	kfree_rcu(ep, rcu);
 }
 
 /*
-- 
2.53.0

