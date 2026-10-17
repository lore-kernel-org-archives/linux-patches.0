Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB55A3A1A3F;
	Sat, 17 Oct 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259174; cv=none; b=tTA7Adz4V8zcXR6hubZspnqUXOdOOg90gVNH/NGsbAmg4e5HX9FSgzuhnCHCn2Wmd76huUGjzQYrOah0p4Q7DS28VGJm0XUrZIPfn6UDruZxvgELOQlU6Td9CYywRGn9cCrHk/L97+0CDTeXNu/X7CL2AD3vdKaI+ux2eGie3mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259174; c=relaxed/simple;
	bh=QWe1QRGzBCwodv8pHtOvm0+X2U0MJyoTkH4V4kFotzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brAA/iMkHkpu0fSTLT/4nN+nNr+iJt7q+lxveHGimplCDTI20ObxIc3OVS6qa0ikFIm2uX7Fph3uJVxaNkHFjUf2iUDUzFhbLYVQBzVtH3vjEhCEAz34T3aPQfctUU75R5wZ1Rj/90NlQS/Y+HxealSR+w6Dc18zMfqY6BiwXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAsswFPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAsswFPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196A51F000C5;
	Sat, 17 Oct 2026 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259173;
	bh=FLsyTEpdRvReZkZzUl5HDMVIeVWa14aVGHNqJtjUljk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAsswFPMhKcmHc0VFFCMK0yRn7WcgJwQu8OLpOJliTCthFgfSbW2NHM0KquYioBHJ
	 R+K989PUmgY5XEOEKGt/IvMRHRwuagt4mf9qd14c4x+mmBDG2h59A++u1vSrT6HFHi
	 pW/+Rw4ck+nEUYgqRNTbS1TdrUWWEw+tf1kltVEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1126/1674] ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()
Date: Sat, 17 Oct 2026 17:56:38 +0200
Message-ID: <20261017160500.063477309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 8509e94738344..75bb534c3f3ec 100644
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



