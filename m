Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949921C689C;
	Tue, 27 Aug 2024 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772290; cv=none; b=Y28UeB3ZhcTG0iNXtdctvBHlbOt6X1mgPH4FK91GkvR2r76CmbZ9e+SJMWcVEV/k6Mb8ufHqmGhgZdQhQhf5nsN/hoyusH383NKpDJuY6VT0u3t6BVeB+uf9A3bSW2tEvn0MuN2e3eE7+/yOI3+0Q+3LUaTGCHirSWr2gW7Da2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772290; c=relaxed/simple;
	bh=cLtwn3BVhUx32xL5LFOQSU2xm0evSJ0PIRfHxMzba4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOfX7vgyJYqY8XgSbtolzfs2AzZBF2p3JfNCSRyroh0RT8A95rJ/ZLwsNIFnO3on92t9CvCDaf8RjIMdkjxW2f8VsFSbaTcE+XuVQ8jX2uVkH5iXwCUSxs73bJd4CBO81Us4Jhxsh3dyXdi3H/oAEKPRAB7jDX0V3OSOS00ecfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiBTy9Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiBTy9Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011D3C61071;
	Tue, 27 Aug 2024 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772290;
	bh=cLtwn3BVhUx32xL5LFOQSU2xm0evSJ0PIRfHxMzba4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiBTy9UecmTuNyckDjPYYO424ce1PaM/XYrNzKLvR1a7aFiou+NYUcqye1sHGTQ5/
	 bgEbtX6XIuSmAl5NtKsXoP2YLTMNt5GcOO51A4kdwGszSllq6R84kuiHfA3AqfdjOq
	 KETwSC/7e9vE1yCnydKlXxYmGEqC46bNwHx+lBxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/321] wifi: iwlwifi: fw: Fix debugfs command sending
Date: Tue, 27 Aug 2024 16:37:27 +0200
Message-ID: <20240827143843.531739978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 048449fc666d736a1a17d950fde0b5c5c8fd10cc ]

During debugfs command handling transport function is used directly,
this bypasses the locking used by runtime operation function
and leads to a kernel warning when two commands are
sent in parallel.

Fix it by using runtime operations function when sending
debugfs command.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231004123422.4f80ac90658a.Ia1dfa1195c919f3002fe08db3eefbd2bfa921bbf@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 607e07ed2477c..7d4340c56628a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -163,7 +163,11 @@ static int iwl_dbgfs_enabled_severities_write(struct iwl_fw_runtime *fwrt,
 
 	event_cfg.enabled_severities = cpu_to_le32(enabled_severities);
 
-	ret = iwl_trans_send_cmd(fwrt->trans, &hcmd);
+	if (fwrt->ops && fwrt->ops->send_hcmd)
+		ret = fwrt->ops->send_hcmd(fwrt->ops_ctx, &hcmd);
+	else
+		ret = -EPERM;
+
 	IWL_INFO(fwrt,
 		 "sent host event cfg with enabled_severities: %u, ret: %d\n",
 		 enabled_severities, ret);
-- 
2.43.0



