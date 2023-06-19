Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668D8D2F6
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67C1C433CB;
	Mon, 19 Jun 2023 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172375;
	bh=4sAiuO1XPL71JCvuqk3PQrvdkN6iDcQN3USvTxd2SEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/JUz2HWGLqcZqsyqbzrLQfCoCjp7GO2NgGP1ED6p+XutWgI/dp+eDf16D1Bt0hVa
	 ysvGOmUeo9xepMCEI/oVG302m128gCXuw3++oEaPS+deR5ur2WiWHLdziLL4NqzpT8
	 plSF5MCyTtHsnQs3y59Tx+XAi3OMddURJdjeKpoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 045/107] dm thin metadata: check fail_io before using data_sm
Date: Mon, 19 Jun 2023 12:30:29 +0200
Message-ID: <20230619102143.645302918@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Lingfeng <lilingfeng3@huawei.com>

commit cb65b282c9640c27d3129e2e04b711ce1b352838 upstream.

Must check pmd->fail_io before using pmd->data_sm since
pmd->data_sm may be destroyed by other processes.

       P1(kworker)                             P2(message)
do_worker
 process_prepared
  process_prepared_discard_passdown_pt2
   dm_pool_dec_data_range
                                    pool_message
                                     commit
                                      dm_pool_commit_metadata
                                        ↓
                                       // commit failed
                                      metadata_operation_failed
                                       abort_transaction
                                        dm_pool_abort_metadata
                                         __open_or_format_metadata
                                           ↓
                                          dm_sm_disk_open
                                            ↓
                                           // open failed
                                           // pmd->data_sm is NULL
    dm_sm_dec_blocks
      ↓
     // try to access pmd->data_sm --> UAF

As shown above, if dm_pool_commit_metadata() and
dm_pool_abort_metadata() fail in pool_message process, kworker may
trigger UAF.

Fixes: be500ed721a6 ("dm space maps: improve performance with inc/dec on ranges of blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1778,13 +1778,15 @@ int dm_thin_remove_range(struct dm_thin_
 
 int dm_pool_block_is_shared(struct dm_pool_metadata *pmd, dm_block_t b, bool *result)
 {
-	int r;
+	int r = -EINVAL;
 	uint32_t ref_count;
 
 	down_read(&pmd->root_lock);
-	r = dm_sm_get_count(pmd->data_sm, b, &ref_count);
-	if (!r)
-		*result = (ref_count > 1);
+	if (!pmd->fail_io) {
+		r = dm_sm_get_count(pmd->data_sm, b, &ref_count);
+		if (!r)
+			*result = (ref_count > 1);
+	}
 	up_read(&pmd->root_lock);
 
 	return r;
@@ -1792,10 +1794,11 @@ int dm_pool_block_is_shared(struct dm_po
 
 int dm_pool_inc_data_range(struct dm_pool_metadata *pmd, dm_block_t b, dm_block_t e)
 {
-	int r = 0;
+	int r = -EINVAL;
 
 	pmd_write_lock(pmd);
-	r = dm_sm_inc_blocks(pmd->data_sm, b, e);
+	if (!pmd->fail_io)
+		r = dm_sm_inc_blocks(pmd->data_sm, b, e);
 	pmd_write_unlock(pmd);
 
 	return r;
@@ -1803,10 +1806,11 @@ int dm_pool_inc_data_range(struct dm_poo
 
 int dm_pool_dec_data_range(struct dm_pool_metadata *pmd, dm_block_t b, dm_block_t e)
 {
-	int r = 0;
+	int r = -EINVAL;
 
 	pmd_write_lock(pmd);
-	r = dm_sm_dec_blocks(pmd->data_sm, b, e);
+	if (!pmd->fail_io)
+		r = dm_sm_dec_blocks(pmd->data_sm, b, e);
 	pmd_write_unlock(pmd);
 
 	return r;


