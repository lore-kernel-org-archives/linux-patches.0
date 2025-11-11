Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1594C97;
	Tue, 11 Nov 2025 00:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822461; cv=none; b=cL7bNTcs7m7RtvaMeeMyv6xejewEEfS+s2hdANQzB6fNQ7nZ+ah5R+mmlRk4xAeXwHY72cq4UKdN59JZDoQIqsngf2EZ8+PgXLHIUIF4q7KLEE+76hypOdNXq+y0yWgou7eCcSRrvdgIM9EbMhohqKNo8GaS4vDk1tjt8PXbFUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822461; c=relaxed/simple;
	bh=mvUcSCKbsw0EMw96wBPEYFmS4tb8tdUi1Buqcc+hhgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5j0JEjGTe2PByLARW9Eu+WRpl9bY/BwsedXt6uLUH8A0j7zAlQJIizjYQEylCTFcLBtYBrIOBZIT68DPr7+q7bDBwIgEKVA3vpIm1wAuwld/rcpgAZnVbQLp44tkea3Xvqf82ViGRlG9vsVBgi2Vk2Z0IjLtxVPdpkehC6bXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uWvtCWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uWvtCWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D51C113D0;
	Tue, 11 Nov 2025 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822460;
	bh=mvUcSCKbsw0EMw96wBPEYFmS4tb8tdUi1Buqcc+hhgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uWvtCWLxqaE+Q8mi6pvsC5q4QimFmYVcuhVTkOBOCk00wykvBhEbiguFfLsnIRS0
	 m7bi0IPITw0fKHdaxr7+xIbnageQvt0ssjbmMKJ66Jmd7TIsTbPmYOfKgf9z4Xu5Em
	 EB1Q23l6qtIPfTkDZw5E+uOAgs1J6jbJlwASMxtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/849] cpuidle: governors: menu: Rearrange main loop in menu_select()
Date: Tue, 11 Nov 2025 09:34:42 +0900
Message-ID: <20251111004539.103669751@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 17224c1d2574d29668c4879e1fbf36d6f68cd22b ]

Reduce the indentation level in the main loop of menu_select() by
rearranging some checks and assignments in it.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/2389215.ElGaqSPkdT@rafael.j.wysocki
Stable-dep-of: db86f55bf81a ("cpuidle: governors: menu: Select polling state in some more cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |   70 ++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -311,45 +311,47 @@ static int menu_select(struct cpuidle_dr
 		if (s->exit_latency_ns > latency_req)
 			break;
 
-		if (s->target_residency_ns > predicted_ns) {
-			/*
-			 * Use a physical idle state, not busy polling, unless
-			 * a timer is going to trigger soon enough.
-			 */
-			if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
-			    s->target_residency_ns <= data->next_timer_ns) {
-				predicted_ns = s->target_residency_ns;
-				idx = i;
-				break;
-			}
-			if (predicted_ns < TICK_NSEC)
-				break;
-
-			if (!tick_nohz_tick_stopped()) {
-				/*
-				 * If the state selected so far is shallow,
-				 * waking up early won't hurt, so retain the
-				 * tick in that case and let the governor run
-				 * again in the next iteration of the loop.
-				 */
-				predicted_ns = drv->states[idx].target_residency_ns;
-				break;
-			}
+		if (s->target_residency_ns <= predicted_ns) {
+			idx = i;
+			continue;
+		}
+
+		/*
+		 * Use a physical idle state, not busy polling, unless a timer
+		 * is going to trigger soon enough.
+		 */
+		if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
+		    s->target_residency_ns <= data->next_timer_ns) {
+			predicted_ns = s->target_residency_ns;
+			idx = i;
+			break;
+		}
 
+		if (predicted_ns < TICK_NSEC)
+			break;
+
+		if (!tick_nohz_tick_stopped()) {
 			/*
-			 * If the state selected so far is shallow and this
-			 * state's target residency matches the time till the
-			 * closest timer event, select this one to avoid getting
-			 * stuck in the shallow one for too long.
+			 * If the state selected so far is shallow, waking up
+			 * early won't hurt, so retain the tick in that case and
+			 * let the governor run again in the next iteration of
+			 * the idle loop.
 			 */
-			if (drv->states[idx].target_residency_ns < TICK_NSEC &&
-			    s->target_residency_ns <= delta_tick)
-				idx = i;
-
-			return idx;
+			predicted_ns = drv->states[idx].target_residency_ns;
+			break;
 		}
 
-		idx = i;
+		/*
+		 * If the state selected so far is shallow and this state's
+		 * target residency matches the time till the closest timer
+		 * event, select this one to avoid getting stuck in the shallow
+		 * one for too long.
+		 */
+		if (drv->states[idx].target_residency_ns < TICK_NSEC &&
+		    s->target_residency_ns <= delta_tick)
+			idx = i;
+
+		return idx;
 	}
 
 	if (idx == -1)


