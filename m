Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAFE4DDB42;
	Thu, 17 Sep 2026 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661041; cv=none; b=s/THIrPNiHrU/o3TePovs67BmT+hvTvLzO5P9sfvxfezN2Myg+pwWurZ9c9l32umBSvnBa/S7QMpvtMn/g/AEMvhZp8sw8LEy0RRC8v2/nkRqmSja1cAh0ZS0hWfApqRtj4EvNW8aDyIGm2ekfS05EXKGJNQweLqciCSGQBSu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661041; c=relaxed/simple;
	bh=ZfSWp3P3e7STpdmPJ//93S5gjSI64PUL2KcWGATANRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOHO3pea73qyQSq52veBFM9JzEjEcLNWkjkme2B6hr6OmepIyz5dCgJU1kSYiLVOohfYxXk75tzjIbpemN4YcSKGfarfjxZp8IlV1yUw7cuIdJ+kNZQ7yvJTSftL8qepj1RccJiraCRhrqYrPQONUMUGXBfbeKSZi0enu6vCoZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQ8Yb8WP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQ8Yb8WP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42A61F000FF;
	Thu, 17 Sep 2026 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661039;
	bh=etcvlZ45Vu1qjVdr33dVhg/yQDEowbgC2OedD43ObgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQ8Yb8WPoo4Zx5CqX9HWagTq5oLHWKG9C6GDsfExv9NpyUSYQBnkNqBpPHjq1fZqP
	 J5kDTSvcaTduSn2OMXS3WWisFDdnGhpN0VgaCTnj0DlNA/u/84nYosnpS0wr8nUosU
	 sZUaWKxpe4RihwdIJv6M5pnvI14icHWN8Cy1L498=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0061/1250] thunderbolt: Dont create multiple DMA tunnels on firmware connection manager
Date: Thu, 17 Sep 2026 15:57:36 +0100
Message-ID: <20260917151553.597350481@linuxfoundation.org>
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit cf0c38ee554c3e9062408cc3a38325483d52ecd0 ]

Firmware connection manager supports only one DMA tunnel per XDomain
connection. Firmware prior Intel Titan Ridge failed the operation
directly but the same does not happen anymore on Titan Ridge and
forward. For this reason add an explicit check, and fail the operation
accordingly in the driver.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c     | 10 ++++++++++
 drivers/thunderbolt/xdomain.c | 25 +++++++++++++++++++------
 include/linux/thunderbolt.h   |  2 ++
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index ae9bb76b05424..cafd91a443bc8 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -587,6 +587,11 @@ static int icm_fr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
 	struct icm_fr_pkg_approve_xdomain request;
 	int ret;
 
+	if (atomic_read(&xd->ntunnels) >= 1) {
+		tb_warn(tb, "only one tunnel is supported by the firmware\n");
+		return -EOPNOTSUPP;
+	}
+
 	memset(&request, 0, sizeof(request));
 	request.hdr.code = ICM_APPROVE_XDOMAIN;
 	request.link_info = xd->depth << ICM_LINK_INFO_DEPTH_SHIFT | xd->link;
@@ -1157,6 +1162,11 @@ static int icm_tr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
 	struct icm_tr_pkg_approve_xdomain request;
 	int ret;
 
+	if (atomic_read(&xd->ntunnels) >= 1) {
+		tb_warn(tb, "only one tunnel is supported by the firmware\n");
+		return -EOPNOTSUPP;
+	}
+
 	memset(&request, 0, sizeof(request));
 	request.hdr.code = ICM_APPROVE_XDOMAIN;
 	request.route_hi = upper_32_bits(xd->route);
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 1eb149445fa05..e2c46366c8160 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -2021,6 +2021,7 @@ struct tb_xdomain *tb_xdomain_alloc(struct tb *tb, struct device *parent,
 	INIT_DELAYED_WORK(&xd->state_work, tb_xdomain_state_work);
 	INIT_DELAYED_WORK(&xd->properties_changed_work,
 			  tb_xdomain_properties_changed);
+	atomic_set(&xd->ntunnels, 0);
 
 	xd->local_uuid = kmemdup(local_uuid, sizeof(uuid_t), GFP_KERNEL);
 	if (!xd->local_uuid)
@@ -2302,9 +2303,15 @@ int tb_xdomain_enable_paths(struct tb_xdomain *xd, int transmit_path,
 			    int transmit_ring, int receive_path,
 			    int receive_ring)
 {
-	return tb_domain_approve_xdomain_paths(xd->tb, xd, transmit_path,
-					       transmit_ring, receive_path,
-					       receive_ring);
+	int ret;
+
+	ret = tb_domain_approve_xdomain_paths(xd->tb, xd, transmit_path,
+					      transmit_ring, receive_path,
+					      receive_ring);
+	if (ret)
+		return ret;
+	atomic_inc(&xd->ntunnels);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tb_xdomain_enable_paths);
 
@@ -2327,9 +2334,15 @@ int tb_xdomain_disable_paths(struct tb_xdomain *xd, int transmit_path,
 			     int transmit_ring, int receive_path,
 			     int receive_ring)
 {
-	return tb_domain_disconnect_xdomain_paths(xd->tb, xd, transmit_path,
-						  transmit_ring, receive_path,
-						  receive_ring);
+	int ret;
+
+	ret = tb_domain_disconnect_xdomain_paths(xd->tb, xd, transmit_path,
+						 transmit_ring, receive_path,
+						 receive_ring);
+	if (ret)
+		return ret;
+	atomic_dec(&xd->ntunnels);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tb_xdomain_disable_paths);
 
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 7204586c10c3e..466f315f0be7b 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -230,6 +230,7 @@ enum tb_link_width {
  *				changed notification
  * @bonding_possible: True if lane bonding is possible on local side
  * @target_link_width: Target link width from the remote host
+ * @ntunnels: Keeps track of how many tunnels go through this XDomain
  * @link: Root switch link the remote domain is connected (ICM only)
  * @depth: Depth in the chain the remote domain is connected (ICM only)
  *
@@ -276,6 +277,7 @@ struct tb_xdomain {
 	int properties_changed_retries;
 	bool bonding_possible;
 	u8 target_link_width;
+	atomic_t ntunnels;
 	u8 link;
 	u8 depth;
 };
-- 
2.53.0



