Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A325DB07;
	Fri, 30 May 2025 12:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608836; cv=none; b=AoC8IXQBQcGFasKGQGvrfmYh4QJDbGCWOrOn7fAI8Xy1272o8vEoOKgmrJkZetIv2DfXYG+Sgd0EiRdJZlNfXkkmHDCiD9ckagaAFoRConesDpHswHIQCRxq9iBWxvTu7i0rnE0mKWn0VDLrv9BP+tI9ilEbWf9nebYlnUv0Tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608836; c=relaxed/simple;
	bh=ssMh6Pq3EsUJGw+m0SZS3RyYe3UDHpEtnFhXPTNIWOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TetHaBnSDrpD88zqZcAbnVPBSBNp6TecgBrHSVOWlWZXIrNsmz3/QzAOWC+MsrJ28Sqe3tI5uqYe1A6F65AXLENjKxFKPeFVdOO1Hi5Hy+iTyDYm/7w1zYBWNNLdJYwB0RgMNpzbMbtSVvdIwr38xiH7GAUKQ6C8BfNZPbmGdfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFZm+eHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFZm+eHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57056C4CEE9;
	Fri, 30 May 2025 12:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608835;
	bh=ssMh6Pq3EsUJGw+m0SZS3RyYe3UDHpEtnFhXPTNIWOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFZm+eHt3AH6/8P82ItJlwNScDmSzLAvyOGG5DLmh0p9q542b0mO4hrHCT1Oj1tbo
	 +BDJsqpXlp2cESvhMRDoLQbSOo9+tSAWxqfVR0Y1h6yhsdLsvd+Pp8c59VMVZ2yHHE
	 P6HthlyHhXoQW3rh+6COL8ry+1xo4vrfHN98Tg5ipWydANtzLSbH5argB3GhkUK2h7
	 6RoIbTSic3gMtU1wip3nMkB1yUffJ9ONan9vJUnNiqPP343mx30Uf92u8ILnqDp2uu
	 rfNtfzsCOwHTqBbHZaI7a0rSmETPjhVRRkcQih/qC/HQfWOnMxTJCcttM1WHSvyk8D
	 wB3OcjoRRyEcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 17/26] pmdomain: core: Reset genpd->states to avoid freeing invalid data
Date: Fri, 30 May 2025 08:40:03 -0400
Message-Id: <20250530124012.2575409-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 99012014c902cd9ad85fd288d8a107f33a69855e ]

If genpd_alloc_data() allocates data for the default power-states for the
genpd, let's make sure to also reset the pointer in the error path. This
makes sure a genpd provider driver doesn't end up trying to free the data
again, but using an invalid pointer.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20250402120613.1116711-1-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on the detailed analysis of the code and the commit changes, I can
now provide a comprehensive answer. **YES** This commit should be
backported to stable kernel trees. Here's my extensive analysis: ## Bug
Analysis The commit fixes a memory management bug in the power domain
subsystem's error handling path. In `genpd_alloc_data()`, when default
power states are allocated via `genpd_set_default_power_state()`, the
function sets: - `genpd->states = state` (pointing to allocated memory)
- `genpd->free_states = genpd_free_default_power_state` However, in the
error path (`put:` label at line 2197-2198), the code frees the
allocated states memory with `kfree(genpd->states)` but **does not reset
the pointer to NULL**. This leaves a dangling pointer in
`genpd->states`. ## The Problem If `genpd_alloc_data()` fails and
returns an error, but the genpd provider driver later tries to clean up
and calls `genpd_free_data()` (which happens in `genpd_remove()` at line
2214), the following sequence occurs: 1. `genpd_free_data()` checks `if
(genpd->free_states)` - this is still set to
`genpd_free_default_power_state` 2. It calls
`genpd->free_states(genpd->states, genpd->state_count)` 3. This results
in `kfree(genpd->states)` being called on already-freed memory (double-
free) This is a classic use-after-free/double-free vulnerability that
can lead to memory corruption, crashes, or potential security issues. ##
The Fix The fix is simple but crucial: after `kfree(genpd->states)` in
the error path, it adds `genpd->states = NULL`. This ensures that: 1.
The dangling pointer is eliminated 2. Future calls to
`genpd_free_data()` will call `kfree(NULL)`, which is safe and does
nothing 3. No double-free occurs ## Backport Criteria Assessment **1.
Does it fix a bug that affects users?** YES - This can cause kernel
crashes and memory corruption when power domain initialization fails.
**2. Is the fix small and contained?** YES - It's a single line addition
(`genpd->states = NULL`). **3. Does it have clear side effects?** NO -
Setting a pointer to NULL after freeing it is a standard safe practice
with no negative side effects. **4. Major architectural changes?** NO -
This is a simple bug fix in error handling. **5. Critical kernel
subsystem?** YES - Power domain management is critical for power
management across many devices. **6. Explicit stable mention?** NO - But
this type of memory safety fix is exactly what stable trees are for.
**7. Follows stable rules?** YES - Important bugfix with minimal risk.
## Risk Assessment **Risk: MINIMAL** - The change only affects the error
path and makes the code safer by preventing double-free. There's
virtually no risk of regression since it only changes behavior when an
error has already occurred. ## Similar Commit Patterns This follows the
same pattern as **Similar Commit #1 and #4** which were both marked as
**YES** for backporting - they fix memory management bugs in the same
subsystem with minimal, contained changes that improve robustness
without architectural changes. The fix prevents a potential security
vulnerability (memory corruption) and improves system stability, making
it an excellent candidate for stable tree backporting.

 drivers/pmdomain/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 05913e9fe0821..9e619678a29bd 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2193,8 +2193,10 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 	return 0;
 put:
 	put_device(&genpd->dev);
-	if (genpd->free_states == genpd_free_default_power_state)
+	if (genpd->free_states == genpd_free_default_power_state) {
 		kfree(genpd->states);
+		genpd->states = NULL;
+	}
 free:
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
-- 
2.39.5

