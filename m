Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E5281379;
	Thu, 13 Feb 2025 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457721; cv=none; b=WRojIJj9jaFbc7Kdco/zHdP7M8NxzNA0BGriCh8fGwHUAsLwhC7smncmf1X/9Q/Xam8HDKc77ZhR9Pm97q2xYc0IYKkYFR/dx2/6UlQrgkYSQ/CfBbuEOYlOkwqt9GetVrXR8lqnkEHO8ZlZv3fJD94l+IeE5Tq+jgsdVDjs588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457721; c=relaxed/simple;
	bh=yijXTmy5PHwLBQoJ2flTmk4cWfLWdGiHEvK4/4cU7cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8exn/CWTWsXC8YXHl8uhVkV8xUw6JFaP/HzNePDq35WDGOXIjopLBVlaqWx5glJ/vuYPEq7lZ5dTTL4bgjYKxuEbjIzxYI3qfLdhNLSJt0jLa8DO9pI9bDiVI84Op/r9C5yE29+remeclgMfMdtqSr3dZOCEhiaACCiMDLIxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxE+n7jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxE+n7jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A051AC4CED1;
	Thu, 13 Feb 2025 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457721;
	bh=yijXTmy5PHwLBQoJ2flTmk4cWfLWdGiHEvK4/4cU7cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxE+n7jhRTrFvbBi3KPOXGVo2nhUwhQgVfWWQfKUJILuu+oM9LMCqXR7MsbmaNPSd
	 K046gFIVJNWWxR56CZm0FcFHeCc+/EJRKCzvUESUGVFaEO0Grvc25Si8G6Ilo/ae79
	 UrGJdFIoIQjwN9yk1FWOJoUK0AfO6YcRn8m4HrfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 162/422] drm/i915/guc: Debug print LRC state entries only if the context is pinned
Date: Thu, 13 Feb 2025 15:25:11 +0100
Message-ID: <20250213142442.796138931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 57965269896313e1629a518d3971ad55f599b792 upstream.

After the context is unpinned the backing memory can also be unpinned,
so any accesses via the lrc_reg_state pointer can end up in unmapped
memory. To avoid that, make sure to only access that memory if the
context is pinned when printing its info.

v2: fix newline alignment

Fixes: 28ff6520a34d ("drm/i915/guc: Update GuC debugfs to support new GuC")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115001334.3875347-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 5bea40687c5cf2a33bf04e9110eb2e2b80222ef5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -5511,12 +5511,20 @@ static inline void guc_log_context(struc
 {
 	drm_printf(p, "GuC lrc descriptor %u:\n", ce->guc_id.id);
 	drm_printf(p, "\tHW Context Desc: 0x%08x\n", ce->lrc.lrca);
-	drm_printf(p, "\t\tLRC Head: Internal %u, Memory %u\n",
-		   ce->ring->head,
-		   ce->lrc_reg_state[CTX_RING_HEAD]);
-	drm_printf(p, "\t\tLRC Tail: Internal %u, Memory %u\n",
-		   ce->ring->tail,
-		   ce->lrc_reg_state[CTX_RING_TAIL]);
+	if (intel_context_pin_if_active(ce)) {
+		drm_printf(p, "\t\tLRC Head: Internal %u, Memory %u\n",
+			   ce->ring->head,
+			   ce->lrc_reg_state[CTX_RING_HEAD]);
+		drm_printf(p, "\t\tLRC Tail: Internal %u, Memory %u\n",
+			   ce->ring->tail,
+			   ce->lrc_reg_state[CTX_RING_TAIL]);
+		intel_context_unpin(ce);
+	} else {
+		drm_printf(p, "\t\tLRC Head: Internal %u, Memory not pinned\n",
+			   ce->ring->head);
+		drm_printf(p, "\t\tLRC Tail: Internal %u, Memory not pinned\n",
+			   ce->ring->tail);
+	}
 	drm_printf(p, "\t\tContext Pin Count: %u\n",
 		   atomic_read(&ce->pin_count));
 	drm_printf(p, "\t\tGuC ID Ref Count: %u\n",


