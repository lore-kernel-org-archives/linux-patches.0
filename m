Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007991DFD80;
	Wed, 19 Feb 2025 09:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957014; cv=none; b=ApeIe4f9Q3wqdxPr1d9qPGKDSymxkuKI+nKWQQgZGB/wJtaFdF84yZ8g8NGL2KPUkGfRPMIjCZdZ/gACH0WtLB9T7XHyw9NEwbK/kjvJzL+zBKSbbwmpyBNyyEPjHIc98c+v3O6HsAjT5x9CrmtDbNXyhxfJKbsDj6FWf+jGZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957014; c=relaxed/simple;
	bh=UQzChL/mTVGyn5j7AE1f+l2lKKyaMtKu4iVCwquD86o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkoHiDOq0E8/sFSrwuXSSttmh1ITLYJoRgy8My0sHp6TkKyrce7/JNY8GDh6eN7dx5EZ1BxtUE4hnAekhnH6e087wWbk+OpQKhswQWeHhWWId5VbJbIxTrGZYeG9Q65dTUIfOj16GOBofDyj+HzSdCzpXbNYJLAxhFiFv9qMCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpKbKGXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpKbKGXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE73C4CEE6;
	Wed, 19 Feb 2025 09:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957013;
	bh=UQzChL/mTVGyn5j7AE1f+l2lKKyaMtKu4iVCwquD86o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpKbKGXGlQkRiSzZDHwF+/Wo4q1Kej11s5fFwY/qvTRRhNQLADAn4W6k+i40OXu4L
	 w/iA0V5T970V5N2IczZoPMV9apDy7tKzSO6ZKceABlvsM+9Xm+rpSacmhBGzohQE2G
	 l4aGF2RDPHe+l5I9ngSiKmM/0c45WjpYLRqDc9uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 351/578] drm/i915/guc: Debug print LRC state entries only if the context is pinned
Date: Wed, 19 Feb 2025 09:25:55 +0100
Message-ID: <20250219082706.828361155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4764,12 +4764,20 @@ static inline void guc_log_context(struc
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


