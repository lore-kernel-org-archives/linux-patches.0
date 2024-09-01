Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0CC17B50B;
	Sun,  1 Sep 2024 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210014; cv=none; b=tymfWEJEANUA9YURpvTqWct4C+PJoehMAcuKbKWY7eIHAl9E/ZYeMuF3+JtVhWIZtVZqs8PKRHoeVTNOtnuE6OUNOt4/4LfC97sgE6o/XDCBzXa5/SDNhS/Ey4OzXitoW9pp9z03vptbNgd3diQevTtRJtd9wlejt6MKot1bY6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210014; c=relaxed/simple;
	bh=Ga9XYBiPlvnjH+3ItzQkp9/frPS4zjcs5JgICdZjLUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krrmaEjavK5OLX73ZgxDYikaiPLsl1WqLNv9Z03prYMoDCXoXPor2Z6S10jFsnu6lp67mNpV54cPp3IdCO8TpCccD7Yb++L2a3NyKiN7NJOQDRUj4cMQOTkgJvBNweNPYuxns7B2vC6mKqSYlX4b2h4cVbhnHxY4pVc44e84fyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lALrrYOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lALrrYOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91124C4CEC3;
	Sun,  1 Sep 2024 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210014;
	bh=Ga9XYBiPlvnjH+3ItzQkp9/frPS4zjcs5JgICdZjLUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lALrrYOfERovj/CGexAlyuCaAlWzB75S1ERxlpg3elzsXN/9P+MxejElr5BbGAPOh
	 C3/NqhxFXwOo7ca+d3af961lCHEOve4KvjEGbGjgB39S76iW/AbG0XBsUfqa6eyGqR
	 vyEz9jFYyUofXkCebjYORdxTMy9iA/WVu6A9AzaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/215] wifi: iwlwifi: fw: Fix debugfs command sending
Date: Sun,  1 Sep 2024 18:16:13 +0200
Message-ID: <20240901160825.662251564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e372f935f6983..6419fbfec5aca 100644
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



