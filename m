Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6E746BC
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E11C433C7;
	Mon, 28 Aug 2023 10:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218883;
	bh=9x5TuEhZzB/4C6wgwk6cx2sLZyFNwv6VA+o4YaEpYMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMqpnSs9M6WyiSRAs1dT+tKeKueQQhD2jD0IHGyEv04L3/gbieupsLXAoUtASUMVq
	 3XHXFMp/ika+1FrQ+M324TM01Go2kD0ziocZicr0HVnQSLweeuKZYTHeyR6J7524py
	 Trczn1+1LbuooqNtfuqQtSIsZvfVFa0U9GM+7xsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 111/122] scsi: snic: Fix double free in snic_tgt_create()
Date: Mon, 28 Aug 2023 12:13:46 +0200
Message-ID: <20230828101200.113615721@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Wang <wangzhu9@huawei.com>

commit 1bd3a76880b2bce017987cf53780b372cf59528e upstream.

Commit 41320b18a0e0 ("scsi: snic: Fix possible memory leak if device_add()
fails") fixed the memory leak caused by dev_set_name() when device_add()
failed. However, it did not consider that 'tgt' has already been released
when put_device(&tgt->dev) is called. Remove kfree(tgt) in the error path
to avoid double free of 'tgt' and move put_device(&tgt->dev) after the
removed kfree(tgt) to avoid a use-after-free.

Fixes: 41320b18a0e0 ("scsi: snic: Fix possible memory leak if device_add() fails")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Link: https://lore.kernel.org/r/20230819083941.164365-1-wangzhu9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/snic/snic_disc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -303,12 +303,11 @@ snic_tgt_create(struct snic *snic, struc
 			      "Snic Tgt: device_add, with err = %d\n",
 			      ret);
 
-		put_device(&tgt->dev);
 		put_device(&snic->shost->shost_gendev);
 		spin_lock_irqsave(snic->shost->host_lock, flags);
 		list_del(&tgt->list);
 		spin_unlock_irqrestore(snic->shost->host_lock, flags);
-		kfree(tgt);
+		put_device(&tgt->dev);
 		tgt = NULL;
 
 		return tgt;


