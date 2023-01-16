Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F133F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A03DC433D2;
	Mon, 16 Jan 2023 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886064;
	bh=RZPOWwW3g55eJMWY/8lEuTBpJEo5pwfWAf9VVlp7k+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOJczZ/sdup3ebc7zBQA2o29Brkge0xRME0HfL+uGwKbDlR0KXRsiEBTpX+s6gxw6
	 TkTuc4UDHBhv+4cbUu5eIkfpguKTLFa2isxY1ccgXtXzWC65GPxWwpKdKtZMpwfPUB
	 ItJLXApnBm2ENNi8cfO8ti9AGDEtunvMGy0J8vIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 259/658] scsi: hpsa: Fix error handling in hpsa_add_sas_host()
Date: Mon, 16 Jan 2023 16:45:47 +0100
Message-Id: <20230116154921.430523998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4ef174a3ad9b5d73c1b6573e244ebba2b0d86eac ]

hpsa_sas_port_add_phy() does:
  ...
  sas_phy_add()  -> may return error here
  sas_port_add_phy()
  ...

Whereas hpsa_free_sas_phy() does:
  ...
  sas_port_delete_phy()
  sas_phy_delete()
  ...

If hpsa_sas_port_add_phy() returns an error, hpsa_free_sas_phy() can not be
called to free the memory because the port and the phy have not been added
yet.

Replace hpsa_free_sas_phy() with sas_phy_free() and kfree() to avoid kernel
crash in this case.

Fixes: d04e62b9d63a ("hpsa: add in sas transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221110151129.394389-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 88dc42fdaa80..9d5d0c911130 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9763,7 +9763,8 @@ static int hpsa_add_sas_host(struct ctlr_info *h)
 	return 0;
 
 free_sas_phy:
-	hpsa_free_sas_phy(hpsa_sas_phy);
+	sas_phy_free(hpsa_sas_phy->phy);
+	kfree(hpsa_sas_phy);
 free_sas_port:
 	hpsa_free_sas_port(hpsa_sas_port);
 free_sas_node:
-- 
2.35.1



