Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8231DE2AE;
	Tue,  8 Oct 2024 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389616; cv=none; b=D94s+U4LDRd0UPQVPk0PH0jlUwcsAXQ4JoWZsVpQSsvhWIxqpSbhJmGOggXnmvDTW+FF31sjwT+/kFK4G8KOvzWUebR45KiEDz7FBILoXxob8g3sBq8ALzlWqFRfL+FcDixPGy2dQHyDb0BnAHlPuRTKIMNK+RVdSxsvNHBIRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389616; c=relaxed/simple;
	bh=783+hWHknDZ9UB2OxHzlYPi4vJ0DKnVYf+JhQx/A3uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeWSxf1haT0ueqIl7d80SqzVUg5CQ1Hgae8oIFgnO8rDrC45DXFiH7uvkE7cGE1DrHWOB5zRVU16RXb7We3l96vPxkmgUtVLRN/3oaf7kOWCJrDX6JjZYkorJP/rRjUBfQbf2fvYJ2FSR2Jtvol3oXqQRScK5P6NZb2oW4xCCYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02j0DBJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02j0DBJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3E2C4CEC7;
	Tue,  8 Oct 2024 12:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389615;
	bh=783+hWHknDZ9UB2OxHzlYPi4vJ0DKnVYf+JhQx/A3uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02j0DBJB9eAUXDAmHWqDIfVYLc2hpGI0ApRkZqzw+HtDSsN/lhHUOP4MS3qbqbB84
	 JXmJI4UIwF+whTGSHldTHsdbyp3qpbho8OC4rs0K+IUiVY0y1gP4azvhC0fAZ9neBP
	 Enqx6TYDImAhawvZoRh+ffJmgSFGAByzXD5wk4Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/482] bridge: mcast: Fail MDB get request on empty entry
Date: Tue,  8 Oct 2024 14:01:48 +0200
Message-ID: <20241008115650.078422565@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 555f45d24ba7cd5527716553031641cdebbe76c7 ]

When user space deletes a port from an MDB entry, the port is removed
synchronously. If this was the last port in the entry and the entry is
not joined by the host itself, then the entry is scheduled for deletion
via a timer.

The above means that it is possible for the MDB get netlink request to
retrieve an empty entry which is scheduled for deletion. This is
problematic as after deleting the last port in an entry, user space
cannot rely on a non-zero return code from the MDB get request as an
indication that the port was successfully removed.

Fix by returning an error when the entry's port list is empty and the
entry is not joined by the host.

Fixes: 68b380a395a7 ("bridge: mcast: Add MDB get support")
Reported-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Closes: https://lore.kernel.org/netdev/c92569919307749f879b9482b0f3e125b7d9d2e3.1726480066.git.jamie.bainbridge@gmail.com/
Tested-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20240929123640.558525-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index bc37e47ad8299..1a52a0bca086d 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1674,7 +1674,7 @@ int br_mdb_get(struct net_device *dev, struct nlattr *tb[], u32 portid, u32 seq,
 	spin_lock_bh(&br->multicast_lock);
 
 	mp = br_mdb_ip_get(br, &group);
-	if (!mp) {
+	if (!mp || (!mp->ports && !mp->host_joined)) {
 		NL_SET_ERR_MSG_MOD(extack, "MDB entry not found");
 		err = -ENOENT;
 		goto unlock;
-- 
2.43.0



