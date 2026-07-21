Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325546A5FB;
	Tue, 21 Jul 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657575; cv=none; b=EGEk31QdDprGtuuOyp/rZzHstV4pEhTnlnkgUoe961EUhGFqTnUOSaLgeE5ey+Ou9EjxlQAuokAy9hn18aQSv2UXGKAGmYNniXJRLRutEzHgA26npgdl7wjCn9D8JVc78eajQyUYHnCzt9RkaGzebofi9TPXsfTOGsHq81Z+50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657575; c=relaxed/simple;
	bh=xWaiqxjm9ZY3dcoxU2wpQgn6+PCWwt9hzY+YmcNp5yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrO0FgDfSCTomgB4FLx1bDNgsATQoBFI2gx/s9fQts1OECSfSwofGXx28qoI5cbPTsH2Q2vdtVxHcFjt41/YsGyWvyzVghsI7aI+vEBdSlh+8kFRjnUkuYzCjTnCL5gWEcd85aQPXvSplT09wXVD1y8/nTIc62oI8oPmsrMDrko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNXC+Fjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNXC+Fjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2DA1F00A3A;
	Tue, 21 Jul 2026 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657573;
	bh=lyb00Iv2N0s0HNeU6pHuTbTZ8hvpk2zsYev7ZcNSeMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNXC+FjztAVHLrFjR14tcjjRMhMwQsYSvrOrnkq3K/SZ1YSDkqldtPHJe2ZjpxV79
	 S8B/WP5f3+dSUEdrBvWG0/D6nJwTILYSOxztM8ZBAy4bWqz2cBpn/HKeppFJhK02Y3
	 JUDa7jtt70ZVc3czJOREARHZ6ZcmUwMZh4k+t+Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0816/1611] devlink: Fix parent ref leak on tc-bw failure
Date: Tue, 21 Jul 2026 17:15:32 +0200
Message-ID: <20260721152533.744718446@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit ba81a8b80f042038b9f73a4e5bb135de890b59bb ]

When a node is created via rate-new with tc-bw and a parent node,
devlink_nl_rate_set() executes the sequence of ops. It bails out on the
first failure and doesn't rollback anything. For most things that is
fine (setting some numbers), but the parent set can leak if there's
another failure after that.

That is precisely what happens when parent setting isn't the last block
in the function. After the referenced "Fixes" commit, when tc-bw fails
to be set the function bails out after having set the parent and
incremented its refcount.
There are two callers:
- devlink_nl_rate_set_doit() is fine, it just reports the error.
- but devlink_nl_rate_new_doit() frees the newly created node and leaks
  the parent refcnt.

Fix that by reordering the blocks so parent setting is last and adding a
comment explaining this so future modification preserve the ordering
(hopefully).

Fixes: 566e8f108fc7 ("devlink: Extend devlink rate API with traffic classes bandwidth management")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260616110633.1449432-3-cratiu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/rate.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/devlink/rate.c b/net/devlink/rate.c
index 3eaf1af3b59cf1..de13b9818dfcc9 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -487,16 +487,19 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_weight = weight;
 	}
 
-	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
-	if (nla_parent) {
-		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
-						      nla_parent);
+	if (attrs[DEVLINK_ATTR_RATE_TC_BWS]) {
+		err = devlink_nl_rate_tc_bw_set(devlink_rate, info);
 		if (err)
 			return err;
 	}
 
-	if (attrs[DEVLINK_ATTR_RATE_TC_BWS]) {
-		err = devlink_nl_rate_tc_bw_set(devlink_rate, info);
+	/* Keep parent setting last because it takes a reference. This function
+	 * has no rollback, so failing after taking the ref would leak it.
+	 */
+	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
+	if (nla_parent) {
+		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
+						      nla_parent);
 		if (err)
 			return err;
 	}
-- 
2.53.0



