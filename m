Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D316B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597FDC433EF;
	Mon, 16 Jan 2023 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885998;
	bh=xOSIsdrlsN8wvIdBL7ojX65T6doiYRzlcIhZ17Gdm40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlZOQRGoaD/mpnC1odjOZJoJNyIS1W3ya4uxFJV/00ZAJz3c+e/tVW49wRXHZAxXi
	 Ca2vxcE0Mt5mqtLDydsI0w/ZY5biFiGfuWt73PMpWRq2Ia3KQIWOoFqu5ZBpmdWtEp
	 Aj1/kSLBrN+piqo0c6RQvlfAwTbrDoHxHNnbxVJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/658] scsi: snic: Fix possible UAF in snic_tgt_create()
Date: Mon, 16 Jan 2023 16:45:52 +0100
Message-Id: <20230116154921.665335690@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e118df492320176af94deec000ae034cc92be754 ]

Smatch reports a warning as follows:

drivers/scsi/snic/snic_disc.c:307 snic_tgt_create() warn:
  '&tgt->list' not removed from list

If device_add() fails in snic_tgt_create(), tgt will be freed, but
tgt->list will not be removed from snic->disc.tgt_list, then list traversal
may cause UAF.

Remove from snic->disc.tgt_list before free().

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117035100.2944812-1-cuigaosheng1@huawei.com
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/snic/snic_disc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index e9ccfb97773f..7cf871323b2c 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -318,6 +318,9 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
+		spin_lock_irqsave(snic->shost->host_lock, flags);
+		list_del(&tgt->list);
+		spin_unlock_irqrestore(snic->shost->host_lock, flags);
 		kfree(tgt);
 		tgt = NULL;
 
-- 
2.35.1



