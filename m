Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B73A9D84;
	Sat, 17 Oct 2026 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254516; cv=none; b=XYSdYBQS3LctrE29TucnDQWVtFGM+J7YYgE+10m8r0db41vZYYARZc+2mkZ39B2tv42sSAgfct8jzwEoezGmnXQWsUnzTf3eEF03giCtobTbHvorRl9bPkdDK8FjafcwE16TReH3cw7TxKVkJngDRC+Rn0AyXsPq6nB5D/09brM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254516; c=relaxed/simple;
	bh=+qP+OqLk7jUmJaEzZf3Hu47/H3ZZnYKnOzI2xxUwQ8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNdjL4NJsp9bWNLthCcPceUdrpARvGNVSRbR/CyTzJnjlDbAcONyWvdqk1eylaIY9ByFPyiVp3o3UDVRtrRcYM8/3R16Msm0JWr/veD/y9suPhhjD+sgitzBkUEqHSkFQNO94DRtZAlx3AF1UVS+q9qYG2N/dq5mIswPMW3/reg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bzyx+Pk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzyx+Pk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23241F000C4;
	Sat, 17 Oct 2026 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254513;
	bh=MrCLbNGAPSOw2ikRyiunq1QYjpkYf8i8R5HC79SEnm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bzyx+Pk1VxXxjnrfCc6qRSGYhRdJN7w0V/3wxRqtowbU0GfDvAG9Pt8ppwudf6+nQ
	 /KXftmKwc1F+wSjrVzdH5YWJeJomK4B6to2zktGPBvNiTSLWwTkKKrHj9U/le5T1//
	 lofsuy6KzeA95kXLev0cCxdNKrd/ktT2/4f5U5qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/869] ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()
Date: Sat, 17 Oct 2026 17:54:33 +0200
Message-ID: <20261017160048.217360440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f503d60a7dbe..e827537ec15b0 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -220,13 +220,18 @@ static void ip_sf_list_clear_all(struct ip_sf_list *psf)
 
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
@@ -269,6 +274,8 @@ static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 
 static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 {
+	bool put = false;
+
 	spin_lock_bh(&im->lock);
 	im->unsolicit_count = 0;
 	if (del_timer(&im->timer)) {
@@ -278,10 +285,13 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
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



