Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB1711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D55C433C8;
	Mon, 11 Sep 2023 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445677;
	bh=I+NJ1yJs0CSDthBnGibfwYBqlGeVpAR7SlHg8Q41nD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OQ9xwLuJln9MvhpTtOnDOTXh3kCoXkCOXv4Ng7dsclq3nzRlHPq4o92k1d8un8Ru
	 YnC81fEHc/L4B3l7xCE32UrUW9KFArVrj0B4kZoDM+KBuqxCsREo9/oKq1Pw8CCzpA
	 hrEaZpzpctIPMUsFc+9ryTtyMWoUUFBgJwgKoddU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/600] RDMA/irdma: Replace one-element array with flexible-array member
Date: Mon, 11 Sep 2023 15:47:46 +0200
Message-ID: <20230911134646.439005932@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 38313c6d2a02c28162e06753b01bd885caf9386d ]

One-element and zero-length arrays are deprecated. So, replace
one-element array in struct irdma_qvlist_info with flexible-array
member.

A patch for this was sent a while ago[1]. However, it seems that, at
the time, the changes were partially folded[2][3], and the actual
flexible-array transformation was omitted. This patch fixes that.

The only binary difference seen before/after changes is shown below:

|  drivers/infiniband/hw/irdma/hw.o
| @@ -868,7 +868,7 @@
| drivers/infiniband/hw/irdma/hw.c:484 (discriminator 2)
|	size += struct_size(iw_qvlist, qv_info, rf->msix_count);
|      55b:      imul   $0x45c,%rdi,%rdi
|-     562:      add    $0x10,%rdi
|+     562:      add    $0x4,%rdi

which is, of course, expected as it reflects the mistake made
while folding the patch I've mentioned above.

Worth mentioning is the fact that with this change we save 12 bytes
of memory, as can be inferred from the diff snapshot above. Notice
that:

$ pahole -C rdma_qv_info idrivers/infiniband/hw/irdma/hw.o
struct irdma_qv_info {
	u32                        v_idx;                /*     0     4 */
	u16                        ceq_idx;              /*     4     2 */
	u16                        aeq_idx;              /*     6     2 */
	u8                         itr_idx;              /*     8     1 */

	/* size: 12, cachelines: 1, members: 4 */
	/* padding: 3 */
	/* last cacheline: 12 bytes */
};

Link: https://lore.kernel.org/linux-hardening/20210525230038.GA175516@embeddedor/ [1]
Link: https://lore.kernel.org/linux-hardening/bf46b428deef4e9e89b0ea1704b1f0e5@intel.com/ [2]
Link: https://lore.kernel.org/linux-rdma/20210520143809.819-1-shiraz.saleem@intel.com/T/#u [3]
Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZMpsQrZadBaJGkt4@work
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/main.h b/drivers/infiniband/hw/irdma/main.h
index e64205839d039..9cbe64311f985 100644
--- a/drivers/infiniband/hw/irdma/main.h
+++ b/drivers/infiniband/hw/irdma/main.h
@@ -236,7 +236,7 @@ struct irdma_qv_info {
 
 struct irdma_qvlist_info {
 	u32 num_vectors;
-	struct irdma_qv_info qv_info[1];
+	struct irdma_qv_info qv_info[];
 };
 
 struct irdma_gen_ops {
-- 
2.40.1



