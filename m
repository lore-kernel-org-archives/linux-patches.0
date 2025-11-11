Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F3F1DF258;
	Tue, 11 Nov 2025 00:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822578; cv=none; b=Oj/5PDsd2SC9O+TOoAK/4YZw6YpyaqfBMOUsWE0MtRYZPa5xaOxDQZ8f4cq9xkJQhDJuW/qXy7BH5Po8oL+bF0ottuFoHsL25ey5pvVaXyLWR6jiYYYLBOZGJQFNn3MrssqJsrPIiZkgRPGC5LLaVvijneaKxHwCMWjV8vAfvn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822578; c=relaxed/simple;
	bh=3qmZ1b8Q1hlNyowXQ6lD/lB2FX8iruQUWphvFN+TRnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/HUDRM0vQXYLBM1joj0gCp27/YiBvxlRXAUlS9s585b41IYmjlTvuLJBpvp/0rJ3BIn0Jj5jnMGVEPR7Suku6/jWqRDuGYaTCj381mYscX0kxqzYGV9XBG1A5Fz+LSoaea055GXJAIQSgvMPHiA/PXqROD9IBp+aqmMy7du+m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8d00Q/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8d00Q/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62A8C116B1;
	Tue, 11 Nov 2025 00:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822578;
	bh=3qmZ1b8Q1hlNyowXQ6lD/lB2FX8iruQUWphvFN+TRnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8d00Q/8l0bKcxQFjNrsws3gwV8c+oVm+7T8nBHxpGKBcCQmotZCS2iaFlB5toXpe
	 KiBn58K+mNm7nmbKLoW5EPvBYvb94jLPu5lP5WvfmZEJe6J5K5rHpZUrjeEGvzablz
	 s27BnKXsxNvw1BTSsZxRWlSWNwtNM7izYrbb7h0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/565] cpuidle: governors: menu: Rearrange main loop in menu_select()
Date: Tue, 11 Nov 2025 09:38:54 +0900
Message-ID: <20251111004528.721801769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -317,45 +317,47 @@ static int menu_select(struct cpuidle_dr
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


