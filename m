Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055437;
	b=npH/Sml3ILJjXk9yYsTOIBzNHuDyyFW+yMq2jPpmRXkP3VB8z7B4+3NnSwJHWvVwNwOx
	 /Lvebn15VdkFj22GtGVTpalrT4reEhpIQ+/sHzBI5rZ7wiMzBTSvdcftVT0Rxn622U/hw
	 vi65+fPantv4tteSXuCLh5evqmdkg80lzwPKMhpp+nghBWpGmdTjKNidICGUzdrMdv/Yr
	 hTbjWOdjTDNpWh7l4sQ96nBYEoT5tOspcqwJpB2/nfR0S3fK1A8Pk13UTt06LT8hdn9y5
	 5S9MdQEgJ1qehI6mGbHHyyoEcDFbPjx7ZnXkW26DMIX3jn9Z/f6O7eLpwZwTsnATwQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmGHqgAS7JOerjAXL1UesrYSJKaIcZtgZu9axnprekQ=;
	b=Jhy0xRJxhHLwsMP8hKzYkDyMWSkRCjyJUAcI5fmFC3o8qoKgfgh2pm5wJv+18hXHwX/8
	 yHN9pPc9D458jgQssRJFlbT42YYWUUtAOYGrBAAoW8nE6xv19kKaxfK3nua7ZM/oPhFci
	 rA2KilGChUZqAbjyNoZqzueSYIupwoqALCoZD0vVWPj+QiOTu1tUBGU+TKGrURERe/mu+
	 oZbDi00eh7/Q7UO+ljk9a64XwZVav4MI1i457p9mAqfydVA186HQOTa5yEKlubHHAUbnp
	 fzMqm4S79K/zRKpvCzjph2nMaVXtiB9XNRlcAeMgMB+SZpoQV0jUhrrN4fIeCMZigQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSAo4d+f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310F606A31C;
	Thu, 19 Nov 2026 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSAo4d+f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0702B1F000C4;
	Thu, 19 Nov 2026 02:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055437;
	bh=vmGHqgAS7JOerjAXL1UesrYSJKaIcZtgZu9axnprekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSAo4d+fNNFYiefWdtuBNDKxZD7riozEoyoLa6WvhVeTTm8Dx6HHr0AIeW6vKVtus
	 2ixPujj5cuwnN0esd/Fq0TAYoeXdkJLGfPkdwG2gvW1OkFmXaR+1ubJ02zM8/oI+mp
	 UqVW24QatHp6475gE40etmx5nD+2Lu/U6Ixf6xGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1630/2214] wifi: mac80211: Fix a race when expiring a mesh path
Date: Wed, 18 Nov 2026 15:55:06 +0100
Message-ID: <20261118150117.166417952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



