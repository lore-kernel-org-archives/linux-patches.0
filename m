Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB815A84C;
	Mon, 27 May 2024 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837317; cv=none; b=R+enr8UMv5Z7oEiVhvIi7eHMREhbTr8iXcAEG8ZRmBuqdw9UvxkpBZJ5bJF0ia7Mvxe2WGWG6vUav2GphcrWToxsGoS+5b33QRbAw+w9cKlYppOFyVDeVU1V0Cwh1mwS8d5SDlTGT4Hl4RUdppO2kFtCprOKyJufYuvR8TK0lh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837317; c=relaxed/simple;
	bh=EGH5lnpGATZXcU0LhXM91g/Al+2vgySLV4m3sU/p1QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paL78S96bQPdM5nA9dJqS+kPSYtbwMdJ78jCUKVw/Y5UUt+WlUx5kLiC71IsTZFUXPFqq+9Ac+484GMULZYgt/HYWkxafNJYDQ8HuqRYXtnugSq7h5KmqXkJmE37jExjJ8fv2XAPTpVvIO4UsxxULCqNNVmLs4JrpckVR3bwWF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFANVcF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFANVcF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A31AC2BBFC;
	Mon, 27 May 2024 19:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837316;
	bh=EGH5lnpGATZXcU0LhXM91g/Al+2vgySLV4m3sU/p1QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFANVcF+CnY29eJBGjYsLL/qxk9fNuSQbmSFtCVt+iadOXqsh/T4AWIHSxc3CBEXz
	 W+GaiSqBSocz1dckBj/j2eTbrdbYvK1sJrSvA62M6Eym7MxG/TSt6lj6T2Idut7zxV
	 8Hu01uA1jRE16j9fXJAksDJ+BNYp1r/dvP2xCizw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 393/427] dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths
Date: Mon, 27 May 2024 20:57:20 +0200
Message-ID: <20240527185634.885249095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 6f6544f27e41f9d7dca55c288f12175a9c48dfe2 ]

Commit c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local
rwsem") aimed to undo device_lock() abuses for protecting changes to
dax-driver internal data-structures like the dax_region resource tree to
device-dax-instance range structures.  However, the device_lock() was
legitimately enforcing that devices to be deleted were not current
actively attached to any driver nor assigned any capacity from the region.

As a result of the device_lock restoration in delete_store(), the
conditional locking in unregister_dev_dax() and unregister_dax_mapping()
can be removed.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-2-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 42 ++++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 7924dd542a139..e2c7354ce3281 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -465,26 +465,17 @@ static void free_dev_dax_ranges(struct dev_dax *dev_dax)
 		trim_dev_dax_range(dev_dax);
 }
 
-static void __unregister_dev_dax(void *dev)
+static void unregister_dev_dax(void *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	down_write(&dax_region_rwsem);
 	kill_dev_dax(dev_dax);
 	device_del(dev);
 	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
-}
-
-static void unregister_dev_dax(void *dev)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dev_dax(dev);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dev_dax(dev);
 	up_write(&dax_region_rwsem);
 }
 
@@ -560,15 +551,10 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 	if (!victim)
 		return -ENXIO;
 
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return rc;
-	rc = down_write_killable(&dax_dev_rwsem);
-	if (rc) {
-		up_write(&dax_region_rwsem);
-		return rc;
-	}
+	device_lock(dev);
+	device_lock(victim);
 	dev_dax = to_dev_dax(victim);
+	down_write(&dax_dev_rwsem);
 	if (victim->driver || dev_dax_size(dev_dax))
 		rc = -EBUSY;
 	else {
@@ -589,11 +575,12 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 			rc = -EBUSY;
 	}
 	up_write(&dax_dev_rwsem);
+	device_unlock(victim);
 
 	/* won the race to invalidate the device, clean it up */
 	if (do_del)
 		devm_release_action(dev, unregister_dev_dax, victim);
-	up_write(&dax_region_rwsem);
+	device_unlock(dev);
 	put_device(victim);
 
 	return rc;
@@ -705,7 +692,7 @@ static void dax_mapping_release(struct device *dev)
 	put_device(parent);
 }
 
-static void __unregister_dax_mapping(void *data)
+static void unregister_dax_mapping(void *data)
 {
 	struct device *dev = data;
 	struct dax_mapping *mapping = to_dax_mapping(dev);
@@ -713,25 +700,12 @@ static void __unregister_dax_mapping(void *data)
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	lockdep_assert_held_write(&dax_region_rwsem);
-
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
 
 	device_unregister(dev);
 }
 
-static void unregister_dax_mapping(void *data)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dax_mapping(data);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dax_mapping(data);
-	up_write(&dax_region_rwsem);
-}
-
 static struct dev_dax_range *get_dax_range(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);
-- 
2.43.0



