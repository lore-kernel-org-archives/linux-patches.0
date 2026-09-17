Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5C515884;
	Thu, 17 Sep 2026 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664092; cv=none; b=ObAT+0eDTuJ6d9o+CpH6jzAfTX5YCUBfy0vGAhb/RfycBQYn4SUYrOas5ZQZVFMVc0+c7V2uCSsUNRbmYBTKfoUQ3o92jE+jTeFc/RTMqsWSwsRNkb2uTdOd2g+L0sECqn2FPeKfZ8QJF03tZXS2WM1IWgt5vbnboHE2Nh9jmSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664092; c=relaxed/simple;
	bh=Ej6tKTqaYAGZ2x16rT8GABvbji0Kd/yOYT6L43i0w0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijKfwVzRoH+z0ngrpar5aSBXliGtO64Q2D6tSAvuuFLm9xzCgqLTcRuheMak+NrtGClbqcJSe2I6IQbRt1IU6hYJ8KR8EE/XiPw2EuQiMbPLtASvsSTVAQThMPBIBWen8XtZCMFUCGh183iWXh1gAy1oWEc2NMdwWc/s49rb9nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY2hR5ew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY2hR5ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8DA1F000FF;
	Thu, 17 Sep 2026 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664090;
	bh=wWB0m7ne0BvuQqToI16zJFDSO6NS7jZDZy52BMOU4h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY2hR5ew1099U3GJKQ+qRr8NeFHFvSkTOdQ/8yc9/Z/QgOaLJMeC6EFdcrX0ZqGgz
	 Ung3xHfuiBm+zm9LGaVxnKU/tnz1vAAq1Ch4SnV79+0rx6A1ySDtYPqwXqjeC/e0Xk
	 n/8Ljf/+5BZTI00nc4uf+GtJjr+U7TSOCWiNSC7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0218/1250] wifi: iwlwifi: mld: purge async notifications upon nic error
Date: Thu, 17 Sep 2026 16:00:13 +0100
Message-ID: <20260917151558.044222175@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit a40ad60a47f7c904b75a9ff83b39edebf3961c85 ]

This fixes a kernel panic in reconfig failure:

1. we have a BSS connection
2. we have a NAN connection
3. FW error occurs
4. reconfig restores the BSS connection
5. however, restoring the NAN connection fails due to a FW error.
6. erroneously, ieee80211_handle_reconfig_failure is called and marks all
   interfaces as not-in-driver (will be fixed in a different patch).
7. mac80211 frees the links of the BSS connection but doesn't tell the
   driver about that, as it thinks that this vif is not in the driver.
8. in ieee80211_stop_device, *ALL* wiphy works are getting flushed
   (erroneously?)
9. Therefore, async_handlers_wk is being executed, processing the
   statistics notification that was received after we restored the BSS
   connection.
10. the notification handler dereferences fw_id_to_bss_conf[id], which is
    now a dangling pointer, as mac80211 already freed this link in (7).
11. On the first access to one of the links fields, we panic.

While this can and should be fixed by removing the call to
ieee80211_handle_reconfig_failure in (6), it is also not a good idea to
carry and maybe handle notifications from a dead FW.

We do purge the notifications when we stop the FW, but in reconfig
failure we stop the FW too late, after the notifications are processed.
In addition, async_handlers_wk can always be scheduled before the
reconfig work.

Purge the notifications immediately when transport notifies about a nic
error.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260517100550.4414228bf1d1.I1926a2b2e7827eaac22882699880ec04a3cb95f0@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 48b8ec6a5a12d..49e46babf8221 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -670,6 +670,15 @@ iwl_mld_nic_error(struct iwl_op_mode *op_mode,
 	if (type != IWL_ERR_TYPE_RESET_HS_TIMEOUT &&
 	    mld->fw_status.running)
 		mld->fw_status.in_hw_restart = true;
+
+	/* FW is dead. We don't want to process its notifications.
+	 * Right, we cancel them also in iwl_mld_stop_fw, but
+	 * iwl_mld_async_handlers_wk might be executed before
+	 * ieee80211_restart_work.
+	 * In addition, in case of an error during recovery,
+	 * iwl_mld_stop_fw might be too late.
+	 */
+	iwl_mld_cancel_async_notifications(mld);
 }
 
 static void iwl_mld_dump_error(struct iwl_op_mode *op_mode,
-- 
2.53.0



