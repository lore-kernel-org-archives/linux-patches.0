Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A13B71DC;
	Sat, 17 Oct 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256683; cv=none; b=uD+plqlWCd4KfWxdfY8mxmtUNcxyb12zUx6sHNftI+vsoOz2Zl+EliRl9pUtcgdZxihXrf5itdIYltLQHBWrh+mlyztDXAJqLkXu3iJ7G4hmah0NDOmxG+IM6gZjV71u6SKsW2/LNVT3nV8pGwG3QaL8xSu3JpoU7vEzUf7q9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256683; c=relaxed/simple;
	bh=6fjAUQa4avrtqBU4N6maSjHjDV4rEOH79Tu/IuZQgV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0vX4efKg3QzcYY3wS7caW4tljEv2J3Fi7KftvDaNab+H4IUOAA1V3z1Ryxp8fFeEIs7lN3RoojCEqPqPH1zo8M5x23tbrQbWtqRt7MqAEvrq1FkPNvlnkkFWgkMUIgcFIYAj8jwDAyhdxcJaH5F3p1WwMymLJileGo5u5drYE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id593NMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id593NMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0846F1F000C4;
	Sat, 17 Oct 2026 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256682;
	bh=fKy8iWlH0J/bBvEhveOPLIClKUfQbVBXhCG8Dc1uxDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=id593NMVF3G70FYhC8a/dp5PRlH7hbeuWlqj5p34N3GfuLewDeau9MnsBolrclglM
	 cCyM8HWe1y6myYbcLDeiAHaCieIEaF52lcuuG00iV7dzyLc7ir/FXznekmkIBqCsUm
	 cZt9mpQS/mTTwpn5EQNJONQXWR0oVrrcDhFDsLNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0317/1674] wifi: mac80211: release mesh path quota on failed additions
Date: Sat, 17 Oct 2026 17:43:09 +0200
Message-ID: <20261017160439.254378660@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 7325a44474f20c1393a1c114c6811abce6ddfaf4 upstream.

Repeated failed or duplicate mesh path additions can exhaust
MESH_MAX_MPATHS while the path table holds fewer paths, which stops new
paths to reachable destinations from being created.

mesh_path_add() reserves a slot before allocating and inserting a path.
If allocation fails, the function returns without releasing the slot. If
the rhashtable insertion reports an error or an existing destination, the
function discards its candidate but retains the reservation. No new path
is installed in any of these cases.

Release the reservation whenever the candidate is not installed.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113649.28315-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -689,8 +689,10 @@ struct mesh_path *mesh_path_add(struct i
 		return ERR_PTR(-ENOSPC);
 
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
@@ -703,6 +705,7 @@ struct mesh_path *mesh_path_add(struct i
 
 	if (mpath) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
 
 		if (IS_ERR(mpath))
 			return mpath;


