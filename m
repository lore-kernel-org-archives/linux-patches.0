Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151CC23E356;
	Fri, 24 Apr 2026 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037696; cv=none; b=MAGMXmqIlX6I214ksy3k9oULN+JORPdujrHDW5/cMoRk6Q1uayEW21KCg7hEJ3fEXNXXJll+8SJXsSVK79U1Rdr1pyx9Z+ieOPi/iDUO39JcYbIDUnYTmhbyZm6RnuqCQgPE24271BH667WmidzEjguxz9m9I1HFUbcd2uaG8Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037696; c=relaxed/simple;
	bh=hvjlMy2JjCeUU1xdRHlzETffCT1RlhSUK4lPRNKKYMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjyQ1latT5WUu2vqO4fgBpiA12lg/NW3QPJJFeJSgEb3NgNWQTwO2/M8dzg/KScm+OFESlzzsdZoLLLmvSQgA62oLF+4YSBAybgmBwxxWutyP6wveeqfWZuPVwdX33ftaX3g0NjtiBBbU3YHzlPcJHt+IqewLGkhmrOR7ZgN7i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES+GQthz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES+GQthz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5DDC19425;
	Fri, 24 Apr 2026 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037696;
	bh=hvjlMy2JjCeUU1xdRHlzETffCT1RlhSUK4lPRNKKYMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES+GQthzadjARDHMSesIejOFUlwLAcTZ1Nq/QIMm2Pal++v7POD5z2qTpZBtQhKe6
	 5Bf6OrUePf7deqbVbhIpoIiDysIS3pAmX8Dw4lQOINMwoqoPq7sEAnWNf8mak42912
	 eAGrkyDjQRf47w4mkgyiLhQiOXuUz6veccFDI1/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/166] eventpoll: defer struct eventpoll free to RCU grace period
Date: Fri, 24 Apr 2026 15:29:08 +0200
Message-ID: <20260424132540.026264110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/eventpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 3c6c646fb3c49..8a556560a5b2f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -225,6 +225,9 @@ struct eventpoll {
 	 */
 	refcount_t refcount;
 
+	/* used to defer freeing past ep_get_upwards_depth_proc() RCU walk */
+	struct rcu_head rcu;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -708,7 +711,8 @@ static void ep_free(struct eventpoll *ep)
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



