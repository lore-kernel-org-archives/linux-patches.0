Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA31DED55;
	Tue,  8 Oct 2024 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391232; cv=none; b=u6fQIQ+jASaoJ1vF5gYoaQZaao7FxP1TqsRUQXoW8nwh5QwqyFTs2CHWSzig/Hpxa8B6hXflIDii91BC8wJVAjoZBznq6oXnOOrdNNqZLSJ3M67kV8IeRBMd3vQDgdca2It7MOuGf0OwxLzZAW/yyPXphBCyRkMh1RCjNurONZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391232; c=relaxed/simple;
	bh=c/4XrmI8cZBAao6FUwmJOJ9WR3L3IhVG0xWlmpWJsMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYP3p3SQez59YPwa7qcqHkB7WWJxb7GaT1u4JwdbbHAEwXV/M6Exa5OtWO2QHl+sLQyUp0YuWggZKbEsaR4NqH8hs0t1ni8SQ5FRQsaEPNCGZUvn3Cix1+O04UdT59ovMoMc/7L7Yp5xl79GWJykw9N19u141v4PZR165DsRgvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfwX5UH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfwX5UH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4241EC4CECC;
	Tue,  8 Oct 2024 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391232;
	bh=c/4XrmI8cZBAao6FUwmJOJ9WR3L3IhVG0xWlmpWJsMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfwX5UH3H/gtFnY68JQy1JlYxjOXmCi1QlTNj760SYF2uRNzqkpT85+z7dqP6bqYk
	 vvfW7T34BvwXN+Sg3mFO86uKOnZuac7hHuvpkf7+0XCQKuVJCkxaOfZMOI0uG1LKY3
	 fQCeRAgb+z6Ytl6UUGltZMB5VrvfLZT2COQ6mhss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 050/558] bridge: mcast: Fail MDB get request on empty entry
Date: Tue,  8 Oct 2024 14:01:20 +0200
Message-ID: <20241008115704.190833058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



