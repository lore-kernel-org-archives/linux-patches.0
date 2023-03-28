Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C2D8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C0EC433EF;
	Tue, 28 Mar 2023 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015046;
	bh=gbu2CeRMch3HT5xeUdOT2IBoRSvn3SpzCMGSW3e3pcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ8PPYqs3IYYU8X819rcRNMiO0GfEeXJRAOEp7aQJkDYYN5IVOhUz1GoBUDH/a7ea
	 avyA72lwzqH+7tf1l0KPnkrl2qgDgywhgwC2xYmz7RHyb9VOPVh0sWTxLV1YjlBq0D
	 k3qg95MjZ8GtBHQPGQSYkYxAZXtmOyvpOEp2Oc1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jkl820.git@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 147/240] scsi: lpfc: Avoid usage of list iterator variable after loop
Date: Tue, 28 Mar 2023 16:41:50 +0200
Message-Id: <20230328142625.849960807@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakob Koschel <jkl820.git@gmail.com>

[ Upstream commit 2850b23e9f9ae3696e472d2883ea1b43aafa884e ]

If the &epd_pool->list is empty when executing
lpfc_get_io_buf_from_expedite_pool() the function would return an invalid
pointer. Even in the case if the list is guaranteed to be populated, the
iterator variable should not be used after the loop to be more robust for
future changes.

Linus proposed to avoid any use of the list iterator variable after the
loop, in the attempt to move the list iterator variable declaration into
the macro to avoid any potential misuse after the loop [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Link: https://lore.kernel.org/r/20230301-scsi-lpfc-avoid-list-iterator-after-loop-v1-1-325578ae7561@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3aa7206537de7..c0ddf55676a1f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21903,20 +21903,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
 static struct lpfc_io_buf *
 lpfc_get_io_buf_from_expedite_pool(struct lpfc_hba *phba)
 {
-	struct lpfc_io_buf *lpfc_ncmd;
+	struct lpfc_io_buf *lpfc_ncmd = NULL, *iter;
 	struct lpfc_io_buf *lpfc_ncmd_next;
 	unsigned long iflag;
 	struct lpfc_epd_pool *epd_pool;
 
 	epd_pool = &phba->epd_pool;
-	lpfc_ncmd = NULL;
 
 	spin_lock_irqsave(&epd_pool->lock, iflag);
 	if (epd_pool->count > 0) {
-		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+		list_for_each_entry_safe(iter, lpfc_ncmd_next,
 					 &epd_pool->list, list) {
-			list_del(&lpfc_ncmd->list);
+			list_del(&iter->list);
 			epd_pool->count--;
+			lpfc_ncmd = iter;
 			break;
 		}
 	}
-- 
2.39.2



