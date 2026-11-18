Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017575;
	b=e2VHNdUKBAqxFB2lk7RsggjB1kH+OQ+iNBJIx7T5ZTdJMZuXcFbTNR2tnehMZ2oVdFhX
	 OcAtJhoRWz3/+O1ij6H9rS/5nSokdEKkdL0/rm688h/uF1wQakAfxOdOx7D5hiB32XnGP
	 EKwcE/kGHJcC92yhtJze/IRxpt+G0QIoNeJoM0bJiIOpmCc0E3JAHx/LdK6XTKQge0/gh
	 F4XbcFT9SxnExSQyCi3StBdCyY3O3G+7qAZ2XNKgYazCSboHdBoYL7tORaeLIgJ8tUJ45
	 qEFOqrRwEpcVk4IfKhn8BV5RBWz3WxoFQ8JwSbp3CtlY6Lr1AUtpWHwGt5JbPPggEZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fmdGYTVW9wUMLBgu81HRfIyFJwSm9PYkz0r3PmHj5CU=;
	b=3EI/7q67tE/+DgOPSixIhWiGGJUpHEvsA/8ZZZJNB0Pk6i0lz0j3OMFGrFgAJJZQO4/L
	 nz+DOtf2MouO15hCbB6+DqbBZWdZXyHIWaqlXiQ6iCbRoervZTq8x3OK5Ov4uTS2QFJOR
	 SMDKwcyAAhjVSs0wwS1uc3H/L4jZwcxK4zhafiK4QfecDk8xY35iWbdZBMsKo+K/w0+HS
	 p53moGchnjgWq4Ga1nuU1ZEAzFTPp0qcwfyU/36IPF0qKbASQvODClphobdDeZdKxgHFk
	 vNMiZUltN1nx83Dz28OPAYkC0qdodmSh7UV3gCEBJiuYCJN80gW0hz8Yf3NSfbfxeQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRCOHHT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F45606A320;
	Wed, 18 Nov 2026 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRCOHHT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC271F000C4;
	Wed, 18 Nov 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017574;
	bh=fmdGYTVW9wUMLBgu81HRfIyFJwSm9PYkz0r3PmHj5CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRCOHHT7GbaOstV/RDqpKKkxyrbTtat12PbY9zQlbJETIWJqKnFDBgYA8ORDkm0mZ
	 1+95yH2Hvrg2GiqGpIS4YFifcIu7OcwQDCNVL4X6vnVHvpT3IQlr8c/BnudL+a25K/
	 +wUEe1lH67UdAOZOBpmV8Kmpj2xDJz/wavoErXHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger Li <ginger.jzllee@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0933/2651] wifi: mac80211: Fix a race when expiring a mesh path
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118150321.470341031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5a6ed1b6db97e..7b2f71186dfbd 100644
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



