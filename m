Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E15519E992;
	Tue, 12 Nov 2024 10:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408484; cv=none; b=qWz3qpB4tIwOn/dOF46nrBNKDTuRANQzjH0uZIWidnvPWE8IrJl83gWjqc/pb+HbIH5pTBDEHGOEcC4wQ8yR6/fhdWVC4x20MlfRFExy0MHlyo5fNRb1o/rnnx3BKCev2TYAEuyz0jUqGR6K0HiUVvGeN3/ggfsV2YeC9NPtGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408484; c=relaxed/simple;
	bh=8toJBGbgNg1gWDS/6eneClcItR/7I70kZ6oA9wM5Sjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8lI0aGQH1qEB481s+Vp+cGD/31cFWML2rmv92iMHwZDJ6a1o6hCFPWht4fmyV79a0qdYvuYZ6n+jPFzGIFCE/pN9wZbrvRkJfw4lnH2eWcX30Ot5V2bCu7yPArEJ6JYVaNnSiHkMMDkLFgiZ6IJU7jKUgE7cQGYdW4tyV5TmbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQtxVbxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQtxVbxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94107C4CECD;
	Tue, 12 Nov 2024 10:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408484;
	bh=8toJBGbgNg1gWDS/6eneClcItR/7I70kZ6oA9wM5Sjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQtxVbxa4ZVaC0/PcR5JcAn8l1/anDmrh6KPsiDIrZsZ6ujVIhwERAmAF+1wEYM58
	 4G0EEe7436ab5NB/h3P/+S2q3mCyR0SSKjL7ziWjGjrFFnnEAj01TUBhx9lYjUVZ0R
	 AFFuWVhjy04zQ5DWTNWfJtGSXiePDcqw8yrm/KzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 177/184] drm/xe/guc/ct: Flush g2h worker in case of g2h response timeout
Date: Tue, 12 Nov 2024 11:22:15 +0100
Message-ID: <20241112101907.655546085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit 22ef43c78647dd37b0dafe2182b8650b99dbbe59 ]

In case if g2h worker doesn't get opportunity to within specified
timeout delay then flush the g2h worker explicitly.

v2:
  - Describe change in the comment and add TODO (Matt B/John H)
  - Add xe_gt_warn on fence done after G2H flush (John H)
v3:
  - Updated the comment with root cause
  - Clean up xe_gt_warn message (John H)

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/issues/1620
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/issues/2902
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241017111410.2553784-2-badal.nilawar@intel.com
(cherry picked from commit e5152723380404acb8175e0777b1cea57f319a01)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 55e8a3f37e54 ("drm/xe: Move LNL scheduling WA to xe_device.h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index cd9918e3896c0..ab24053f8766f 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -888,6 +888,24 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 
 	ret = wait_event_timeout(ct->g2h_fence_wq, g2h_fence.done, HZ);
 
+	/*
+	 * Occasionally it is seen that the G2H worker starts running after a delay of more than
+	 * a second even after being queued and activated by the Linux workqueue subsystem. This
+	 * leads to G2H timeout error. The root cause of issue lies with scheduling latency of
+	 * Lunarlake Hybrid CPU. Issue dissappears if we disable Lunarlake atom cores from BIOS
+	 * and this is beyond xe kmd.
+	 *
+	 * TODO: Drop this change once workqueue scheduling delay issue is fixed on LNL Hybrid CPU.
+	 */
+	if (!ret) {
+		flush_work(&ct->g2h_worker);
+		if (g2h_fence.done) {
+			xe_gt_warn(gt, "G2H fence %u, action %04x, done\n",
+				   g2h_fence.seqno, action[0]);
+			ret = 1;
+		}
+	}
+
 	/*
 	 * Ensure we serialize with completion side to prevent UAF with fence going out of scope on
 	 * the stack, since we have no clue if it will fire after the timeout before we can erase
-- 
2.43.0



