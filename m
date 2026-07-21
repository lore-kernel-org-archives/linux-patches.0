Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0546471250;
	Tue, 21 Jul 2026 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660813; cv=none; b=iB9y66qQM4hsMcOWMwwsgyuh6G6ej++aGE3KsB2c9IdRMTauTxECqQ9sM/IhAzOesnOGDNbb1+WAoifdpowt89NaUYILN6h0VETyQiSXhIh1VXjrmErQJxhRMJZ7nab/RcIRsg5akHkLVGQSAyBSZEDvs9dfaMFJxgRUCdS3N7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660813; c=relaxed/simple;
	bh=Cy4VwFBAzFmCgcl0UTI/LcFOAk1EBinFn3jP7X+dzoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1brue4J8CZLwjI/HrHMCmhqMiQFN7hdiURJnPZNmCiymG57yQWbKc4DfkL4czWkdNXnW0E9myldO+r5w63whUSADLLJ3lnnjcmOq5Ie0AHtv1CSV1aAtqJ9IjdkWqfZooQtCRsrF1ehORirJ5KMYv7S3N2XgA3imiDawUsDlo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RylLGUx0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RylLGUx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204671F000E9;
	Tue, 21 Jul 2026 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660811;
	bh=qfw3gGR8Vt3TRP0Rs4sMFlvfO//SwaNQR03AFNDPCiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RylLGUx0SVNAiH1HS+DJMbxT7P4nhUbLfmxhBq8fEZdWL7Y7ADygAazPeLfhscV8p
	 SOaLssIt3kCKhSLsZnoG5xGEcoIdjc7TzoJKM6OdmSuMSs8gRR4DQYPYdZbXkZ0MKE
	 exgBEZJIbo5kZzCxcnhWAW/ESspfApbqPTm6Df3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1122/2077] devlink: Fix parent ref leak on tc-bw failure
Date: Tue, 21 Jul 2026 17:13:15 +0200
Message-ID: <20260721152619.282877012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 210e26c6cfa04c..533d21b028a7b9 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -486,16 +486,19 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
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



