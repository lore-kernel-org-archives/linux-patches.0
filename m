Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3879501298;
	Thu, 17 Sep 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667288; cv=none; b=bKBaoyWv959OeAMGmLZR+PO38T6TGwfVSJe8UkySyYdmH9z4pBivOBAmE3EDnTJfGi0v2ekqePTvnFRUAQMHmmS414vNI9Hggm/2EU3vOsgzx0rhK2ZAsrsot+e6UPpCTwFLz+96eyjMA7evNwmxuGfdikqCf8yYBMSWwnGmY8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667288; c=relaxed/simple;
	bh=sRqOtGEgT6o9YfFJQybqPDAla1YCXi7qKvxH8hyGEL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyuSUN8KpnDNYZRFtFzc5EGIoH08J2/8qOc45jo4VkVfgBAV4IkzH8zW1P+CPyBYVU1Xeb5+BTzt6u7UF51WZgZJgoTehlwR/VE+ZJmpze+1fbwaFqbc2oz/JuhpGj9wrsuUhp54efvtrwOkQoYvoS42O0RJOIbIcX/TKH0aTNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5r0osKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5r0osKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9D61F000FF;
	Thu, 17 Sep 2026 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667286;
	bh=2Z2AA9CNlFeFG4qt4RSsM8w4GZthsGOAHL/+Ucx++40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5r0osKsxBiA9JMm4Eyo5/jZwcVr1EpikZs+wU9Lbm+op6Z1GNu77PR0k0CjA0O2v
	 VlErLQis51lEGzdnPka+aCwNYzGS+p7i91GAq3wfsmUcGclLRoiZ4NjAFYZ4UcmO46
	 wOXwjpcAqy3nCd8eCYCZNj8T6J53LFsxjBX6mIEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0041/1102] thunderbolt: Dont create multiple DMA tunnels on firmware connection manager
Date: Thu, 17 Sep 2026 15:59:44 +0100
Message-ID: <20260917151540.476594018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a29cd07f51873..47e846dcceeb1 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -565,6 +565,11 @@ static int icm_fr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
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
@@ -1132,6 +1137,11 @@ static int icm_tr_approve_xdomain_paths(struct tb *tb, struct tb_xdomain *xd,
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
index ea4d5e63504f8..e61c809cc7769 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -2015,6 +2015,7 @@ struct tb_xdomain *tb_xdomain_alloc(struct tb *tb, struct device *parent,
 	INIT_DELAYED_WORK(&xd->state_work, tb_xdomain_state_work);
 	INIT_DELAYED_WORK(&xd->properties_changed_work,
 			  tb_xdomain_properties_changed);
+	atomic_set(&xd->ntunnels, 0);
 
 	xd->local_uuid = kmemdup(local_uuid, sizeof(uuid_t), GFP_KERNEL);
 	if (!xd->local_uuid)
@@ -2288,9 +2289,15 @@ int tb_xdomain_enable_paths(struct tb_xdomain *xd, int transmit_path,
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
 
@@ -2313,9 +2320,15 @@ int tb_xdomain_disable_paths(struct tb_xdomain *xd, int transmit_path,
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
index 4ef9c43026569..aa218c4d15a02 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -223,6 +223,7 @@ enum tb_link_width {
  *				changed notification
  * @bonding_possible: True if lane bonding is possible on local side
  * @target_link_width: Target link width from the remote host
+ * @ntunnels: Keeps track of how many tunnels go through this XDomain
  * @link: Root switch link the remote domain is connected (ICM only)
  * @depth: Depth in the chain the remote domain is connected (ICM only)
  *
@@ -269,6 +270,7 @@ struct tb_xdomain {
 	int properties_changed_retries;
 	bool bonding_possible;
 	u8 target_link_width;
+	atomic_t ntunnels;
 	u8 link;
 	u8 depth;
 };
-- 
2.53.0



