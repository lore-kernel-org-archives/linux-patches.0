Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB54F1DDC24;
	Tue,  8 Oct 2024 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391387; cv=none; b=Evlcy/FrS/GMSaWDx6YH2KV59i7AdALGMbco59HCnpS9L8Ls4YDwuLs49aSlaEiTDZQ3XmJa0zygdp8LSEN/Knybsxlp7EOkJ6TxxADfx8qrjjMMtONEV+12QCPrgHUQbDFihu7PhuwfAcWew72ra82pPl4/e77KnLNia4C3LWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391387; c=relaxed/simple;
	bh=xiBxBcgHSmtc4MJy9XFtOn67qIvgN8ahoWOpDDKa0xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEFdaJ2TdQWw1VdQrqkupwtoKDW2b7RxN6RpJ9qEiNObxn0hwANqbeuRvzgXdoKtJoYmxbgRdjV2NBIQ6chZFCyTJvrYwnhDMk3a7p00Mab7jHkpVysMkXjR7PI6aHMq9fP8WtcYcuyVRPDzbnjz/GCG+voD5RS3MXmfbRuQ3i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DZ2KxkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DZ2KxkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE39C4CECC;
	Tue,  8 Oct 2024 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391387;
	bh=xiBxBcgHSmtc4MJy9XFtOn67qIvgN8ahoWOpDDKa0xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DZ2KxkQrLT5p0MSkvaBVJ0vTILmDYx2Se7cgew+TfhSGZwv1Gm/WjMiY9SlscA2T
	 i92AP9++4PTRs+Wr/vFrKIJtLVKA+DIsNuMcFKHukKLtodbEzEx0GWejPqTs/PHINd
	 xFBlwrxmzA7JHjHd3HxHP29rNGkKZcSvwFQTElD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 071/558] drm/xe/guc_submit: add missing locking in wedged_fini
Date: Tue,  8 Oct 2024 14:01:41 +0200
Message-ID: <20241008115705.013575526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

[ Upstream commit 790533e44bfc7af929842fccd9674c9f424d4627 ]

Any non-wedged queue can have a zero refcount here and can be running
concurrently with an async queue destroy, therefore dereferencing the
queue ptr to check wedge status after the lookup can trigger UAF if
queue is not wedged.  Fix this by keeping the submission_state lock held
around the check to postpone the free and make the check safe, before
dropping again around the put() to avoid the deadlock.

Fixes: 8ed9aaae39f3 ("drm/xe: Force wedged state and block GT reset upon any GPU hang")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924150947.118433-2-matthew.auld@intel.com
(cherry picked from commit d28af0b6b9580b9f90c265a7da0315b0ad20bbfd)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 59b36c7998c24..3d91734980110 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -290,9 +290,15 @@ static void guc_submit_wedged_fini(void *arg)
 	struct xe_exec_queue *q;
 	unsigned long index;
 
-	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q)
-		if (exec_queue_wedged(q))
+	mutex_lock(&guc->submission_state.lock);
+	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q) {
+		if (exec_queue_wedged(q)) {
+			mutex_unlock(&guc->submission_state.lock);
 			xe_exec_queue_put(q);
+			mutex_lock(&guc->submission_state.lock);
+		}
+	}
+	mutex_unlock(&guc->submission_state.lock);
 }
 
 static const struct xe_exec_queue_ops guc_exec_queue_ops;
-- 
2.43.0



