Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422092BF3E2;
	Thu, 28 May 2026 20:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000735; cv=none; b=edYluabKhj3K0FW/0ASQ2OfODCuAXR12dE4epSASSMuGVHOeGRVe8v4dvSLNat+BqQKymJ1zveFQrGBh660o9NFFTG+jAeeuDr2XgNPsIudGEkRVIKBD+mt71rVZePppos4UgzkITSxvZmXGRjkyZ1f/RayO4P/htok8zRcf/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000735; c=relaxed/simple;
	bh=vn6PzvzkdEmv3bvQDXT6zUc26yXCTPddpXEVQodFUA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwJYhy71tbwDcRqvgDoqCOYF7bvfipNESILK3lwYuRwXgW04bni/Oyyeh7/0ZidKJJx+6e2wXWnCJwTCCllr8Vc1Ub4EjIez5n0kD2ftFMmfFTzZMlJApHNkBmTTLyQsW8/Or5ys4hl/Kv4ush4LyhlBz5LPCZxlYKx/+OQ31aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOxA2N+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOxA2N+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD711F000E9;
	Thu, 28 May 2026 20:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000734;
	bh=3KQjGmZZcGNrGU8kcItdPXGxo2/aOb2AJiiFqCtdZCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOxA2N+UDmdYfPLoTU5h8nLHicb613v36FrUpS25mGRIxfUAHQE5qJVxVNokrMqFc
	 TeZHSP4A+gokK5BfPuRaUOgHBYkG7WrrJ6zRTgRFjCibaxKuwNgrFnaVO/6DCtkpjD
	 9F/R38hQ0YpBihLe5OKK6mG3LRSh4/Z0S6ZHDk2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/272] firmware: arm_ffa: Unregister the FF-A devices when cleaning up the partitions
Date: Thu, 28 May 2026 21:48:44 +0200
Message-ID: <20260528194633.569115040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 46dcd68aaccac0812c12ec3f4e59c8963e2760ad ]

Both the FF-A core and the bus were in a single module before the
commit 18c250bd7ed0 ("firmware: arm_ffa: Split bus and driver into distinct modules").

The arm_ffa_bus_exit() takes care of unregistering all the FF-A devices.
Now that there are 2 distinct modules, if the core driver is unloaded and
reloaded, it will end up adding duplicate FF-A devices as the previously
registered devices weren't unregistered when we cleaned up the modules.

Fix the same by unregistering all the FF-A devices on the FF-A bus during
the cleaning up of the partitions and hence the cleanup of the module.

Fixes: 18c250bd7ed0 ("firmware: arm_ffa: Split bus and driver into distinct modules")
Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-8-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 6d3daa9b8d31 ("firmware: arm_ffa: Unregister bus notifier on teardown for FF-A v1.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c    | 3 ++-
 drivers/firmware/arm_ffa/driver.c | 7 ++++---
 include/linux/arm_ffa.h           | 3 +++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index ef41815c0109e..50bbc18599f74 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -162,11 +162,12 @@ static int __ffa_devices_unregister(struct device *dev, void *data)
 	return 0;
 }
 
-static void ffa_devices_unregister(void)
+void ffa_devices_unregister(void)
 {
 	bus_for_each_dev(&ffa_bus_type, NULL, NULL,
 			 __ffa_devices_unregister);
 }
+EXPORT_SYMBOL_GPL(ffa_devices_unregister);
 
 bool ffa_device_is_valid(struct ffa_device *ffa_dev)
 {
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 84c4fe40d5279..63030a3849a87 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1492,10 +1492,8 @@ static int ffa_setup_partitions(void)
 
 	/* Allocate for the host */
 	ret = ffa_xa_add_partition_info(drv_info->vm_id);
-	if (ret) {
-		/* Already registered devices are freed on bus_exit */
+	if (ret)
 		ffa_partitions_cleanup();
-	}
 
 	return ret;
 }
@@ -1505,6 +1503,9 @@ static void ffa_partitions_cleanup(void)
 	struct ffa_dev_part_info *info;
 	unsigned long idx;
 
+	/* Clean up/free all registered devices */
+	ffa_devices_unregister();
+
 	xa_for_each(&drv_info->partition_info, idx, info) {
 		xa_erase(&drv_info->partition_info, idx);
 		kfree(info);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 74169dd0f6594..53f2837ce7df4 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -176,6 +176,7 @@ void ffa_device_unregister(struct ffa_device *ffa_dev);
 int ffa_driver_register(struct ffa_driver *driver, struct module *owner,
 			const char *mod_name);
 void ffa_driver_unregister(struct ffa_driver *driver);
+void ffa_devices_unregister(void);
 bool ffa_device_is_valid(struct ffa_device *ffa_dev);
 
 #else
@@ -188,6 +189,8 @@ ffa_device_register(const struct ffa_partition_info *part_info,
 
 static inline void ffa_device_unregister(struct ffa_device *dev) {}
 
+static inline void ffa_devices_unregister(void) {}
+
 static inline int
 ffa_driver_register(struct ffa_driver *driver, struct module *owner,
 		    const char *mod_name)
-- 
2.53.0



