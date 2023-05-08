Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F220171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E335BC433EF;
	Mon,  8 May 2023 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546051;
	bh=9yrgSzytMt4Da6JiTfxy64+/1fjD6REwiipXktbovRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umRGJ59OuE/djcw1qe6ZyibiohG+EPIrblxyFl7nrusE7GvwyKJcGORg9mcjDU6Qz
	 77AzMm/UaOeNpYiSfOqtM5urJr2oPg+y+KT7Y7h3apU+9Cly3z3uAXTlE81YnS3F+e
	 bHAYxEtm9QYU2UtRv1+EMUROjXVjBZOq3Ctk0qCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/371] wifi: iwlwifi: fw: fix memory leak in debugfs
Date: Mon,  8 May 2023 11:47:04 +0200
Message-Id: <20230508094820.912093289@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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
index a152ce3064759..e372f935f6983 100644
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



