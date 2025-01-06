Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A015854A;
	Mon,  6 Jan 2025 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177751; cv=none; b=Jsx/9gQ3h7yomkc+LcnUeS6/5fNMS6KwkbfVymKc2BF84QM7f0VDcSTBSnymbLBlnXstm/Qyhvy0nVsa/LAlpWBI9+u3CwPLZeZcAeqfsmVP8ioziOU6I58h8MwqK2q8jQW2GAN8Mi15Lch/v22ybAsDVy4JugUQ47hv08A6h50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177751; c=relaxed/simple;
	bh=rV9MV6rbekRn7SW4k7Xu+JbgQA8zWg0zEcw7Ri3uynU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYOdFM/b4QXtqIv4goxXQH3EseA7HbscvauH/q2Tj1S9bGbi8aBjqIoLsrla0iRYUTIAmqJrl7gO58PnkFiam/PTdbUfwwBbrR0EcrjVQS+9u2Y+cMdUR3ujNKHVdvcRrcPjVmg0RbFe2rqvA9dWVZ+LXbCpkQeRQ+mRWufky2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3Ih+Qba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3Ih+Qba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C87C4CED2;
	Mon,  6 Jan 2025 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177751;
	bh=rV9MV6rbekRn7SW4k7Xu+JbgQA8zWg0zEcw7Ri3uynU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3Ih+QbaJu22p70UfLYl/J1ZojswwuAUjAaiWZW1/jIx8K3TNLuJSOILKFoU7rDIS
	 FN2P4m5XChoRJC+dIHbhxfohDuinlw8NdXViPThvxgpp9S/9EU2wrhShpxb/8vZlIT
	 XiL3XfgSMF1xYYa8guOa+mpE8bbuzI9AZkPrHc5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/156] drm/xe: Fix fault on fd close after unbind
Date: Mon,  6 Jan 2025 16:15:29 +0100
Message-ID: <20250106151143.359531771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit fe39b222a4139354d32ff9d46b88757f63f71d63 ]

If userspace holds an fd open, unbinds the device and then closes it,
the driver shouldn't try to access the hardware. Protect it by using
drm_dev_enter()/drm_dev_exit(). This fixes the following page fault:

<6> [IGT] xe_wedged: exiting, ret=98
<1> BUG: unable to handle page fault for address: ffffc901bc5e508c
<1> #PF: supervisor read access in kernel mode
<1> #PF: error_code(0x0000) - not-present page
...
<4>   xe_lrc_update_timestamp+0x1c/0xd0 [xe]
<4>   xe_exec_queue_update_run_ticks+0x50/0xb0 [xe]
<4>   xe_exec_queue_fini+0x16/0xb0 [xe]
<4>   __guc_exec_queue_fini_async+0xc4/0x190 [xe]
<4>   guc_exec_queue_fini_async+0xa0/0xe0 [xe]
<4>   guc_exec_queue_fini+0x23/0x40 [xe]
<4>   xe_exec_queue_destroy+0xb3/0xf0 [xe]
<4>   xe_file_close+0xd4/0x1a0 [xe]
<4>   drm_file_free+0x210/0x280 [drm]
<4>   drm_close_helper.isra.0+0x6d/0x80 [drm]
<4>   drm_release_noglobal+0x20/0x90 [drm]

Fixes: 514447a12190 ("drm/xe: Stop accumulating LRC timestamp on job_free")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3421
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241218053122.2730195-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 4ca1fd418338d4d135428a0eb1e16e3b3ce17ee8)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index fd0f3b3c9101..268cd3123be9 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -8,6 +8,7 @@
 #include <linux/nospec.h>
 
 #include <drm/drm_device.h>
+#include <drm/drm_drv.h>
 #include <drm/drm_file.h>
 #include <uapi/drm/xe_drm.h>
 
@@ -762,9 +763,11 @@ bool xe_exec_queue_is_idle(struct xe_exec_queue *q)
  */
 void xe_exec_queue_update_run_ticks(struct xe_exec_queue *q)
 {
+	struct xe_device *xe = gt_to_xe(q->gt);
 	struct xe_file *xef;
 	struct xe_lrc *lrc;
 	u32 old_ts, new_ts;
+	int idx;
 
 	/*
 	 * Jobs that are run during driver load may use an exec_queue, but are
@@ -774,6 +777,10 @@ void xe_exec_queue_update_run_ticks(struct xe_exec_queue *q)
 	if (!q->vm || !q->vm->xef)
 		return;
 
+	/* Synchronize with unbind while holding the xe file open */
+	if (!drm_dev_enter(&xe->drm, &idx))
+		return;
+
 	xef = q->vm->xef;
 
 	/*
@@ -787,6 +794,8 @@ void xe_exec_queue_update_run_ticks(struct xe_exec_queue *q)
 	lrc = q->lrc[0];
 	new_ts = xe_lrc_update_timestamp(lrc, &old_ts);
 	xef->run_ticks[q->class] += (new_ts - old_ts) * q->width;
+
+	drm_dev_exit(idx);
 }
 
 /**
-- 
2.39.5



