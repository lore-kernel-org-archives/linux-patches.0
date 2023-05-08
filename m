Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C24168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32449C4339B;
	Mon,  8 May 2023 11:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544418;
	bh=7s6nLrd7Rg4SxtnjNHP1yAVA8p2WP9eW/AREPcfw2HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBzhuDLeXnF88wYRUcHaGswTqs/gHBR9LO1st4Ls27HP6s09bgk4w14zPWdIdgk7/
	 T7nty1lHjgdDqEFaFKXTfSvYYTiSYD5Sx282mq+Eb5fbb0ckoV6fn3ZIriXdRvPq1O
	 6n07rdul0mBT4+mJ8nU6LZ6OhYUsJZjOs9+oPzew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 403/694] nvmet: fix Identify Controller handling
Date: Mon,  8 May 2023 11:43:58 +0200
Message-Id: <20230508094446.256813930@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 62904b3b333e7f3c0f879dc3513295eee5765c9f ]

The identify command with cns set to NVME_ID_CNS_CTRL does not depend on
the command set. The execution of this command should thus not look at
the csi specified in the command. Simplify nvmet_execute_identify() to
directly call nvmet_execute_identify_ctrl() without the csi switch-case.

Fixes: ab5d0b38c047 ("nvmet: add Command Set Identifier support")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index a982f925dfcef..a747c69074daf 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -705,11 +705,8 @@ static void nvmet_execute_identify(struct nvmet_req *req)
 		}
 		break;
 	case NVME_ID_CNS_CTRL:
-		switch (req->cmd->identify.csi) {
-		case NVME_CSI_NVM:
-			return nvmet_execute_identify_ctrl(req);
-		}
-		break;
+		nvmet_execute_identify_ctrl(req);
+		return;
 	case NVME_ID_CNS_CS_CTRL:
 		if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
 			switch (req->cmd->identify.csi) {
-- 
2.39.2



