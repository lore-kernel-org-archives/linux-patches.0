Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD9A9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA54C433C8;
	Sun, 13 Aug 2023 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962374;
	bh=3J+P/oX5WRfSDuh1Q6dRg5PujbF8+0nB6SZZXGngZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYaiX5MdzbYj77O6VCLRF8Ub6sO4K0UUQaQ4h9tMwLda0Ozn3IYlpe+69/NdbeUUA
	 65BUJNNKJ2EK6TODOB9PCHBzJcIt/5p3qgKbxHm6/9o6xc+jhgXf1Aou4X3J0Y5d/I
	 Xej800J2zLOA+/FolknIaJFybydRBMQn6ds+wUPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.4 193/206] scsi: snic: Fix possible memory leak if device_add() fails
Date: Sun, 13 Aug 2023 23:19:23 +0200
Message-ID: <20230813211730.541956766@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhu Wang <wangzhu9@huawei.com>

commit 41320b18a0e0dfb236dba4edb9be12dba1878156 upstream.

If device_add() returns error, the name allocated by dev_set_name() needs
be freed. As the comment of device_add() says, put_device() should be used
to give up the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanp().

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Link: https://lore.kernel.org/r/20230801111421.63651-1-wangzhu9@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/snic/snic_disc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -303,6 +303,7 @@ snic_tgt_create(struct snic *snic, struc
 			      "Snic Tgt: device_add, with err = %d\n",
 			      ret);
 
+		put_device(&tgt->dev);
 		put_device(&snic->shost->shost_gendev);
 		spin_lock_irqsave(snic->shost->host_lock, flags);
 		list_del(&tgt->list);


