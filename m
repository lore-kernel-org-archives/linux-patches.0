Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A82D9792;
	Sat, 12 Sep 2026 19:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239777; cv=none; b=HK2ZZzXO81LP8kmDRjhio3h7ECAcMjfCYrk7bw6vQmR8GYi5KhiVEckMCMmhUbwCgEt9emOiJmCmn3cV+WlTu03V0wo8FI3yAReQ82n85AJPKAfhHhoF4/Z/EZFAblxZrWh3+uk46A7WZE3/QxjzBeVWPEDzgm3PKQRxeK0j6ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239777; c=relaxed/simple;
	bh=HKLQY9NM3C7RLKCBvO6FkfDCPDqCW9eyJGs768IA9GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZmSP+ntMnEdVfRXXoY32c63Vo5eVKkwZDjEZr11HTVKPg2it3qq56LDYAucmxgWrrYD2NYdYOLAwpaNPKRDtlfT9ImL5vXydxzRJ2IKtQsfcK6I9b3xzbZKkxAfNsP+9kjbHjSKX8Q+XO0txKBepFUK5d213SPmhc80GwC+XRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYAOQRZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYAOQRZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214B61F000FF;
	Sat, 12 Sep 2026 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239776;
	bh=qYLHgmgYZtRWI0SJqAwIKpkkiPYHx7HvBFxT75a8y90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYAOQRZkyxB4PljpcOGYHeuaflXEAbR4Y26S6NPCUKnOXjpSnwk4a8+l1sz3qTECy
	 iXRhcSK/7gcDx9DFK+HbV9J0ALyY/N/SVqdQahsv2o7yesnKgJ48RTfEpCAgQwrErL
	 0vQbzdsCbmRAlZ7eQ+5x0PynAuwTY09CY/oUPuuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Tianfei zhang <tianfei.zhang@intel.com>,
	Matthew Gerlach <matthew.gerlach@linux.intel.com>,
	Russ Weight <russell.h.weight@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 734/935] firmware_loader: Check fw_state_is_done in loading_store
Date: Sat, 12 Sep 2026 09:02:44 +0200
Message-ID: <20260912065543.667620097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Weight <russell.h.weight@intel.com>

[ Upstream commit 736da0b657f615db7e29606eb8818871534a8943 ]

Rename fw_sysfs_done() and fw_sysfs_loading() to fw_state_is_done() and
fw_state_is_loading() respectively, and place them along side companion
functions in drivers/base/firmware_loader/firmware.h.

Use the fw_state_is_done() function to exit early from
firmware_loading_store() if the state is already "done". This is being done
in preparation for supporting persistent sysfs nodes to allow userspace to
upload firmware to a device, potentially reusing the sysfs loading and data
files multiple times.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Tianfei zhang <tianfei.zhang@intel.com>
Tested-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Link: https://lore.kernel.org/r/20220421212204.36052-3-russell.h.weight@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b48373c90195 ("firmware_loader: do not queue completed sysfs fallback requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 28 +++++++------------------
 drivers/base/firmware_loader/firmware.h | 10 +++++++++
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index d7d63c1aa993f..c743466a410cb 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -58,16 +58,6 @@ static long firmware_loading_timeout(void)
 		__firmware_loading_timeout() * HZ : MAX_JIFFY_OFFSET;
 }
 
-static inline bool fw_sysfs_done(struct fw_priv *fw_priv)
-{
-	return __fw_state_check(fw_priv, FW_STATUS_DONE);
-}
-
-static inline bool fw_sysfs_loading(struct fw_priv *fw_priv)
-{
-	return __fw_state_check(fw_priv, FW_STATUS_LOADING);
-}
-
 static inline int fw_sysfs_wait_timeout(struct fw_priv *fw_priv,  long timeout)
 {
 	return __fw_state_wait_common(fw_priv, timeout);
@@ -91,7 +81,7 @@ static void __fw_load_abort(struct fw_priv *fw_priv)
 	 * There is a small window in which user can write to 'loading'
 	 * between loading done/aborted and disappearance of 'loading'
 	 */
-	if (fw_state_is_aborted(fw_priv) || fw_sysfs_done(fw_priv))
+	if (fw_state_is_aborted(fw_priv) || fw_state_is_done(fw_priv))
 		return;
 
 	fw_state_aborted(fw_priv);
@@ -215,7 +205,7 @@ static ssize_t firmware_loading_show(struct device *dev,
 
 	mutex_lock(&fw_lock);
 	if (fw_sysfs->fw_priv)
-		loading = fw_sysfs_loading(fw_sysfs->fw_priv);
+		loading = fw_state_is_loading(fw_sysfs->fw_priv);
 	mutex_unlock(&fw_lock);
 
 	return sysfs_emit(buf, "%d\n", loading);
@@ -245,19 +235,17 @@ static ssize_t firmware_loading_store(struct device *dev,
 
 	mutex_lock(&fw_lock);
 	fw_priv = fw_sysfs->fw_priv;
-	if (fw_state_is_aborted(fw_priv))
+	if (fw_state_is_aborted(fw_priv) || fw_state_is_done(fw_priv))
 		goto out;
 
 	switch (loading) {
 	case 1:
 		/* discarding any previous partial load */
-		if (!fw_sysfs_done(fw_priv)) {
-			fw_free_paged_buf(fw_priv);
-			fw_state_start(fw_priv);
-		}
+		fw_free_paged_buf(fw_priv);
+		fw_state_start(fw_priv);
 		break;
 	case 0:
-		if (fw_sysfs_loading(fw_priv)) {
+		if (fw_state_is_loading(fw_priv)) {
 			int rc;
 
 			/*
@@ -345,7 +333,7 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
 
 	mutex_lock(&fw_lock);
 	fw_priv = fw_sysfs->fw_priv;
-	if (!fw_priv || fw_sysfs_done(fw_priv)) {
+	if (!fw_priv || fw_state_is_done(fw_priv)) {
 		ret_count = -ENODEV;
 		goto out;
 	}
@@ -405,7 +393,7 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
 
 	mutex_lock(&fw_lock);
 	fw_priv = fw_sysfs->fw_priv;
-	if (!fw_priv || fw_sysfs_done(fw_priv)) {
+	if (!fw_priv || fw_state_is_done(fw_priv)) {
 		retval = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
index a3014e9e2c852..5d24f2cd19d29 100644
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -149,6 +149,16 @@ static inline void fw_state_done(struct fw_priv *fw_priv)
 	__fw_state_set(fw_priv, FW_STATUS_DONE);
 }
 
+static inline bool fw_state_is_done(struct fw_priv *fw_priv)
+{
+	return __fw_state_check(fw_priv, FW_STATUS_DONE);
+}
+
+static inline bool fw_state_is_loading(struct fw_priv *fw_priv)
+{
+	return __fw_state_check(fw_priv, FW_STATUS_LOADING);
+}
+
 int assign_fw(struct firmware *fw, struct device *device);
 
 #ifdef CONFIG_FW_LOADER_PAGED_BUF
-- 
2.53.0



