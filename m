Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94587E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCCEC433D6;
	Wed,  2 Nov 2022 02:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356911;
	bh=ime7V394A9516/yHZTYfO4wuZeZR/75YH89Zwvv9y84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7T1UKpY6SHLSa4+IjnzZfvBrw9+L1BlA0sFcy1EnD6ZSuuiJGgtLYsJPBKIlTfW7
	 I0m+YlEF2r4OLYXjZ7vUuU8fZ69PCPZ1wBOd2p39OEEtGYq7sLvTQQf0t7LSNYR8Oz
	 CbOk46yFn2B//1DtjJlAjHPOCHsz8Z+vLe7c72wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 080/240] mmc: queue: Cancel recovery work on cleanup
Date: Wed,  2 Nov 2022 03:30:55 +0100
Message-Id: <20221102022113.211124743@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Löhle <CLoehle@hyperstone.com>

commit 339e3eb1facd18a98ceb1171d70674780e5014a7 upstream.

To prevent any recovery work running after the queue cleanup cancel it.
Any recovery running post-cleanup dereferenced mq->card as NULL
and was not meaningful to begin with.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/c865c0c9789d428494b67b820a78923e@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/queue.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -493,6 +493,13 @@ void mmc_cleanup_queue(struct mmc_queue
 	if (blk_queue_quiesced(q))
 		blk_mq_unquiesce_queue(q);
 
+	/*
+	 * If the recovery completes the last (and only remaining) request in
+	 * the queue, and the card has been removed, we could end up here with
+	 * the recovery not quite finished yet, so cancel it.
+	 */
+	cancel_work_sync(&mq->recovery_work);
+
 	blk_mq_free_tag_set(&mq->tag_set);
 
 	/*


