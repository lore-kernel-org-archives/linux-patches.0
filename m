Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C38D171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A4C433D2;
	Mon,  8 May 2023 11:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545997;
	bh=KGUQS/DRWSp5iKNgxJTlWB6yjT1rySwd3LBm3XNJSJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYDWPQXC5hLFw3AfnD2YSCsyvjgQmMMYHvfxGaREVxrZpFY5tNQDMuOg8QD5ovQod
	 8bC2LDDBl+aGobQueeRKODmclo+gfsmluPdue5mxqcfUTl1fbdUtF/oJQ9OYOmf1RQ
	 kegRIMFqXgpO6uJ7qlkwxwZpkQ6a6EwQO+/padms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/371] nvmet: fix Identify Namespace handling
Date: Mon,  8 May 2023 11:46:35 +0200
Message-Id: <20230508094819.816646941@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 8c098aa00118c35108f0c19bd3cdc45e11574948 ]

The identify command with cns set to NVME_ID_CNS_NS does not directly
depend on the command set. The NVMe specifications is rather confusing
here as it appears that this command only applies to the NVM command
set. However, footnote 8 of Figure 273 in the NVMe 2.0 base
specifications clearly state that this command applies to NVM command
sets that support logical blocks, that is, NVM and ZNS. Both the NVM and
ZNS command set specifications also list this identify as mandatory.

The command handling should thus not look at the csi field since it is
defined as unused for this command. Given that we do not support the
KV command set, simply remove the csi switch-case for that command
handling and call directly nvmet_execute_identify_ns() in
nvmet_execute_identify().

Fixes: ab5d0b38c047 ("nvmet: add Command Set Identifier support")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index da873a7f8ff90..4911de26d7343 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -687,13 +687,8 @@ static void nvmet_execute_identify(struct nvmet_req *req)
 
 	switch (req->cmd->identify.cns) {
 	case NVME_ID_CNS_NS:
-		switch (req->cmd->identify.csi) {
-		case NVME_CSI_NVM:
-			return nvmet_execute_identify_ns(req);
-		default:
-			break;
-		}
-		break;
+		nvmet_execute_identify_ns(req);
+		return;
 	case NVME_ID_CNS_CS_NS:
 		if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
 			switch (req->cmd->identify.csi) {
-- 
2.39.2



