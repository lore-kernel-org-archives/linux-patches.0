Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215481;
	b=Y0xclSfRnLF7M/tV6Imad3qqSopmWpK2WPD48cId/uxvgZgTthuiZBhRhtcgYgDC1XGE
	 dSAv1Pn1DVjUHyBg/R3hJMDL92LV5cwl8SZ+ulbA0Di5B/LocZ4hz3CdQpEbXDjhSVOJw
	 qW493CsL3dBAZtC3bXiN2hg6T9SgS1WyLhPl7sYhHPrCiNSkUkZHOctIyHbQHP1so1Mik
	 C4tbw0VSnJ3gpPgP/chq/H/tg2Hvj+5uFRh+UPMfIMM1sbtKTVEzeyYI+YNbAzWcYXnW+
	 Z2sR9UyXMPJNaG1RDjwKKyGR0Iwhvm+IMeYmNJIXdhVeZQmTp56i8OhMNyLoKh3dneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+DJsGyDxK2bHMFbGCOgZ7aHK9kUUopU24SBPe+Oc1kg=;
	b=YtUrMcOysPzXGC/ZufMvLnmVPP9mKhIe7cgdIxvLva2eP0P1beUXDccfbwGlqET24djZ
	 QS/XF0UuAu7q50bZi35kO4C5++BZrQqQ3rbUnkhnc5f2rjp7gYrESWlfBVMwOM4GH1bKh
	 xOmutc1hViwSwsFqSRgZVqDLUiIIhl3cwcHUMbUehgLCDGxkVG6WfE05ojD46YgsCrkF7
	 6AGFMcknmmkNhd3qC41FMR1TZtHAjueQQYLKBq7Y7RqYGXnKtxt4Wvq9zKMt5k3uIm4Cm
	 VNJmivQjeVwM477DsQBNzBvS5YI0K/giKOlMUvGjvk/QInrD47u/mFYNStdviMhyLeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CJBlyS7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236DE606A31C;
	Wed, 28 Oct 2026 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJBlyS7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E701F01825;
	Wed, 28 Oct 2026 19:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215480;
	bh=+DJsGyDxK2bHMFbGCOgZ7aHK9kUUopU24SBPe+Oc1kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJBlyS7/r1luTl5DEzFkaNEsvuF2OM3Cr2t0RVjXVaDPaR8G5VzOoK8PsKL2TrQqv
	 OFYt4Y0a4tJsX/tCkjORYy1Ecz0zTNRPZUm8rVBJBwR07hNAjB9D1hXsLNg9rpptRq
	 FXtUsJxyVyqpWqjqZIoGfbhCKF4PjFho1jjAJCPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1223/1887] ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()
Date: Wed, 28 Oct 2026 17:55:19 +0100
Message-ID: <20261028170527.255877017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3546deaa0c30a14c7cdb5dc8f2432cb428f0cd36 ]

When a timer is deleted and not re-armed in igmp_mod_timer(), or stopped
in igmp_stop_timer(), the code currently decrements the reference counter
of the multicast list entry @im using refcount_dec(&im->refcnt).

However, both functions can be called from the RCU reader path:
- igmp_mod_timer() via igmp_heard_query() -> for_each_pmc_rcu()
- igmp_stop_timer() via igmp_rcv() -> igmp_heard_report()

If the group im was concurrently removed from the list by ip_mc_dec_group(),
its reference count might have already been decremented to 1.

In this case, timer_delete() succeeds, and refcount_dec() decrements
the refcount from 1 to 0. Since refcount_dec() does not free the object
when it hits 0 (unlike ip_ma_put()), the im structure is leaked.

Fix this by using ip_ma_put(im) instead of refcount_dec(&im->refcnt),
and deferring the put until after the spinlock is released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260705181756.963063-4-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1b8adf5fbf8a4..f2c4dc7e24ea6 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -201,13 +201,18 @@ static void ip_sf_list_clear_all(struct ip_sf_list *psf)
 
 static void igmp_stop_timer(struct ip_mc_list *im)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	if (del_timer(&im->timer))
-		refcount_dec(&im->refcnt);
+		put = true;
 	im->tm_running = 0;
 	im->reporter = 0;
 	im->unsolicit_count = 0;
 	spin_unlock_bh(&im->lock);
+
+	if (put)
+		ip_ma_put(im);
 }
 
 /* It must be called with locked im->lock */
@@ -250,6 +255,8 @@ static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 
 static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	im->unsolicit_count = 0;
 	if (del_timer(&im->timer)) {
@@ -259,10 +266,13 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 			spin_unlock_bh(&im->lock);
 			return;
 		}
-		refcount_dec(&im->refcnt);
+		put = true;
 	}
 	igmp_start_timer(im, max_delay);
 	spin_unlock_bh(&im->lock);
+
+	if (put)
+		ip_ma_put(im);
 }
 
 
-- 
2.53.0



