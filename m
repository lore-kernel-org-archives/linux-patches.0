Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3350331A63;
	Tue, 17 Mar 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767946; cv=none; b=kZEwwELQ2yAUm5tLvz+hY45LZ7oH+8lZpX41gJJSPv69kInXiRXT2UTFxBtFvD4yTjfwNgkWF3/5RWj5avIAO9hS4CXYiXGCixHETTbBL6qO73JCo9+BqsGHbjSCA4qzhH/GCRzjLHQamZ1h+Nr4iPnmJC/WVlEahB9wsvD1qXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767946; c=relaxed/simple;
	bh=ia+ufNiwbjPpVVlLTowaJKGK7mkhAZ13MQJTzTZLtkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da7iXZzkm9G13jb96UJn5AH/dgOHs9JHs6lhiKI+ibv/2ijCo8t03csMyzeyq6Yj5q2zk3VMWjVREfkA6fJAa40VmyDWtL8r2/bpYYQ7HcSThcN45q6I7SOu776TEBtrkPDAQkaLwYUUSVmMLAS0MyTd6KuAhjs5H6ZMSfR5YVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT7iZVom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT7iZVom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B76C4CEF7;
	Tue, 17 Mar 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767945;
	bh=ia+ufNiwbjPpVVlLTowaJKGK7mkhAZ13MQJTzTZLtkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT7iZVomraQ3KgAM5HzdAoqFqYtxd9AjMNQzhgc6xIuRjsrIpo07TijSaXalu6BO0
	 2Y808ACtN8xroHi/qw217YR4GHkNuUB6sPBozW5A4kEBHhLvc54F6PJHUV7+Csiv5S
	 T6rK5jxfNmAsRlZXDL1zjqN6GmMXABj+Nzy5NtqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 196/333] drm/xe/sync: Cleanup partially initialized sync on parse failure
Date: Tue, 17 Mar 2026 17:33:45 +0100
Message-ID: <20260317163006.625904665@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 1bfd7575092420ba5a0b944953c95b74a5646ff8 upstream.

xe_sync_entry_parse() can allocate references (syncobj, fence, chain fence,
or user fence) before hitting a later failure path. Several of those paths
returned directly, leaving partially initialized state and leaking refs.

Route these error paths through a common free_sync label and call
xe_sync_entry_cleanup(sync) before returning the error.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260219233516.2938172-5-shuicheng.lin@intel.com
(cherry picked from commit f939bdd9207a5d1fc55cced5459858480686ce22)
Cc: stable@vger.kernel.org
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_sync.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -146,8 +146,10 @@ int xe_sync_entry_parse(struct xe_device
 
 		if (!signal) {
 			sync->fence = drm_syncobj_fence_get(sync->syncobj);
-			if (XE_IOCTL_DBG(xe, !sync->fence))
-				return -EINVAL;
+			if (XE_IOCTL_DBG(xe, !sync->fence)) {
+				err = -EINVAL;
+				goto free_sync;
+			}
 		}
 		break;
 
@@ -167,17 +169,21 @@ int xe_sync_entry_parse(struct xe_device
 
 		if (signal) {
 			sync->chain_fence = dma_fence_chain_alloc();
-			if (!sync->chain_fence)
-				return -ENOMEM;
+			if (!sync->chain_fence) {
+				err = -ENOMEM;
+				goto free_sync;
+			}
 		} else {
 			sync->fence = drm_syncobj_fence_get(sync->syncobj);
-			if (XE_IOCTL_DBG(xe, !sync->fence))
-				return -EINVAL;
+			if (XE_IOCTL_DBG(xe, !sync->fence)) {
+				err = -EINVAL;
+				goto free_sync;
+			}
 
 			err = dma_fence_chain_find_seqno(&sync->fence,
 							 sync_in.timeline_value);
 			if (err)
-				return err;
+				goto free_sync;
 		}
 		break;
 
@@ -216,6 +222,10 @@ int xe_sync_entry_parse(struct xe_device
 	sync->timeline_value = sync_in.timeline_value;
 
 	return 0;
+
+free_sync:
+	xe_sync_entry_cleanup(sync);
+	return err;
 }
 ALLOW_ERROR_INJECTION(xe_sync_entry_parse, ERRNO);
 


