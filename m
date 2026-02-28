Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2A313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301113; cv=none; b=D9aAJ1KmPl7QxzLW88tQmjRlc63tetJWdHofeh1rPtkeeWxoVdOyGY3fF1NtzFdDs4MeTvY10fJMORt2BOoiu8L62qSyD/Qt78LlrCr11gQaz/IGh9HtL/MyuQCmwnUlEy41MoUHLNFCzZRQW2EIAFKVt5oWVsfLDfeoFifpTyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301113; c=relaxed/simple;
	bh=LA3/TqVyfM6rXtgOiZo+UUq4qe5bn3h1BzNRYOGH/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZgtzKHSp85onodbrUlbfBw2BVSqTeiprQbOM9ffScmDDd4hqMt9gxRMq6qBaxfIuNMWjXc81l1zKofRXYzbYYLGxzVx4x+M0z4We5Scfh/Ct1alPf1LTDkey3a+zgaG5kt1ePgz69DH0ypi3FfTD3u+Klt0+Ta3eddgpp2RkXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3XYiU2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3XYiU2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5B5C19423;
	Sat, 28 Feb 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301113;
	bh=LA3/TqVyfM6rXtgOiZo+UUq4qe5bn3h1BzNRYOGH/Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3XYiU2WQGO/+Zl+ssmteM/Uorive/15cowPX5/NtwOu5gVb7r2Mcwn/WK6KFYGd0
	 /8RMF5R/XIZUJKqlcnggaYBQToYaSsUKHEznc2RltqsnQ9huXK4lbJzynSALazjf4N
	 qP9P+fOeEptdt5trmry3is7fOd0+HXHtIRq9Najaa3LqtYE0rJhzzLw9yXohjV2zQD
	 3N7UImjTGIV0AvyiGWiWVrPKiZ8wWckSuO9773yq+3cfeBX8i3pOvliRHwt/+ks5Im
	 gjlsl3TADB7Yq/YC5JhD3goxoskKqlZAnj1t9DRCmNKt/9ov7mFxpfip8lCgeEtpOd
	 vkNwTaR7hkyVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 269/752] wifi: iwlegacy: add missing mutex protection in il4965_store_tx_power()
Date: Sat, 28 Feb 2026 12:39:40 -0500
Message-ID: <20260228174750.1542406-269-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit e31fa691d0b1c07b6094a6cf0cce894192c462b3 ]

il4965_store_tx_power() calls il_set_tx_power() without holding il->mutex.
However, il_set_tx_power() has lockdep_assert_held(&il->mutex) indicating
that callers must hold this lock.

All other callers of il_set_tx_power() properly acquire the mutex:
- il_bg_scan_completed() acquires mutex at common.c:1683
- il_mac_config() acquires mutex at common.c:5006
- il3945_commit_rxon() and il4965_commit_rxon() are called via work
  queues that hold the mutex (like il4965_bg_alive_start)

Add mutex_lock()/mutex_unlock() around the il_set_tx_power() call in
the sysfs store function to fix the missing lock protection.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260125194039.1196488-1-n7l8m4@u.northwestern.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 3588dec75ebdd..57fa866efd9f8 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4606,7 +4606,9 @@ il4965_store_tx_power(struct device *d, struct device_attribute *attr,
 	if (ret)
 		IL_INFO("%s is not in decimal form.\n", buf);
 	else {
+		mutex_lock(&il->mutex);
 		ret = il_set_tx_power(il, val, false);
+		mutex_unlock(&il->mutex);
 		if (ret)
 			IL_ERR("failed setting tx power (0x%08x).\n", ret);
 		else
-- 
2.51.0

