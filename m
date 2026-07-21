Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010AD3E008A;
	Tue, 21 Jul 2026 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653868; cv=none; b=uB9V3XbxyEin8+V5ecxgPX5hKVl3ylE2arT20Cw9PFeBnjXZWeCV0A5qBXxiZmmHDr8If9FXB/DwcVmuNzZmwyUva1OXtFpEu4BvFSTNIrDNkB2S5r02kC8jTqSz6pXn3bOCmvkQm7pkOPkw9cPI0Fjpin6Uk1+r9Ne6Z1tO1p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653868; c=relaxed/simple;
	bh=y3nUgIGy5iIoBHtIIZHKwBjk4n9BouglM+EtfXOyxIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTqgTr8SLHt/eKPohPaiqcMmjRf64gF1UjAHPr+oMup7ra+IaBPW7hoDGm49/SJQrB/UwYznDsn+4wdHa2EiBOyuNQpY+I73WVV2HEOop+9DihszuDApPuwUuwClNRdiO2UQpQFMpHhzvW4w4WGH2vDj165ufvYVwUsSZAMVZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIwG/1oX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIwG/1oX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686A61F000E9;
	Tue, 21 Jul 2026 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653866;
	bh=g9jCb6oMAeIOyUYvkhTjPHlEvYT2NA0Zhx1btC1b878=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIwG/1oXa1cIV4hgYAMDbrBmRwxY7UXf6pbNfy2OKUnV74HW4QSctc4cEiUVItwTC
	 CaYiqpQrx/Mp7D4lhDEIzxA4yv5y0yXE8dO+3FIz9ZpUzTnxp4mU1y3umVHwfv7sX4
	 gL5RzfG9abBM7DtjF3oXIuxwpGAK4fQrztlS0x4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1490/2077] ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()
Date: Tue, 21 Jul 2026 17:19:23 +0200
Message-ID: <20260721152627.939381107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 208328e337c27a..f22fbc17f15b30 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -217,13 +217,18 @@ static void ip_sf_list_clear_all(struct ip_sf_list *psf)
 
 static void igmp_stop_timer(struct ip_mc_list *im)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	if (timer_delete(&im->timer))
-		refcount_dec(&im->refcnt);
+		put = true;
 	WRITE_ONCE(im->tm_running, 0);
 	WRITE_ONCE(im->reporter, 0);
 	im->unsolicit_count = 0;
 	spin_unlock_bh(&im->lock);
+
+	if (put)
+		ip_ma_put(im);
 }
 
 /* It must be called with locked im->lock */
@@ -266,6 +271,8 @@ static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 
 static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	im->unsolicit_count = 0;
 	if (timer_delete(&im->timer)) {
@@ -275,10 +282,13 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
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



