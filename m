Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048800;
	b=aAvMNGHIT8r2MWTg+s81YC3s5b3Oefr4d/b4ObKdar6sOuT1eMBy3xGS4PhXCdwovcP7
	 oqtrmtgLz3NIpgigLPM6M0UfGp+SvLVbX+5/qhpfuru5KsJhwL69zj77NmtnFQrdl752D
	 +rfrXOsToAKDgVCH+mwXyRRSuYUf9JmCizQ+N2rTCm4GWCWfZzu137XINyCq4f7LB5MXY
	 cAP1L8ISg+8buurLsUXSjdxuCHH7EHOpIbsF3Qe7MR5qDnnSedCGBfKwRANlnWQiAfazD
	 5ve3l7iOtXw94w8J+sa/Tencj/xdjbkevhBv6Zog5YgOf3bZM9lCSyFGR1Uq8y/6pZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBUEXfGIerEivXTIvqvmhQNtmrd1+d8t/X2gjoxruFo=;
	b=UGRwvs7+icNxGunyfBqTLIibiccezEOT/mls8sIQUt4S1DeEa4HhdyqSnHDHakRx//SR
	 h2LzXtM3+qv2YncbMIE6Iow4gech5xSU1r43pDxmzWw1NU408WgM1ZGviTrLYP4JQ4BTK
	 e9AGaQ47LzM5k+TKng2r0sUQ9VV+snyGdI+lNEpkMgSd9081c7aikdcVpiUUIFfuIuy+c
	 BzWWak9G9xgq5NjFClbQy7Ba13m2tQAuxc0VYIO4diiFjRWVPMVPgBK4e8s8YhoqwlPBE
	 rxfkTJW1/+IEZ5+2UF88DCxH/9LocU6/2uqgOR/5F/6gkb4CWXtz0JK88BY4Lpf9hRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t41x0IOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D0C606A325;
	Thu, 19 Nov 2026 00:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t41x0IOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EE41F000C4;
	Thu, 19 Nov 2026 00:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048800;
	bh=JBUEXfGIerEivXTIvqvmhQNtmrd1+d8t/X2gjoxruFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t41x0IOjHbvodamiceOW6AwoLRSrJNxCTf/gZvFDyvJHYapvgUYhUgX7mbm+FOOA+
	 Ib7O3bbx8seODyAL8WVGKPMw676OokMqfRr5tgHmYs3sMxLJwYPoDaUOS/bBb2mQM+
	 Ptt7IpJXKBZbb0nNmS9cDQWR6ln6AKVDrcfrpcb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2083/2857] wifi: mac80211: Fix a race when expiring a mesh path
Date: Wed, 18 Nov 2026 15:51:57 +0100
Message-ID: <20261118150316.407419502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Ginger Li <ginger.jzllee@gmail.com>

[ Upstream commit 6571b6a24cc37c650a1815b1c320e30db5de466f ]

My static analyzer identified a potential issue in 'net/mac80211/mesh_pathtbl.c':
mpath_expired() reads mpath->flags and mpath->exp_time without holding
mpath->state_lock, while mesh_path_fix_nexthop() and the other writers update
both fields under that lock.  In mpath_lookup() and
__mesh_path_lookup_by_idx() the unlocked check is followed by taking the lock
and clearing MESH_PATH_ACTIVE, so the check and the update are not atomic:

CPU0 (mpath_lookup)                    CPU1 (mesh_path_fix_nexthop)
  mpath_expired() reads the stale
  flags/exp_time and returns true
                                        spin_lock_bh(&mpath->state_lock)
                                        mpath->exp_time = 0;
                                        mpath->flags = FIXED|SN_VALID;
                                        mesh_path_activate(mpath);
                                        spin_unlock_bh(&mpath->state_lock)
  spin_lock_bh(&mpath->state_lock)
  mpath->flags &= ~MESH_PATH_ACTIVE;
  spin_unlock_bh(&mpath->state_lock)

A path which mesh_path_fix_nexthop() has just set up as MESH_PATH_FIXED and
MESH_PATH_ACTIVE then has MESH_PATH_ACTIVE cleared again, and forwarding to
that destination silently stops.

Take mpath->state_lock before evaluating mpath_expired() so that the check and
the clearing of MESH_PATH_ACTIVE are atomic with respect to the writers.

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
Link: https://patch.msgid.link/20260922054253.11976-1-ginger.jzllee@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0a4641f06bb1f..a5ea7bc2065b9 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -210,9 +210,10 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 
 	mpath = rhashtable_lookup(&tbl->rhead, dst, mesh_rht_params);
 
-	if (mpath && mpath_expired(mpath)) {
+	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
-		mpath->flags &= ~MESH_PATH_ACTIVE;
+		if (mpath_expired(mpath))
+			mpath->flags &= ~MESH_PATH_ACTIVE;
 		spin_unlock_bh(&mpath->state_lock);
 	}
 	return mpath;
@@ -253,11 +254,11 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
 	if (!mpath)
 		return NULL;
 
-	if (mpath_expired(mpath)) {
-		spin_lock_bh(&mpath->state_lock);
+	spin_lock_bh(&mpath->state_lock);
+	if (mpath_expired(mpath))
 		mpath->flags &= ~MESH_PATH_ACTIVE;
-		spin_unlock_bh(&mpath->state_lock);
-	}
+	spin_unlock_bh(&mpath->state_lock);
+
 	return mpath;
 }
 
-- 
2.53.0



