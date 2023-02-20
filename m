Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99DF63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AF4C433EF;
	Mon, 20 Feb 2023 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901090;
	bh=mTMw2/JR+uBsDK/x5+T4kQ8CxEQgO2/uPV8SNawSnb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvAknBDbvP4FS+clH8g+mOneiaWpwzcFFcLljt8dJIbHGktgRofH1j5HDmvQbnfDC
	 zasyY3ihs+grnJAIRu89xWg0M9F3oeyzZGNNVy96CoX24q9Ut2Y3xq2+boBXcVaYJ/
	 vXT4E4DTRVcunjbO3UvXO/C1rQmwmMYCtPN6Fwy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/83] xfs: fix potential log item leak
Date: Mon, 20 Feb 2023 14:35:58 +0100
Message-Id: <20230220133554.571228412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit c230a4a85bcdbfc1a7415deec6caf04e8fca1301 ]

Ever since we added shadown format buffers to the log items, log
items need to handle the item being released with shadow buffers
attached. Due to the fact this requirement was added at the same
time we added new rmap/reflink intents, we missed the cleanup of
those items.

In theory, this means shadow buffers can be leaked in a very small
window when a shutdown is initiated. Testing with KASAN shows this
leak does not happen in practice - we haven't identified a single
leak in several years of shutdown testing since ~v4.8 kernels.

However, the intent whiteout cleanup mechanism results in every
cancelled intent in exactly the same state as this tiny race window
creates and so if intents down clean up shadow buffers on final
release we will leak the shadow buffer for just about every intent
we create.

Hence we start with this patch to close this condition off and
ensure that when whiteouts start to be used we don't leak lots of
memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_item.c     | 2 ++
 fs/xfs/xfs_icreate_item.c  | 1 +
 fs/xfs/xfs_refcount_item.c | 2 ++
 fs/xfs/xfs_rmap_item.c     | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 03159970133ff..51ffdec5e4faa 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -39,6 +39,7 @@ STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
+	kmem_free(buip->bui_item.li_lv_shadow);
 	kmem_cache_free(xfs_bui_zone, buip);
 }
 
@@ -198,6 +199,7 @@ xfs_bud_item_release(
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
 	xfs_bui_release(budp->bud_buip);
+	kmem_free(budp->bud_item.li_lv_shadow);
 	kmem_cache_free(xfs_bud_zone, budp);
 }
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 017904a34c023..c265ae20946d5 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,6 +63,7 @@ STATIC void
 xfs_icreate_item_release(
 	struct xfs_log_item	*lip)
 {
+	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);
 	kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 46904b793bd48..8ef842d17916a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
+	kmem_free(cuip->cui_item.li_lv_shadow);
 	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		kmem_free(cuip);
 	else
@@ -204,6 +205,7 @@ xfs_cud_item_release(
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
 	xfs_cui_release(cudp->cud_cuip);
+	kmem_free(cudp->cud_item.li_lv_shadow);
 	kmem_cache_free(xfs_cud_zone, cudp);
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f06959804678..15e7b01740a77 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
+	kmem_free(ruip->rui_item.li_lv_shadow);
 	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		kmem_free(ruip);
 	else
@@ -227,6 +228,7 @@ xfs_rud_item_release(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
 	xfs_rui_release(rudp->rud_ruip);
+	kmem_free(rudp->rud_item.li_lv_shadow);
 	kmem_cache_free(xfs_rud_zone, rudp);
 }
 
-- 
2.39.0



