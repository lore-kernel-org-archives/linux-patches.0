Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3187E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A5C433D7;
	Wed,  2 Nov 2022 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356905;
	bh=jQLsBUJuufmzORqkicaRpBCTqZBr6wIz3w1GxGuVc+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMw4GJq77LfxUKPG5rU/E+02y/kZf4uaYCAHR/XrA3pBg+pS4go2lNfQb/M6Pivu8
	 p/la8B8dsJCpXpjksmbRscR5CVj08Q/jq7eAtRk6LwTY5CB6am6Lst1vdGe08cOEBU
	 I4gejOv7GnTpWW0CjueqmaehVeizH8LwJWLb5nv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <cloehle@hyperstone.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 079/240] mmc: block: Remove error check of hw_reset on reset
Date: Wed,  2 Nov 2022 03:30:54 +0100
Message-Id: <20221102022113.188454938@linuxfoundation.org>
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

commit 406e14808ee695cbae1eafa5fd3ac563c29470ab upstream.

Before switching back to the right partition in mmc_blk_reset there used
to be a check if hw_reset was even supported. This return value
was removed, so there is no reason to check. Furthermore ensure
part_curr is not falsely set to a valid value on reset or
partition switch error.

As part of this change the code paths of mmc_blk_reset calls were checked
to ensure no commands are issued after a failed mmc_blk_reset directly
without going through the block layer.

Fixes: fefdd3c91e0a ("mmc: core: Drop superfluous validations in mmc_hw|sw_reset()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/e91be6199d04414a91e20611c81bfe1d@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -134,6 +134,7 @@ struct mmc_blk_data {
 	 * track of the current selected device partition.
 	 */
 	unsigned int	part_curr;
+#define MMC_BLK_PART_INVALID	UINT_MAX	/* Unknown partition active */
 	int	area_type;
 
 	/* debugfs files (only in main mmc_blk_data) */
@@ -987,33 +988,39 @@ static unsigned int mmc_blk_data_timeout
 	return ms;
 }
 
+/*
+ * Attempts to reset the card and get back to the requested partition.
+ * Therefore any error here must result in cancelling the block layer
+ * request, it must not be reattempted without going through the mmc_blk
+ * partition sanity checks.
+ */
 static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 			 int type)
 {
 	int err;
+	struct mmc_blk_data *main_md = dev_get_drvdata(&host->card->dev);
 
 	if (md->reset_done & type)
 		return -EEXIST;
 
 	md->reset_done |= type;
 	err = mmc_hw_reset(host->card);
+	/*
+	 * A successful reset will leave the card in the main partition, but
+	 * upon failure it might not be, so set it to MMC_BLK_PART_INVALID
+	 * in that case.
+	 */
+	main_md->part_curr = err ? MMC_BLK_PART_INVALID : main_md->part_type;
+	if (err)
+		return err;
 	/* Ensure we switch back to the correct partition */
-	if (err) {
-		struct mmc_blk_data *main_md =
-			dev_get_drvdata(&host->card->dev);
-		int part_err;
-
-		main_md->part_curr = main_md->part_type;
-		part_err = mmc_blk_part_switch(host->card, md->part_type);
-		if (part_err) {
-			/*
-			 * We have failed to get back into the correct
-			 * partition, so we need to abort the whole request.
-			 */
-			return -ENODEV;
-		}
-	}
-	return err;
+	if (mmc_blk_part_switch(host->card, md->part_type))
+		/*
+		 * We have failed to get back into the correct
+		 * partition, so we need to abort the whole request.
+		 */
+		return -ENODEV;
+	return 0;
 }
 
 static inline void mmc_blk_reset_success(struct mmc_blk_data *md, int type)
@@ -1871,8 +1878,9 @@ static void mmc_blk_mq_rw_recovery(struc
 		return;
 
 	/* Reset before last retry */
-	if (mqrq->retries + 1 == MMC_MAX_RETRIES)
-		mmc_blk_reset(md, card->host, type);
+	if (mqrq->retries + 1 == MMC_MAX_RETRIES &&
+	    mmc_blk_reset(md, card->host, type))
+		return;
 
 	/* Command errors fail fast, so use all MMC_MAX_RETRIES */
 	if (brq->sbc.error || brq->cmd.error)


