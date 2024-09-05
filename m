Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E20F156225;
	Thu,  5 Sep 2024 09:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529930; cv=none; b=CV9X8rs/3QPHqQgrEfOi5qwjc8dn1fs/gqMG9mlgbPD2o0JfTldtLUJePcHk6th4iIZmstch6dt5yBpNtPTw1PvM3wlXmvFBDTh0EA91q4okomW1zVujFvhBxjbLuKGb5vbdxtANmx4NKIWK4k+Ned1mXe6XKhIVxYdBlwL0NYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529930; c=relaxed/simple;
	bh=2e6RMNYv+yGWPo5Kagnq+GsjCFjNG1ioloCT8QbxGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws4bLCKcqKBOr8ZrBc1iYBUS9PRcN3Jh2KsV1yjRf7RiuZt/fLBPn4YUi3R8gqNENNhygHi/DUtREHDD/kG6/KhDRn/HmQcY/CW+yeqrT+R5aaisyduimV4fIy9HqbadS836D3VE8NKCqsQqwAOnQyXnZSzGDVJpftC7WZRWHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImMbU+fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImMbU+fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CA7C4CEC3;
	Thu,  5 Sep 2024 09:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529930;
	bh=2e6RMNYv+yGWPo5Kagnq+GsjCFjNG1ioloCT8QbxGYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImMbU+fiaQQ0Q4S0E7pozeHZlof+36WlVQ8nFFQawDVto3rjjW+vWD+pmqDKDHmrM
	 UWmRub4FXQT+FdippOwNLIBTNu7JXsXmTgYfV5gmM9/cLRFRzAc0cmGbsJIru2A6Mr
	 7RgCp4LCVRDrDfT/8e44oa/MbXRfZRLOhiDTa1qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 160/184] drm/xe: Add GuC state asserts to deregister_exec_queue
Date: Thu,  5 Sep 2024 11:41:13 +0200
Message-ID: <20240905093738.589573126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 716ce587a81e6165a4133ea32f63f3d69f80e1e7 ]

Will help catch bugs in GuC state machine.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240611144053.2805091-9-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index e48285c81bf5..0a496612c810 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1551,6 +1551,11 @@ static void deregister_exec_queue(struct xe_guc *guc, struct xe_exec_queue *q)
 		q->guc->id,
 	};
 
+	xe_gt_assert(guc_to_gt(guc), exec_queue_destroyed(q));
+	xe_gt_assert(guc_to_gt(guc), exec_queue_registered(q));
+	xe_gt_assert(guc_to_gt(guc), !exec_queue_pending_disable(q));
+	xe_gt_assert(guc_to_gt(guc), !exec_queue_pending_enable(q));
+
 	trace_xe_exec_queue_deregister(q);
 
 	xe_guc_ct_send_g2h_handler(&guc->ct, action, ARRAY_SIZE(action));
-- 
2.43.0



