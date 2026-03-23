Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA83C1A6818;
	Mon, 23 Mar 2026 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274047; cv=none; b=UQrtkLB3reEJBPPL+TF1n5PRQxmXoxgxwBjqC751xHfOCJXPmFhePnL6YpQ2Y+Btqs0APqvDqNzzBhy7alCQJa+6Bk+EIdld1dVdj1zuYkElkLa9igtld+9DmcQ3R0f+xotOEqyBIriRlK7g/3sXFHUZy8Oj5ce6m8CvWKiRJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274047; c=relaxed/simple;
	bh=Jqg1hmOH0hd77Zp4XhqPJlam7WWNQT0IAUwn34xGyM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSYhsVcX6Yzf8Yy3wHk/IwG0MsaEzGLci3gyLPvPkn3EweSwq97bqL4vhhjAYwVLBNZNxu+nePYan4Bzg4IIZoLFpzJC0hxNrNcl87SGMNEuh58YMZwnqmzaRFvLMAbBbzgYs22buXjIN/xhGNFx8ZQVc0fQNqHYQ3/oWkgU7ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmcQBQKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmcQBQKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F49C4CEF7;
	Mon, 23 Mar 2026 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274047;
	bh=Jqg1hmOH0hd77Zp4XhqPJlam7WWNQT0IAUwn34xGyM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmcQBQKP+J+umDdWQUn2amxaPV4qh96uzgYin/4L980SC7kJzGmNJL7wbitVM8bj0
	 DHbpjbNepNVrtrVZduOqCSaGq+EXWqer3xDU6wd932foAaSy1I34ElkkjEXm0JHoxf
	 kBOijK9OXQt6NvemwssxKbDkdc/JYtq24Yn7sNgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.19 093/220] drm/xe: Open-code GGTT MMIO access protection
Date: Mon, 23 Mar 2026 14:44:30 +0100
Message-ID: <20260323134507.536512331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 01f2557aa684e514005541e71a3d01f4cd45c170 upstream.

GGTT MMIO access is currently protected by hotplug (drm_dev_enter),
which works correctly when the driver loads successfully and is later
unbound or unloaded. However, if driver load fails, this protection is
insufficient because drm_dev_unplug() is never called.

Additionally, devm release functions cannot guarantee that all BOs with
GGTT mappings are destroyed before the GGTT MMIO region is removed, as
some BOs may be freed asynchronously by worker threads.

To address this, introduce an open-coded flag, protected by the GGTT
lock, that guards GGTT MMIO access. The flag is cleared during the
dev_fini_ggtt devm release function to ensure MMIO access is disabled
once teardown begins.

Cc: stable@vger.kernel.org
Fixes: 919bb54e989c ("drm/xe: Fix missing runtime outer protection for ggtt_remove_node")
Reviewed-by: Zhanjun Dong <zhanjun.dong@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260310225039.1320161-8-zhanjun.dong@intel.com
(cherry picked from commit 4f3a998a173b4325c2efd90bdadc6ccd3ad9a431)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c       |   10 ++++------
 drivers/gpu/drm/xe/xe_ggtt_types.h |    5 ++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -274,6 +274,8 @@ static void dev_fini_ggtt(void *arg)
 {
 	struct xe_ggtt *ggtt = arg;
 
+	scoped_guard(mutex, &ggtt->lock)
+		ggtt->flags &= ~XE_GGTT_FLAGS_ONLINE;
 	drain_workqueue(ggtt->wq);
 }
 
@@ -332,6 +334,7 @@ int xe_ggtt_init_early(struct xe_ggtt *g
 	if (err)
 		return err;
 
+	ggtt->flags |= XE_GGTT_FLAGS_ONLINE;
 	err = devm_add_action_or_reset(xe->drm.dev, dev_fini_ggtt, ggtt);
 	if (err)
 		return err;
@@ -365,13 +368,10 @@ static void xe_ggtt_initial_clear(struct
 static void ggtt_node_remove(struct xe_ggtt_node *node)
 {
 	struct xe_ggtt *ggtt = node->ggtt;
-	struct xe_device *xe = tile_to_xe(ggtt->tile);
 	bool bound;
-	int idx;
-
-	bound = drm_dev_enter(&xe->drm, &idx);
 
 	mutex_lock(&ggtt->lock);
+	bound = ggtt->flags & XE_GGTT_FLAGS_ONLINE;
 	if (bound)
 		xe_ggtt_clear(ggtt, node->base.start, node->base.size);
 	drm_mm_remove_node(&node->base);
@@ -384,8 +384,6 @@ static void ggtt_node_remove(struct xe_g
 	if (node->invalidate_on_remove)
 		xe_ggtt_invalidate(ggtt);
 
-	drm_dev_exit(idx);
-
 free_node:
 	xe_ggtt_node_fini(node);
 }
--- a/drivers/gpu/drm/xe/xe_ggtt_types.h
+++ b/drivers/gpu/drm/xe/xe_ggtt_types.h
@@ -25,11 +25,14 @@ struct xe_ggtt {
 	/** @size: Total size of this GGTT */
 	u64 size;
 
-#define XE_GGTT_FLAGS_64K BIT(0)
+#define XE_GGTT_FLAGS_64K       BIT(0)
+#define XE_GGTT_FLAGS_ONLINE	BIT(1)
 	/**
 	 * @flags: Flags for this GGTT
 	 * Acceptable flags:
 	 * - %XE_GGTT_FLAGS_64K - if PTE size is 64K. Otherwise, regular is 4K.
+	 * - %XE_GGTT_FLAGS_ONLINE - is GGTT online, protected by ggtt->lock
+	 *   after init
 	 */
 	unsigned int flags;
 	/** @scratch: Internal object allocation used as a scratch page */


