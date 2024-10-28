Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338CE18E04F;
	Mon, 28 Oct 2024 06:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097544; cv=none; b=cXYNNmzKEpLn3lMoLoUkI5LdPc/LiYg52HfcpoDfHx+VawNb9ivLo0GMzC38BqEVFlUsO6S5lo+xP0em+marsleOkbW4zYGn92XguU07Nn9ASkfLk5pQ8RQQ0ZaW5viOvpkhu2M22GuTJLVT6ey/wbDUr72/bAvmwW67NYoYa0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097544; c=relaxed/simple;
	bh=pMu1mvjmnEadDio9bHurn5x9SAyXm79DJKRrH1I2pJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6wZiWl8xbayLLDXYVfUlZ1OPj/nAow+55/LcrAmrh1ZHQ7eRxMFu7Au+F9HH+0sDR3Cxj7YCBuxfuZDASELaO7KMKjYPluJ0sUay16Zk/A1dqgqNzWt6CUOY5Xcuy1wAG2c7a+GD9sVPpGM1JD7TzmseKcXuZLTSRC0cojowiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a++TJgP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a++TJgP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C825CC4CEC3;
	Mon, 28 Oct 2024 06:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097544;
	bh=pMu1mvjmnEadDio9bHurn5x9SAyXm79DJKRrH1I2pJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a++TJgP81M6uEM2dNo5cippG7URYO6VI3yRW36T96vkwpQitEnTvK4E302pl8LkaQ
	 OXEefST/u21oGYbWyv8uPFF5lacQlhU6sxEQvIaedvAKIREZ9kJv9flDLXnkHkQqBI
	 dbtZsLjGO+TeJusYsxlu6LOG7j3Qdb26VwtWY6MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/208] accel/qaic: Fix the for loop used to walk SG table
Date: Mon, 28 Oct 2024 07:23:40 +0100
Message-ID: <20241028062307.642498376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>

[ Upstream commit c5e8e93897b7bb0a336bf3332f82f8d9f2b33f14 ]

Only for_each_sgtable_dma_sg() should be used to walk through a SG table
to grab correct bus address and length pair after calling DMA MAP API on
a SG table as DMA MAP APIs updates the SG table and for_each_sgtable_sg()
walks through the original SG table.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Fixes: 129776ac2e38 ("accel/qaic: Add control path")
Signed-off-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004193252.3888544-1-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_control.c | 2 +-
 drivers/accel/qaic/qaic_data.c    | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/qaic/qaic_control.c b/drivers/accel/qaic/qaic_control.c
index 388abd40024ba..f3db3fa91dd52 100644
--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -496,7 +496,7 @@ static int encode_addr_size_pairs(struct dma_xfer *xfer, struct wrapper_list *wr
 	nents = sgt->nents;
 	nents_dma = nents;
 	*size = QAIC_MANAGE_EXT_MSG_LENGTH - msg_hdr_len - sizeof(**out_trans);
-	for_each_sgtable_sg(sgt, sg, i) {
+	for_each_sgtable_dma_sg(sgt, sg, i) {
 		*size -= sizeof(*asp);
 		/* Save 1K for possible follow-up transactions. */
 		if (*size < SZ_1K) {
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index ed1a5af434f24..d2f8c70a77a5b 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -177,7 +177,7 @@ static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_tabl
 	nents = 0;
 
 	size = size ? size : PAGE_SIZE;
-	for (sg = sgt_in->sgl; sg; sg = sg_next(sg)) {
+	for_each_sgtable_dma_sg(sgt_in, sg, j) {
 		len = sg_dma_len(sg);
 
 		if (!len)
@@ -214,7 +214,7 @@ static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_tabl
 
 	/* copy relevant sg node and fix page and length */
 	sgn = sgf;
-	for_each_sgtable_sg(sgt, sg, j) {
+	for_each_sgtable_dma_sg(sgt, sg, j) {
 		memcpy(sg, sgn, sizeof(*sg));
 		if (sgn == sgf) {
 			sg_dma_address(sg) += offf;
@@ -294,7 +294,7 @@ static int encode_reqs(struct qaic_device *qdev, struct bo_slice *slice,
 	 * fence.
 	 */
 	dev_addr = req->dev_addr;
-	for_each_sgtable_sg(slice->sgt, sg, i) {
+	for_each_sgtable_dma_sg(slice->sgt, sg, i) {
 		slice->reqs[i].cmd = cmd;
 		slice->reqs[i].src_addr = cpu_to_le64(slice->dir == DMA_TO_DEVICE ?
 						      sg_dma_address(sg) : dev_addr);
-- 
2.43.0



