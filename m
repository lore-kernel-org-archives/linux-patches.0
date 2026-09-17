Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9191151C043;
	Thu, 17 Sep 2026 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664982; cv=none; b=QkqlgBFxywlwCXMPi/fejiLaZCBLydvllY2Ciyytd1oustHxM9sWAZf7tH+MAit2QU62HcPt6O4NhZfvdL8GfNCCCy4FLFNEKPB8gD1cwVftqoPWVuNHfaRedu5RadJrMrc5u9eDCJ69uVMMXKu9jkUsGIV/xh1c57q2uF2POQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664982; c=relaxed/simple;
	bh=o3t3EcIpjBrC2TT16qZsJJ0hWuP/DRSLmjQUvazcxuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJQKw4AOmmWLnZA6ZMcdL+TfiOZ1WauOS0v1MjLv4im37hmXYSRaNjtAgnP7BvafakFKTuUyb9YQi6yKauSTIz6tPe1oTDOwoTgMTcn7wPnv/OEiiAqqf8NpyDzETHl9qdxM6jH+k7xcVOobTrUPj9gQ6n363Zb4VPS1L2D5P0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7XjsqfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7XjsqfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB9E1F000FF;
	Thu, 17 Sep 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664981;
	bh=dqVYZszc2sQDGR0eUvSyzI/vdcDe0AvVyy/1jaZ6VkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7XjsqfKAFhdzcIRHKcm3m0Wsbt4BWIdaXxEIo1d+WnLJcNWN8xvm+CKpFMl7t6Ae
	 LWbyX4+3x+pO85DnAF/Um3XQPm6PVsY31PBJt4jVHv+BVo0x9jiEyRN3pZEP4o9wAj
	 z0iF/PkeQHfWumU9LGpp1cHqPhxWnKmABK60cgFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0516/1250] wifi: iwlwifi: mvm: validate sta_id in BA window status notif
Date: Thu, 17 Sep 2026 16:05:11 +0100
Message-ID: <20260917151605.938833243@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 6aa77efaea9efea92e3090c35ad348fd759a3cf3 ]

BA_WINDOW_STATUS_NOTIFICATION_ID extracts a 5-bit sta_id from the
firmware notification and uses it to index fw_id_to_mac_id[] without
bounds checking. Validate sta_id before array access to prevent
out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.2e97f337f3cb.Ic3f0f404082ccdea13809a3c0b70e0f5417e1037@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 8c1bb3a7ffcaa..1e6d06bb674c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -1224,6 +1224,11 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 		/* get the station */
 		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
 			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		if (IWL_FW_CHECK(mvm,
+				 sta_id >= mvm->fw->ucode_capa.num_stations,
+				 "Invalid sta id (%d) in BA window status notification\n",
+				 sta_id))
+			continue;
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-- 
2.53.0



