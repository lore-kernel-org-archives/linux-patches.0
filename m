Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CE6313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301114; cv=none; b=CRXXnOwYLdh2Rkfb0ZBrQEPa2XjnAGffmUIJg3LlaEFNk73PqcDihGGidiHZZ1gXch4dL7UmtVgOSuT+nXWTM+IIvEinnDiEM/YGKMhOOAzg6wetHmZB3BTQkF1GJFCpfeBB2gQ/6F2LZa4qMXHliR1LV6UiXekd5cFab1vtEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301114; c=relaxed/simple;
	bh=xRWtLbm0zjBdLRyDSj+VAA8imS9R2w3IqEL1uvlgr3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ7cjo5OYO2Q2Cxvr2QsuFVG2d/PLX50/KDRN0QC3nnY50jEjAJ7LKBZfwdsYZPV1B9YFknyQsHm8x6jL1MRYXpBIl8WWGWh9iI1NPdTF1u2k2htNcEmbg9Ulyp8meB2j1TiKjpiOkHHHt1DjCGhDQ8+I3oTjI7Ah47wVB54SgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0eVsFzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0eVsFzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF3BC19424;
	Sat, 28 Feb 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301114;
	bh=xRWtLbm0zjBdLRyDSj+VAA8imS9R2w3IqEL1uvlgr3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0eVsFzVUJyWqGz1HnNMEuzSRKZI30fl1NRALsQ8/lf660fvBOtvsmHJmK1dbQDIA
	 hS7t9mMip73ivBaqNnv0FTiAALvcwoyrVE1yhFo+zekh4Gdueeuf8rtcfal7p8sSj+
	 FJXoNX0dC8GUtPC8TmPOUPVydJDVx6Z3F7IGGXkMgKc2yhPqpT/8lZ9JXPcKOdb4h4
	 zLM5+QZh2EPVgXbGb4ILIakCzFmWzAKdxrkQ3LGSntQQnBK6xkzFrJ5zuV0finPg/6
	 UbTTufqmkEzQRwjtSm0X/GcyBDqozzMRhfzN3LGJJn9sfVFEWI4G7B023oELdvsFmX
	 6N+pbY6HRFf5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/752] wifi: iwlegacy: add missing mutex protection in il3945_store_measurement()
Date: Sat, 28 Feb 2026 12:39:41 -0500
Message-ID: <20260228174750.1542406-270-sashal@kernel.org>
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

[ Upstream commit 4dd1dda65265ecbc9f43ffc08e333684cf715152 ]

il3945_store_measurement() calls il3945_get_measurement() which internally
calls il_send_cmd_sync() without holding il->mutex. However,
il_send_cmd_sync() has lockdep_assert_held(&il->mutex) indicating that
callers must hold this lock.

Other sysfs store functions in the same file properly acquire the mutex:
- il3945_store_flags() acquires mutex at 3945-mac.c:3110
- il3945_store_filter_flags() acquires mutex at 3945-mac.c:3144

Add mutex_lock()/mutex_unlock() around the il3945_get_measurement() call
in the sysfs store function to fix the missing lock protection.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260125193005.1090429-1-n7l8m4@u.northwestern.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 104748fcdc33e..54991f31c52c5 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3224,7 +3224,9 @@ il3945_store_measurement(struct device *d, struct device_attribute *attr,
 
 	D_INFO("Invoking measurement of type %d on " "channel %d (for '%s')\n",
 	       type, params.channel, buf);
+	mutex_lock(&il->mutex);
 	il3945_get_measurement(il, &params, type);
+	mutex_unlock(&il->mutex);
 
 	return count;
 }
-- 
2.51.0

