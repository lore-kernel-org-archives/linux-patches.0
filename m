Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED682DC349;
	Tue, 11 Nov 2025 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824961; cv=none; b=ifeBLIPRFsDX18gmoaZzOKN6XoIJAj96RLsic4HhUCHwl3UVZXzwqkBiFucn+XIQq59L6mMcnNE9rGQXYyFuJvD9tt8I+JkTrHJMG5iKUtQmmZnSazRgTNhrQ5A/JXseInidC3N7ePOWiM8xsl9C8j8fEzHWNvhyl2QYf/ARtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824961; c=relaxed/simple;
	bh=fTOSpdwoxWHWmD/p5cYSAN+fvK27im03bDV7fbec73I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTCXS7JntqcGWo0/Qbf8lkmDVFX6X4r72wrG0dKmGzwA2C5ynqTY7vAWhrquyfCUACCTaXvxwaEH+sXqvDmdyv/NvwosUnXHM+n3y/BKPHyB5eEpy5JffOuP2D9qDRepE95w3NbryYOL2UGfvvSTA+9/v+nXd+to2+zMsZW9Xn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbcwScUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbcwScUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC63C116D0;
	Tue, 11 Nov 2025 01:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824961;
	bh=fTOSpdwoxWHWmD/p5cYSAN+fvK27im03bDV7fbec73I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbcwScUe1SOylrucSWTzm7637DEwtOvGsmNM55IsUSdo5fLxeY6NL2SeWn2lOt6Hj
	 4Z/HS+JpBR/HVclgBc93SZ1P2R6znEpOvnvMcuOcVyCHjwIfvLVzAfsMdDO37Sxmdl
	 9Am660V3gXFLk2BQZ52vzy7KRAHiMpGcmMfxq7iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 531/565] bnxt_en: Refactor bnxt_free_ctx_mem()
Date: Tue, 11 Nov 2025 09:46:27 +0900
Message-ID: <20251111004538.915492367@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongguang Gao <hongguang.gao@broadcom.com>

[ Upstream commit 968d2cc07c2fc9a508a53bd2de61200f50206fbc ]

Add a new function bnxt_free_one_ctx_mem() to free one context
memory type.  bnxt_free_ctx_mem() now calls the new function in
the loop to free each context memory type.  There is no change in
behavior.  Later patches will further make use of the new function.

Signed-off-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241115151438.550106-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5204943a4c6e ("bnxt_en: Fix warning in bnxt_dl_reload_down()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 +++++++++++++----------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index abf8984ac5e20..5409ad3cee192 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8872,21 +8872,14 @@ static int bnxt_backing_store_cfg_v2(struct bnxt *bp, u32 ena)
 	return 0;
 }
 
-void bnxt_free_ctx_mem(struct bnxt *bp)
+static void bnxt_free_one_ctx_mem(struct bnxt *bp,
+				  struct bnxt_ctx_mem_type *ctxm)
 {
-	struct bnxt_ctx_mem_info *ctx = bp->ctx;
-	u16 type;
-
-	if (!ctx)
-		return;
-
-	for (type = 0; type < BNXT_CTX_V2_MAX; type++) {
-		struct bnxt_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
-		struct bnxt_ctx_pg_info *ctx_pg = ctxm->pg_info;
-		int i, n = 1;
+	struct bnxt_ctx_pg_info *ctx_pg;
+	int i, n = 1;
 
-		if (!ctx_pg)
-			continue;
+	ctx_pg = ctxm->pg_info;
+	if (ctx_pg) {
 		if (ctxm->instance_bmap)
 			n = hweight32(ctxm->instance_bmap);
 		for (i = 0; i < n; i++)
@@ -8896,6 +8889,18 @@ void bnxt_free_ctx_mem(struct bnxt *bp)
 		ctxm->pg_info = NULL;
 		ctxm->mem_valid = 0;
 	}
+}
+
+void bnxt_free_ctx_mem(struct bnxt *bp)
+{
+	struct bnxt_ctx_mem_info *ctx = bp->ctx;
+	u16 type;
+
+	if (!ctx)
+		return;
+
+	for (type = 0; type < BNXT_CTX_V2_MAX; type++)
+		bnxt_free_one_ctx_mem(bp, &ctx->ctx_arr[type]);
 
 	ctx->flags &= ~BNXT_CTX_FLAG_INITED;
 	kfree(ctx);
-- 
2.51.0



n.c
index c93b43f5bc461..e713fc5964b18 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -68,18 +68,20 @@
  * The magic limit was calculated so that it allows the monitoring
  * application to pick data once in two ticks. This way, another application,
  * which presumably drives the bus, gets to hog CPU, yet we collect our data.
- * If HZ is 100, a 480 mbit/s bus drives 614 KB every jiffy. USB has an
- * enormous overhead built into the bus protocol, so we need about 1000 KB.
+ *
+ * Originally, for a 480 Mbit/s bus this required a buffer of about 1 MB. For
+ * modern 20 Gbps buses, this value increases to over 50 MB. The maximum
+ * buffer size is set to 64 MiB to accommodate this.
  *
  * This is still too much for most cases, where we just snoop a few
  * descriptor fetches for enumeration. So, the default is a "reasonable"
- * amount for systems with HZ=250 and incomplete bus saturation.
+ * amount for typical, low-throughput use cases.
  *
  * XXX What about multi-megabyte URBs which take minutes to transfer?
  */
-#define BUFF_MAX  CHUNK_ALIGN(1200*1024)
-#define BUFF_DFL   CHUNK_ALIGN(300*1024)
-#define BUFF_MIN     CHUNK_ALIGN(8*1024)
+#define BUFF_MAX  CHUNK_ALIGN(64*1024*1024)
+#define BUFF_DFL      CHUNK_ALIGN(300*1024)
+#define BUFF_MIN        CHUNK_ALIGN(8*1024)
 
 /*
  * The per-event API header (2 per URB).
-- 
2.51.0



