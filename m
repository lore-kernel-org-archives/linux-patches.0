Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5055A9861;
	Thu, 17 Sep 2026 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661233; cv=none; b=Km+u//Pp9ZS0hNznuksfgr11P/w9rLfeieVcUhcynmAD4UOMw+2JKQzwbNVlEbYmNfgDbk5C4WuJ4AkxU6ZDttzuNL5kTb1p/jJVnfxghMHg4ebqzToSxg6kisGiwxQlwzZKVjAH88VrW5JnzYW8wIUauLokhzn47Uyea1Dsrc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661233; c=relaxed/simple;
	bh=QCUrR5rp690XMR3RhN5Tf5v1l94jBl9yg2l3UTfUYSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOZ/bzDwz1ZXe7FkZv/LaDcsoZKKZ07AvR+xbrlXZv4q1CZZZoW2664G4/Jml2SyCnU31ct2Ijeb8ltSdlYP18+E2H5/NLNgZn8YdNp2Hi9mRx8apkR7Nf8s1myzIPmY7MSyTWY3lwvwZrX1XWR4SSC/56ph/AMLglRoJ/HgknE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8DlONMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8DlONMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6A41F000FF;
	Thu, 17 Sep 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661232;
	bh=mjeoHh1GPTUTLoGyq5W7kfazvTZVycsusJYd7iqFch4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8DlONMb0G00ZuIP/dboQjAKUNoG90PPDVeKUY+gnD3dgezUent2zA7Xe/P7M3VMH
	 5AIw/YCAkkZ9u042Mp2JrhSiL8vjPIiOpyNg3ZsQbJkT5oBF6zr26dL3aZb+RqUQ5z
	 FjOmPL1qrCIrQbKE/lCjgcHlX4rIVupvZQ1meUaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0128/1250] coresight: Disable source helpers in coresight_disable_path()
Date: Thu, 17 Sep 2026 15:58:43 +0100
Message-ID: <20260917151555.507207441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 5cae719943399929b4f9e612d9400017d3e2c1e1 ]

coresight_enable_path() enables helpers attached to every device in
the path, including those bound to the source. However,
coresight_disable_path() skips the source node, so source helpers had
to be disabled separately in coresight_disable_source().

Move source helper disabling into coresight_disable_path() instead.
Make coresight_disable_path_from() start from the passed node nd, so
it can also disable helpers on the source. Update the comments
accordingly.

As coresight_disable_path_from() now changes its semantics from
"start beyond nd" to "start from nd", update the failure handling in
coresight_enable_path(). If enabling a node fails, iterate to the
previous node (the last successfully enabled one) and pass it to
coresight_disable_path_from() for rollback.

Tested-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-15-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 4cf4a3e92c272..d57000626c060 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -378,19 +378,12 @@ static void coresight_disable_helpers(struct coresight_device *csdev, void *data
 }
 
 /*
- * Helper function to call source_ops(csdev)->disable and also disable the
- * helpers.
- *
- * There is an imbalance between coresight_enable_path() and
- * coresight_disable_path(). Enabling also enables the source's helpers as part
- * of the path, but disabling always skips the first item in the path (which is
- * the source), so sources and their helpers don't get disabled as part of that
- * function and we need the extra step here.
+ * coresight_disable_source() only disables the source, but do nothing for
+ * the associated helpers, which are controlled as part of the path.
  */
 void coresight_disable_source(struct coresight_device *csdev, void *data)
 {
 	source_ops(csdev)->disable(csdev, data);
-	coresight_disable_helpers(csdev, NULL);
 }
 EXPORT_SYMBOL_GPL(coresight_disable_source);
 
@@ -417,9 +410,9 @@ int coresight_resume_source(struct coresight_device *csdev)
 EXPORT_SYMBOL_GPL(coresight_resume_source);
 
 /*
- * coresight_disable_path_from : Disable components in the given path beyond
- * @nd in the list. If @nd is NULL, all the components, except the SOURCE are
- * disabled.
+ * coresight_disable_path_from : Disable components in the given path starting
+ * from @nd in the list. If @nd is NULL, all the components, except the SOURCE
+ * are disabled.
  */
 static void coresight_disable_path_from(struct coresight_path *path,
 					struct coresight_node *nd)
@@ -430,7 +423,7 @@ static void coresight_disable_path_from(struct coresight_path *path,
 	if (!nd)
 		nd = list_first_entry(&path->path_list, struct coresight_node, link);
 
-	list_for_each_entry_continue(nd, &path->path_list, link) {
+	list_for_each_entry_from(nd, &path->path_list, link) {
 		csdev = nd->csdev;
 		type = csdev->type;
 
@@ -450,12 +443,6 @@ static void coresight_disable_path_from(struct coresight_path *path,
 			coresight_disable_sink(csdev);
 			break;
 		case CORESIGHT_DEV_TYPE_SOURCE:
-			/*
-			 * We skip the first node in the path assuming that it
-			 * is the source. So we don't expect a source device in
-			 * the middle of a path.
-			 */
-			WARN_ON(1);
 			break;
 		case CORESIGHT_DEV_TYPE_LINK:
 			parent = list_prev_entry(nd, link)->csdev;
@@ -561,6 +548,8 @@ int coresight_enable_path(struct coresight_path *path, enum cs_mode mode,
 err_disable_helpers:
 	coresight_disable_helpers(csdev, path);
 err_disable_path:
+	/* Fetch the previous node, the last successfully enabled one */
+	nd = list_next_entry(nd, link);
 	coresight_disable_path_from(path, nd);
 	goto out;
 }
-- 
2.53.0



