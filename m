Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BAEEAD0;
	Fri, 15 Nov 2024 06:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653387; cv=none; b=UlE+38FcI8d4pGawPjbBfLmi84SxW7HcR0fadFBxU0eaiwWPP2jxt3p1JoDzH6ZQCCe+CkUY5p0PMujtfxSdoRldDX3rVxteLtuOmKhe6a14xAiu9fOMWLrFBweyZJvgWPNDuIQrmN1i2P02TUcjwx0he3q6z5gDB1VI3ctPw8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653387; c=relaxed/simple;
	bh=mthixM7rAc5K5RhYiL0cBSvo7+fn3xEHUVxYeVttAeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTQhlLIRX5FGDVT3QAdPR24bfciiUZ/e+G4lRALoGr5T+2BXyqPMyn5zNcDE3hA0iegX8MJAFjGiu6ZVzzfTYt3q9/YjHbz8kaoM9pAFaskHsuvWmj7v/ngzkxWxmEGYC60bVKKmLzgxgC/kTY0jy4l6FyVKxW97DmM5fLLMvBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fF2GiP9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fF2GiP9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DA2C4CECF;
	Fri, 15 Nov 2024 06:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653387;
	bh=mthixM7rAc5K5RhYiL0cBSvo7+fn3xEHUVxYeVttAeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF2GiP9YzOFLbZugUwaLEELt4xRea77TdJql3pkHtlRPBtsmO8rMOwXY3pChcoNkY
	 TT5Lg0up9NdNTMN/XufUjy6g6FkZ4iiNsPcp8AYYLJ9GHpTQ4nL4+pM5z/OlnirmAQ
	 fv5A3XuXV3zmmA115O4Z9CaoobLSyOWQFVh+O89g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 61/63] drm/xe: Dont restart parallel queues multiple times on GT reset
Date: Fri, 15 Nov 2024 07:38:24 +0100
Message-ID: <20241115063728.107624071@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit cdc21021f0351226a4845715564afd5dc50ed44b ]

In case of parallel submissions multiple GuC id will point to the
same exec queue and on GT reset such exec queues will get restarted
multiple times which is not desirable.

v2: don't use exec_queue_enabled() which could race,
    do the same for xe_guc_submit_stop (Matt B)

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2295
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022103555.731557-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit c8b0acd6d8745fd7e6450f5acc38f0227bd253b3)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index cbdd44567d107..792024c28da86 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1771,8 +1771,13 @@ void xe_guc_submit_stop(struct xe_guc *guc)
 
 	mutex_lock(&guc->submission_state.lock);
 
-	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q)
+	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q) {
+		/* Prevent redundant attempts to stop parallel queues */
+		if (q->guc->id != index)
+			continue;
+
 		guc_exec_queue_stop(guc, q);
+	}
 
 	mutex_unlock(&guc->submission_state.lock);
 
@@ -1810,8 +1815,13 @@ int xe_guc_submit_start(struct xe_guc *guc)
 
 	mutex_lock(&guc->submission_state.lock);
 	atomic_dec(&guc->submission_state.stopped);
-	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q)
+	xa_for_each(&guc->submission_state.exec_queue_lookup, index, q) {
+		/* Prevent redundant attempts to start parallel queues */
+		if (q->guc->id != index)
+			continue;
+
 		guc_exec_queue_start(q);
+	}
 	mutex_unlock(&guc->submission_state.lock);
 
 	wake_up_all(&guc->ct.wq);
-- 
2.43.0



