Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F731171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C05C433C8;
	Mon, 21 Aug 2023 20:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648379;
	bh=RDk8boJDZLg8E4T4ZSkP5uR7yA1QSX83R3AUFl1OVXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/G0JpE25noSlKMa6yqjM+cfx/v82Ixyr9XL9D5PPjusugVyI53IFbdLOdTP/s/9w
	 27dZn6P+9LqThwyydAz5bfWxGcIFsGaPyovq5fB0AouzXIpF5MWlYlxB+mXdVApcmk
	 ynvWuw2eT1fXEYtnT+LNVqdSGwGuX0Z5Adly1fWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 153/234] octeon_ep: cancel queued works in probe error path
Date: Mon, 21 Aug 2023 21:41:56 +0200
Message-ID: <20230821194135.587936159@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 758c91078165ae641b698750a72eafe7968b3756 ]

If it fails to get the devices's MAC address, octep_probe exits while
leaving the delayed work intr_poll_task queued. When the work later
runs, it's a use after free.

Move the cancelation of intr_poll_task from octep_remove into
octep_device_cleanup. This does not change anything in the octep_remove
flow, but octep_device_cleanup is called also in the octep_probe error
path, where the cancelation is needed.

Note that the cancelation of ctrl_mbox_task has to follow
intr_poll_task's, because the ctrl_mbox_task may be queued by
intr_poll_task.

Fixes: 24d4333233b3 ("octeon_ep: poll for control messages")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Link: https://lore.kernel.org/r/20230810150114.107765-5-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index ab69b6d625094..4424de2ffd70c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1038,6 +1038,10 @@ static void octep_device_cleanup(struct octep_device *oct)
 {
 	int i;
 
+	oct->poll_non_ioq_intr = false;
+	cancel_delayed_work_sync(&oct->intr_poll_task);
+	cancel_work_sync(&oct->ctrl_mbox_task);
+
 	dev_info(&oct->pdev->dev, "Cleaning up Octeon Device ...\n");
 
 	for (i = 0; i < OCTEP_MAX_VF; i++) {
@@ -1205,9 +1209,6 @@ static void octep_remove(struct pci_dev *pdev)
 		unregister_netdev(netdev);
 
 	cancel_work_sync(&oct->tx_timeout_task);
-	oct->poll_non_ioq_intr = false;
-	cancel_delayed_work_sync(&oct->intr_poll_task);
-	cancel_work_sync(&oct->ctrl_mbox_task);
 	octep_device_cleanup(oct);
 	pci_release_mem_regions(pdev);
 	free_netdev(netdev);
-- 
2.40.1



