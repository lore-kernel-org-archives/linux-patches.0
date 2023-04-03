Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD555683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8080C433EF;
	Mon,  3 Apr 2023 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531439;
	bh=9qh1pJz0WQ3jG4cRKFgGtm8M/BEAgnGZ8Zz5cpBLCfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO/BxnjzOXTHHJPhY/FY/IvfqkQqnYjFrm4tcE4ZyzMy4/A8xCBg5foDR1tf5JfPK
	 5DH8DsQ031rEdrCbdRmfC1XyUV61m5uo4RgNDpt5cuiQbaWKqlCBBwPcDBZnBDtDfV
	 udtWZ6neGuhDFidTqd2XIT02qcwgWrXoczL72pCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/84] scsi: megaraid_sas: Fix crash after a double completion
Date: Mon,  3 Apr 2023 16:09:03 +0200
Message-Id: <20230403140355.568045696@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 2309df27111a51734cb9240b4d3c25f2f3c6ab06 ]

When a physical disk is attached directly "without JBOD MAP support" (see
megasas_get_tm_devhandle()) then there is no real error handling in the
driver.  Return FAILED instead of SUCCESS.

Fixes: 18365b138508 ("megaraid_sas: Task management support")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230324150134.14696-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bdb12bf0d5c75..b400167f9ad42 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4367,7 +4367,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4440,7 +4440,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-- 
2.39.2



