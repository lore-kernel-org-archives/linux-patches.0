Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A284B47A7F;
	Wed, 20 Dec 2023 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hleexT0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32DFC433C7;
	Wed, 20 Dec 2023 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088678;
	bh=/FOHTC83D3NFIa1P6KXJOiKiUjwEp3xDjR7utunOvys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hleexT0d7b2Gw3IP6doLFV9cwtSPljVjgRhDJ90uVvUfFhx8AgPCmAgZi2FGW/ZQF
	 Kmfo9ZPZG2VkqJCZWINMyEcdsRK5kdTUrHGV0SGjw90FrI+OjJ7dbrjRWPjFQcXQo5
	 1I6MUVOGAbp0IL+QzEU3hVRe6j2Nl/vSkSimPwiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 019/159] ksmbd: smbd: create MR pool
Date: Wed, 20 Dec 2023 17:08:04 +0100
Message-ID: <20231220160932.175980500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit c9f189271cff85d5d735e25dfa4bc95952ec12d8 ]

Create a memory region pool because rdma_rw_ctx_init()
uses memory registration if memory registration yields
better performance than using multiple SGE entries.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -434,6 +434,7 @@ static void free_transport(struct smb_di
 
 	if (t->qp) {
 		ib_drain_qp(t->qp);
+		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
 		ib_destroy_qp(t->qp);
 	}
 
@@ -1714,7 +1715,9 @@ static int smb_direct_init_params(struct
 	cap->max_send_sge = SMB_DIRECT_MAX_SEND_SGES;
 	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
 	cap->max_inline_data = 0;
-	cap->max_rdma_ctxs = 0;
+	cap->max_rdma_ctxs =
+		rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) *
+		smb_direct_max_outstanding_rw_ops;
 	return 0;
 }
 
@@ -1796,6 +1799,7 @@ static int smb_direct_create_qpair(struc
 {
 	int ret;
 	struct ib_qp_init_attr qp_attr;
+	int pages_per_rw;
 
 	t->pd = ib_alloc_pd(t->cm_id->device, 0);
 	if (IS_ERR(t->pd)) {
@@ -1843,6 +1847,23 @@ static int smb_direct_create_qpair(struc
 	t->qp = t->cm_id->qp;
 	t->cm_id->event_handler = smb_direct_cm_handler;
 
+	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
+	if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
+		int pages_per_mr, mr_count;
+
+		pages_per_mr = min_t(int, pages_per_rw,
+				     t->cm_id->device->attrs.max_fast_reg_page_list_len);
+		mr_count = DIV_ROUND_UP(pages_per_rw, pages_per_mr) *
+			atomic_read(&t->rw_avail_ops);
+		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs, mr_count,
+				      IB_MR_TYPE_MEM_REG, pages_per_mr, 0);
+		if (ret) {
+			pr_err("failed to init mr pool count %d pages %d\n",
+			       mr_count, pages_per_mr);
+			goto err;
+		}
+	}
+
 	return 0;
 err:
 	if (t->qp) {


