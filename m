Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257C01C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97131C433D2;
	Mon, 20 Mar 2023 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325230;
	bh=K5mT/tC3s5t1REc3OS5XLcWOKLHvHLvdJGS7ZCUliq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIm/M2gsrnbRhP1EhCj+mx04dDI67c6sQ8W7J9L/Y6z82C0ApuwsrI40M8iIbeiOq
	 z1k3anQNoV0zv9SFHw5V+fqZL0f/+TJZ0rIFqKNMMwnC8T1ejVTDWDvgTuSEWNdZ4P
	 Nj9Ji1hcAgUrOvVxEviwQfPe3rQkZj90wtaKZIFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 019/211] scsi: mpi3mr: Fix mpi3mr_hba_port memory leak in mpi3mr_remove()
Date: Mon, 20 Mar 2023 15:52:34 +0100
Message-Id: <20230320145514.107614632@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

[ Upstream commit d0f3c3728da8af76dfe435f7f0cfa2b9d9e43ef0 ]

Free mpi3mr_hba_port at .remove.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-4-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6eaeba41072cb..5032b0b5186d4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5077,6 +5077,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
+	struct mpi3mr_hba_port *port, *hba_port_next;
 
 	if (!shost)
 		return;
@@ -5116,6 +5117,16 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_free_mem(mrioc);
 	mpi3mr_cleanup_resources(mrioc);
 
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
+		ioc_info(mrioc,
+		    "removing hba_port entry: %p port: %d from hba_port list\n",
+		    port, port->port_id);
+		list_del(&port->list);
+		kfree(port);
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
-- 
2.39.2



