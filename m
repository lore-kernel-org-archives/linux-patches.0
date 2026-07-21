Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F4471271;
	Tue, 21 Jul 2026 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658262; cv=none; b=JVRIwvRHzHwtG0AJZ+LKDpuRmMjttEUA8bC5lElWoQ1Vj2+nf0JCM1iiOCZKwtRBaYUce5NSm0YdTFVRIY8AWsLXxO8bkcoKcdNJEaW8x2hxavGtqfFhxeRtt1+BXHjU5Cs7nhDWFVUXCXpJC0bAT1zXBU9xEHJczXXvC578vQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658262; c=relaxed/simple;
	bh=VUg6M9nohkWvjEK4UWze5M8KOuC4lAxEvbV6ASWn3g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTV5QxP8yhiRIi87hoouxFJff+dVn8kwRNzzvXfsTixODMnBMaA5Ptim67gGkN2GI7ra5110UjZ8nGOWXN1nyjJhUXkdA+YgmzzVTMHfB6DuvyR9yNim3tDZlWsYilr45F+8cuUyakVgecikYl27wl8a0Aocidi4rbVyb8L+t9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqkJsPSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqkJsPSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0F51F00A3A;
	Tue, 21 Jul 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658261;
	bh=0nTZYlLFzYF6dVESrju6ebX8j/aKgOZ//toojgGqJbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqkJsPSXru7Wiz2xjhYoLleycZ6fzmJpxNfTEcO5Rfu0f4Mk/dnSUXhA1oeC3mtcR
	 hBBQmFz8vfqa+LqhXFLZLZZ4b6eCEZ9CCdZq7ivmj6I/8QoqQzYBDoW6eF957xol//
	 bRKibRN5D42yAJWG9iGJp+/7/wbksMv9vmEZtqUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1078/1611] ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152539.658037574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d8993d8285a546..aca035eb58929a 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -204,13 +204,18 @@ static void ip_sf_list_clear_all(struct ip_sf_list *psf)
 
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
@@ -253,6 +258,8 @@ static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 
 static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	im->unsolicit_count = 0;
 	if (timer_delete(&im->timer)) {
@@ -262,10 +269,13 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
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



