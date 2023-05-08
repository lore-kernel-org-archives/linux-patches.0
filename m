Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABE3168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E0EC433D2;
	Mon,  8 May 2023 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544573;
	bh=HYG0zAPTt7XmBrbwIywNUL5DsNgcETV14du3TNuch+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SayL/futve+rje70jJ6fwpO3fI6Y5XQlkXB8h+kjSY+aLmPqvEhnDgTx5YjGznfP1
	 bKeZXjlghBGwccyGuYpoFNjJQpFLpsfH4QTkVAsfbLddRQ2gkqDZye3IpAO9CjH1QE
	 imIi9bsZ5p7xqQUf3zmk328hOw+0qwOuzKqdaJHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 454/694] wifi: iwlwifi: fw: fix memory leak in debugfs
Date: Mon,  8 May 2023 11:44:49 +0200
Message-Id: <20230508094448.336196311@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3d90d2f4a018fe8cfd65068bc6350b6222be4852 ]

Fix a memory leak that occurs when reading the fw_info
file all the way, since we return NULL indicating no
more data, but don't free the status tracking object.

Fixes: 36dfe9ac6e8b ("iwlwifi: dump api version in yaml format")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230418122405.239e501b3b8d.I4268f87809ef91209cbcd748eee0863195e70fa2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 43e997283db0f..607e07ed2477c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -317,8 +317,10 @@ static void *iwl_dbgfs_fw_info_seq_next(struct seq_file *seq,
 	const struct iwl_fw *fw = priv->fwrt->fw;
 
 	*pos = ++state->pos;
-	if (*pos >= fw->ucode_capa.n_cmd_versions)
+	if (*pos >= fw->ucode_capa.n_cmd_versions) {
+		kfree(state);
 		return NULL;
+	}
 
 	return state;
 }
-- 
2.39.2



