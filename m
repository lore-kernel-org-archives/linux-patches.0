Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8E4C433D2;
	Mon, 30 Jan 2023 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087349;
	bh=U3azTgYrE328S2huq7Sl8qLwkjNklnwVXuDkI9kvEic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIl8Tf/wB63YiL9z287AjXojTV8EO/JqgDgSbyghfAkcDw6v6r9kP4bmFi4lErT+g
	 nJGVbvuGBlMeB1Phez7CAKWtJ7qI/N3U7zlgPnZfzhFjCwQvfe5gmCwwKoRl//668O
	 AQ76VLIRWFDA8gBVsunpXLMkvnJoDfB3n5m8CAz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/313] scsi: hisi_sas: Use abort task set to reset SAS disks when discovered
Date: Mon, 30 Jan 2023 14:50:14 +0100
Message-Id: <20230130134345.025453464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 037b48057e8b485a8d72f808122796aeadbbee32 ]

Currently clear task set is used to abort all commands remaining in the
disk when the SAS disk is discovered, and if the disk is discovered by two
initiators, other I_T nexuses are also affected. So use abort task set
instead and take effect only on the specified I_T nexus.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 699b07abb6b0..34870b3286ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -714,7 +714,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		int_to_scsilun(0, &lun);
 
 		while (retry-- > 0) {
-			rc = sas_clear_task_set(device, lun.scsi_lun);
+			rc = sas_abort_task_set(device, lun.scsi_lun);
 			if (rc == TMF_RESP_FUNC_COMPLETE) {
 				hisi_sas_release_task(hisi_hba, device);
 				break;
-- 
2.39.0



