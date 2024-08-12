Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686C0134AC;
	Mon, 12 Aug 2024 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480084; cv=none; b=otesxkEddGtiuUKeQCPEvzGQ4DlBB9RzjwTvyZBmcv0RWDoeLb7vWYO8Byj+pop/WuWbDLGRVv63fPxLoj/RCKp8hDFz/sAkAfgRZcxPVP3T3Fv3Je8G+1wdQMu/Zp1DLS/MOLf5VYLpDhBjW1an4QJ1i5BCZvhnrb/eR/8wIkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480084; c=relaxed/simple;
	bh=Dz+BzA7aqq5jF+nldFL2DV2D0y4wyTBsxoHe7FuaUS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzHVVFSAhiiWJ9mnwtUf9xQzt4A9sn3tbZMOwJ4FZ8wFEgCbGIEqACmOJUbQME99yJdtYN9Ent50/Vlqu7muI60r1h5uMG6qJammFSTaeYry6ClWaBJ4vvR2S+Kv0F/UjBzDkavbB82e/HOSfJ/u6ffOFUdlBRTjq8eSKhWc4WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYYZZ8HI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYYZZ8HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0BBC32782;
	Mon, 12 Aug 2024 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480084;
	bh=Dz+BzA7aqq5jF+nldFL2DV2D0y4wyTBsxoHe7FuaUS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYYZZ8HIYET1ge2n2ehXegwTkka3IhNio9VfKe6TYzfCK0DAaueUODlwYFBjkkSWB
	 8MMFQx0atEz3s2FAlEcGvsaNAGApe2LcgIyv4FdmJXn0zKGL7OB7MUhrMiycEjiSJy
	 4ApnCwJnUYr6e59LwyM2Y1YiPih6H6Zi3/FtdM/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 092/263] drm/xe/xe_guc_submit: Fix exec queue stop race condition
Date: Mon, 12 Aug 2024 18:01:33 +0200
Message-ID: <20240812160150.066687160@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit 1564d411e17f51e2f64655b4e4da015be1ba7eaa ]

Reorder the xe_sched_tdr_queue_imm and set_exec_queue_banned calls in
guc_exec_queue_stop.  This prevents a possible race condition between
the two events in which it's possible for xe_sched_tdr_queue_imm to
wake the ufence waiter before the exec queue is banned, causing the
ufence waiter to miss the banned state.

Suggested-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240510194540.3246991-1-jonathan.cavitt@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index e4e3658e6a138..0f42971ff0a83 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1429,8 +1429,8 @@ static void guc_exec_queue_stop(struct xe_guc *guc, struct xe_exec_queue *q)
 			    !xe_sched_job_completed(job)) ||
 			    xe_sched_invalidate_job(job, 2)) {
 				trace_xe_sched_job_ban(job);
-				xe_sched_tdr_queue_imm(&q->guc->sched);
 				set_exec_queue_banned(q);
+				xe_sched_tdr_queue_imm(&q->guc->sched);
 			}
 		}
 	}
-- 
2.43.0



