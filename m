Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DC933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B113BC433D2;
	Mon, 16 Jan 2023 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884681;
	bh=PmNYKTsAqSDgur1tY2yT9oJh3BzmdvH7EQNw5hMqNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyXK3uOUgBkEknEZ7lv3G+5+V2QZBNr4TzxtMWnvicdF7g2lVmGRwsEJqVspwtGsm
	 JeXgFrtLOH0/tNVa1og78Srk0fcogyroQAYkYBEHigqYloHrF0vrxWVvKKdK49InIe
	 Iy6aHE64f8qDUE5bFmVu7hpbLaHxytOo8/Uh+n9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/183] scsi: storvsc: Fix swiotlb bounce buffer leak in confidential VM
Date: Mon, 16 Jan 2023 16:50:21 +0100
Message-Id: <20230116154807.546972787@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 67ff3d0a49f3d445c3922e30a54e03c161da561e ]

storvsc_queuecommand() maps the scatter/gather list using scsi_dma_map(),
which in a confidential VM allocates swiotlb bounce buffers. If the I/O
submission fails in storvsc_do_io(), the I/O is typically retried by higher
level code, but the bounce buffer memory is never freed.  The mostly like
cause of I/O submission failure is a full VMBus channel ring buffer, which
is not uncommon under high I/O loads.  Eventually enough bounce buffer
memory leaks that the confidential VM can't do any I/O. The same problem
can arise in a non-confidential VM with kernel boot parameter
swiotlb=force.

Fix this by doing scsi_dma_unmap() in the case of an I/O submission
error, which frees the bounce buffer memory.

Fixes: 743b237c3a7b ("scsi: storvsc: Add Isolation VM support for storvsc driver")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1670183564-76254-1-git-send-email-mikelley@microsoft.com
Tested-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3c5b7e4227b2..55d6fb452680 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1823,6 +1823,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	ret = storvsc_do_io(dev, cmd_request, get_cpu());
 	put_cpu();
 
+	if (ret)
+		scsi_dma_unmap(scmnd);
+
 	if (ret == -EAGAIN) {
 		/* no more space */
 		ret = SCSI_MLQUEUE_DEVICE_BUSY;
-- 
2.35.1



