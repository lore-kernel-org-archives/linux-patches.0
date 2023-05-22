Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA2171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50B4C433EF;
	Mon, 22 May 2023 19:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785262;
	bh=jI3ffsR6MUaqjplfpOOioCascQGWN2tvgN+A2cRPa6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKgTaHpjAhQnOwBteteB2km0SYFV/E3C3Dk8mb6YpLq/HLC3WFNNS3sGs0ap+Ju5N
	 IiVJKTyUTyXFPykp6sRREEw1swyKmNrBBu0tz/2mLyS7PcNcADO2RFTaKan6y46YJt
	 uW+quxoLsG2ZG85vjnodw6FJsvJvggrVkRvpUQkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao2@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.3 364/364] scsi: Revert "scsi: core: Do not increase scsi_devices iorequest_cnt if dispatch failed"
Date: Mon, 22 May 2023 20:11:09 +0100
Message-Id: <20230522190421.868093897@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenchao Hao <haowenchao2@huawei.com>

commit 6ca9818d1624e136a76ae8faedb6b6c95ca66903 upstream.

The "atomic_inc(&cmd->device->iorequest_cnt)" in scsi_queue_rq() would
cause kernel panic because cmd->device may be freed after returning from
scsi_dispatch_cmd().

This reverts commit cfee29ffb45b1c9798011b19d454637d1b0fe87d.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Reported-by: Ming Lei <ming.lei@redhat.com>
Closes: https://lore.kernel.org/r/ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com
Link: https://lore.kernel.org/r/20230515070156.1790181-2-haowenchao2@huawei.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1463,6 +1463,8 @@ static int scsi_dispatch_cmd(struct scsi
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
 
+	atomic_inc(&cmd->device->iorequest_cnt);
+
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
 		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
@@ -1761,7 +1763,6 @@ static blk_status_t scsi_queue_rq(struct
 		goto out_dec_host_busy;
 	}
 
-	atomic_inc(&cmd->device->iorequest_cnt);
 	return BLK_STS_OK;
 
 out_dec_host_busy:


