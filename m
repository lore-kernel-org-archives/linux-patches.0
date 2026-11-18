Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061044;
	b=mOnH9YEQBFynI5rJ2QJ+a/KvDejQ6BRvSqdNPmJKZNxQYVV4pcm0ZsXiQ49ixP9ZOQNh
	 dhuSiFRZt2KIcsiBJ+kh5B8wQAUftu0X/JnmTX323fa2Q0Tp6LrCyqqsx8elx2nPYkey7
	 hJVVE4l8YgBp3LS2TVNGNP1FoNFmxCv2ej/EXvtu/v3L3MBdnAkOGcTz/9ynn56huxxP6
	 IftCGm6EUD4rDBk+c5CpOd7sTIE5yZUSPV3S2qBhzFMyAK1/Ss8hDs5nsS/o8CL36gESM
	 U4FE0Pr/9fQEUetico6KkmEs+/OLConpNdalvCnVge3hVo27Iouxr39/jLJhV3ymHcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LaOZKIJbk3BLO9ejKB09a1DgNLasw9G+lfPJJGwDuE8=;
	b=TbUGqYgEBe+EP4sq6v6KOYCWMAbAZCZEBqAO961q2XJZg+hsuikLXls2IqlQs41TvaW+
	 v1M2jS8YW0DCd7MyVbauwc8MbcOGBSBEjGnp1g3kQYKNFmKeeWOHIO4hp0/5koeIjPMQg
	 010q/OaX44/3Qdyd7Wfqz2T0iXA0tsZzIf7T1HtZoHOyZbosf1S4+mHiF4jJmY6TfTPF3
	 4fo5A7nnchYFysTt5Am7gxugOlOP/yW5816qT7hczy5qxU3zquGMNLgwMqoU2WfACeaB4
	 mQXb6f2yUS9ekMMO/7JcriLHoGiaVKS9nmevOJsHyzqlN/C2r0zpS18a4qv33CnrO3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfWqQ8Ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559E4606A325;
	Thu, 19 Nov 2026 04:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfWqQ8Ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7E51F000C4;
	Thu, 19 Nov 2026 04:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061044;
	bh=LaOZKIJbk3BLO9ejKB09a1DgNLasw9G+lfPJJGwDuE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfWqQ8KoIUSrpkgTAejvvtQlncdgSM9OexiU1PIlYs8KzztvnzLpfm02ALl1G8qLG
	 jpKFn9Lbn1i+EnBeCNN8zlgPpVP652jzvH4F21LjxE2A2yBpaLCRLxXq/TOwOl6ViX
	 mgpbifNpoZc7A6a5dX7aRElRVcjusKZNlW5wC9UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1376/1848] wifi: mac80211: Fix a race when expiring a mesh path
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150017.118186689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 578f3fcafea91..5581e59e87bb7 100644
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



