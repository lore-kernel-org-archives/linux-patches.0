Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB6DDC1;
	Tue, 27 Aug 2024 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770100; cv=none; b=gGPAKZvASBAfIjR/GG6bBp4slVf1wgUyKOaaUIvNt6NxgGPZ3jYuwRBBKF+Cn3TogpXr22uq0msB8ceNEL1UeKDF2UkWTBQuLiw6akFhcmVe+nqdjHF4mnU5oCjEB/PJ2XNDyqg9lQv36J01G1SqxcPZ35mBCGd1x5Xez42Hjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770100; c=relaxed/simple;
	bh=5JGCJNP9fyyO83Y1pU6IIdHu1LF1isQoUKT1v5buies=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrGYjwePXj3i8FBod06cqDiOv40t9QcGdMKfbWTPI2gnYs1Rbq16JgUFT2+4gC+Ri8Wmz3MyPL9/B7pX5WOF/wN3vHQ1TtMOCMeVnhdETE27AZl8LtjYZEO0F5GKgqqL9ZQpiFCej8dWPiMkjJmMZFSzwpW6z0w8FEoNgnoLdTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjd5mRfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjd5mRfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941FCC61047;
	Tue, 27 Aug 2024 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770100;
	bh=5JGCJNP9fyyO83Y1pU6IIdHu1LF1isQoUKT1v5buies=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjd5mRfA2IOkNPI0Tx0Q9xsc0pHXgojgTnGhHttkvWtFIzzqZ9g0mXwQa+AToql0H
	 ETtp7a5VsFO4gGoRVCMzQ6bqpGPQKau3W4GaMLW6l3Q44J5XKKuliUM/HDMitO+pPv
	 4FYkvp6HvQOteHwjbhN3dQEJUSVypRbHINRFlKwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/341] wifi: iwlwifi: fw: Fix debugfs command sending
Date: Tue, 27 Aug 2024 16:35:59 +0200
Message-ID: <20240827143848.287146671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cdbc6ac7ae5d..3356e36e2af73 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -141,7 +141,11 @@ static int iwl_dbgfs_enabled_severities_write(struct iwl_fw_runtime *fwrt,
 
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



