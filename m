Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024632;
	b=L1NHakXhPaS2lisainsDMrU/5aHQHIYB2BusnmCvoe2+ssM4rTIpEeC3klsSn/vWutX1
	 RjQ0tCnmtQGhuV9KE2dpGsSB+c+ZAi27ft4DoB9oeZYnWfJMyOWy3X/Oy/JF5figl8AOH
	 x7E6KVdWDQMGnUNDrTa4SKy6w3YR8Og9TwE/s3zeKuUmpnrBrS907E4LIZEWKlIO4jnwB
	 31aPmrXwWqEgJmRAQJvtEwhdlRBhI5R5n5sWStsLVUbhy/MrNSDv1bPMjcTRjss1+yeP8
	 2boSxr6peP5ptiDaA+NYN/srJBZSbtn4QnAgqcw3oR0hrqi7ykdv5rrTHW5DwFM6JLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjEXqhCVOrlw4+6hj+j25OfoeVksUDs7qGPHB3rZBbw=;
	b=wqM38w7KTcspJsy+MVa9aDWYNfFeZeqW+nK2lPG1g4Hnqj/NStsYDmnYyw2yEaJT9lwg
	 CYIucF8TUsiMUaX9DIDoc7JE4S4TD3XFRkw7asqZ+Fylzce7BKlKBjFrweF+byIEIe8LB
	 rbHscxQgtsDFVD1UE/bh0RxPGbVPSW/6L8d0+878pdbsyyGKauy43DjD/LdG9DlHhSzEo
	 01U6EyWj0m20ZgRwMcHPyOeX76VenaKiY7IobxK1rfZR/qRlLx3oELNc5YV3obYYOkdtL
	 VBZcY1azc2J+1IB23hnP9ZqWkQHKZuOTxr/gDHVNJJaIw7i8W0ITpxjmkrNniWABZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyLCFXt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA56A606A31C;
	Wed, 18 Nov 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyLCFXt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FC41F000C4;
	Wed, 18 Nov 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024631;
	bh=pjEXqhCVOrlw4+6hj+j25OfoeVksUDs7qGPHB3rZBbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyLCFXt7k/eHrmQok2qDa1mdRbpH1kg275QNKmyWkDyAF2N9BsyvlP55JY/jyZtct
	 B5m95Eq34ldcIYJdR1J0Z/vW6PpcZLvGl2VhVzKyex47tsKBbcmidseVgTDrYQKt6E
	 DycGkB5PwgXXsFYSDiAo6qi5I5+PsDff19+zXFfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0795/2151] wifi: mac80211: Fix a race when expiring a mesh path
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118150151.049837204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5b492ed5e5a35..33a0ef5285e10 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -247,9 +247,10 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 
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
@@ -290,11 +291,11 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
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



