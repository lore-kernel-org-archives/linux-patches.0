Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F02A1ABEA6;
	Mon, 14 Oct 2024 14:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916424; cv=none; b=jUb56lA9XEnvyg5EZ2HZwRx7UKjfLTAAvGdNQLyI1HVn/wCv/fd0zV78jVMAosg7tVpF++vT26ZD0nOdzkyuw2m4//U4gW5uGPiW1OWCE3ChfdNfZB8qsaU0g0UXAHWpi8wEpEef0hvAnCHx5TUjx051mCJqHVKizF667e4cj9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916424; c=relaxed/simple;
	bh=uJCnhO/6qVa7BJLG+ZP5VMMmSZ60J6qSzJ71fVNPfCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2dwVkHiKRuhXK8vDXfYvBIsrD1p1jKU0f6Qg5ztxYuddkJxFyqSijjsTz3g4lmN8qSZC47g0lqeMnR+9kMeJXC2aqAISYxC7FAF0z9GbvYzdRzVdQB5Wag9TBCX4g+7UqhoBRfCtCQZkhQGfMhkp4RToHBenYQsrCqdClCeAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPttQpEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPttQpEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D38C4CEC3;
	Mon, 14 Oct 2024 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916423;
	bh=uJCnhO/6qVa7BJLG+ZP5VMMmSZ60J6qSzJ71fVNPfCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPttQpEQJnG6yXkINZfMa5iwllQMs1XBmmmQ4xgPOo6BdWqIjMukcxx4QPJhYHbYc
	 xGfpcmA0lko52c+K87JIIypmD94hxMn8Le7TrqwclbY+kG1Yqai47m+vIV9XAeZqSj
	 zqmOqzo7np/uoruR1RJgG8TXzgvqPACXSbn2QbVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 179/214] drm/xe/ct: prevent UAF in send_recv()
Date: Mon, 14 Oct 2024 16:20:42 +0200
Message-ID: <20241014141051.964980766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit db7f92af626178ba59dbbcdd5dee9ec24a987a88 upstream.

Ensure we serialize with completion side to prevent UAF with fence going
out of scope on the stack, since we have no clue if it will fire after
the timeout before we can erase from the xa. Also we have some dependent
loads and stores for which we need the correct ordering, and we lack the
needed barriers. Fix this by grabbing the ct->lock after the wait, which
is also held by the completion side.

v2 (Badal):
 - Also print done after acquiring the lock and seeing timeout.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241001084346.98516-5-matthew.auld@intel.com
(cherry picked from commit 52789ce35c55ccd30c4b67b9cc5b2af55e0122ea)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -894,16 +894,26 @@ retry_same_fence:
 	}
 
 	ret = wait_event_timeout(ct->g2h_fence_wq, g2h_fence.done, HZ);
+
+	/*
+	 * Ensure we serialize with completion side to prevent UAF with fence going out of scope on
+	 * the stack, since we have no clue if it will fire after the timeout before we can erase
+	 * from the xa. Also we have some dependent loads and stores below for which we need the
+	 * correct ordering, and we lack the needed barriers.
+	 */
+	mutex_lock(&ct->lock);
 	if (!ret) {
-		xe_gt_err(gt, "Timed out wait for G2H, fence %u, action %04x",
-			  g2h_fence.seqno, action[0]);
+		xe_gt_err(gt, "Timed out wait for G2H, fence %u, action %04x, done %s",
+			  g2h_fence.seqno, action[0], str_yes_no(g2h_fence.done));
 		xa_erase_irq(&ct->fence_lookup, g2h_fence.seqno);
+		mutex_unlock(&ct->lock);
 		return -ETIME;
 	}
 
 	if (g2h_fence.retry) {
 		xe_gt_dbg(gt, "H2G action %#x retrying: reason %#x\n",
 			  action[0], g2h_fence.reason);
+		mutex_unlock(&ct->lock);
 		goto retry;
 	}
 	if (g2h_fence.fail) {
@@ -912,7 +922,12 @@ retry_same_fence:
 		ret = -EIO;
 	}
 
-	return ret > 0 ? response_buffer ? g2h_fence.response_len : g2h_fence.response_data : ret;
+	if (ret > 0)
+		ret = response_buffer ? g2h_fence.response_len : g2h_fence.response_data;
+
+	mutex_unlock(&ct->lock);
+
+	return ret;
 }
 
 /**


