Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775022;
	b=nHrZT1ybOiF7Cyl81UaOaOfthI5yAUxuso7C5dhPNLPFwPuyuBp4068xoOf+1RBSChhV
	 Ri4g5fikifAUO5LBtQIah7f7MQVGaFluxRff9Hf5YOuVLTtlNTblwE2BzVcuciMrKNtJ8
	 wqJEOiX+3Ha7WRIojzb40HqN9RBbnkGYNE506wGeBCbJK7bHu5TwsZIwMnaZkeCWCFSfK
	 r+glYwWRVvxwuMKe+cHEfg6Y6ezcxEludhVvUVzs8kBXulI8CAfS3cE3aV0PnOTlqkjOj
	 akn9No+ILC3ahT4kBXi0CdSfmkfjpWbZGFKf36TfauQn89GnVt821fpzpnocOLIc6Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6KNIpdftuqhEQZ6vLllPf63pef5VWPpjV2e4OEnLOrc=;
	b=HigOhdT2ry1pBj6CQuetBryWLEoHHj2VwDDxheYCoEhcAgGGwxY7vbAQf7FHlBXlfIW8
	 F4xchQ0+c0UR0s90RrSszx0NmU6XFG7tPC5RSDZTwunI70tpudSciQOh8sUdmL1oocX76
	 IzvRjpF6vaBAgdSORboG9unnKF3PmdeF68XoEEZhlcb7UgyV/0loTOeixj1y1umWUcYUi
	 tY00Mry4Y6YemA6CTU2iU5vNHSPROPnW6cVoKdfEpmBwJpK1VJFHQZ3eHbgbRV4iexRmw
	 oX1thKj86Xi+cQdcoN3JEE23uelbWoVoq7VyR6M+UUX6rReX5a65re3E26/Z4F7pCgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYpMd3PD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7999E606A32C;
	Fri, 23 Oct 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYpMd3PD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BAE1F01825;
	Fri, 23 Oct 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775022;
	bh=6KNIpdftuqhEQZ6vLllPf63pef5VWPpjV2e4OEnLOrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYpMd3PDjZr15sCH9LrIMvGb1qC9+co68wTv8x+QUugPTY8acGpSJLbK5hwtLh0R3
	 tIrLUPLsS5iWRlEXZtC21u8vBPeD644XGBW+NvkF44r8NL+j/W42TYrRal2EDYy/bW
	 gdlQEdtsU8N1vG8whKJF7tC6SYZtlxZVoq20kEsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 235/242] sched_ext: Fix the bypass dispatch claim for schedulers bypassed by an ancestor
Date: Fri, 23 Oct 2026 18:41:17 +0200
Message-ID: <20261023163719.409676525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5bdeca322a6f8d10acaf67cccab1f69747ee7be3 ]

scx_bypass() claims bypass dispatch when the scheduler's depth goes from
zero to one and releases it when the depth returns to zero, but propagates
only the depth to the descendants, not the claim. A descendant that starts
bypassing with its ancestor never claims, and one whose own bypass ends
under the ancestor's keeps its claim, as its depth does not return to zero.

A sub-scheduler enable whose bypass ends under a PM suspend thus leaks its
claim: the parent keeps hosting bypass dispatch and the sub-scheduler's next
bypass trips the WARN_ON_ONCE() on the claim. A sub-scheduler disable that
starts under a PM suspend has no claim, so once the resume lifts the root's
bypass its tasks sit on the parent's bypass DSQs with nobody consuming them.

Claim for every descendant whose depth goes from zero to one in the
propagation and release every scheduler in the subtree whose depth returned
to zero once the tasks have moved out of the bypass DSQs. A parent that is
bypassing itself when a descendant claims consumes only its own bypass DSQs,
empty until it leaves bypass and becomes the host.

Fixes: aa2a0a19686c ("sched_ext: Separate bypass dispatch enabling from bypass depth tracking")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ sashal: Changed scx_disable_bypass_dsp() calls to disable_bypass_dsp(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -5717,15 +5717,12 @@ static void enable_bypass_dsp(struct scx
 
 	/*
 	 * When a sub-sched bypasses, its tasks are queued on the bypass DSQs of
-	 * the nearest non-bypassing ancestor or root. As enable_bypass_dsp() is
-	 * called iff @sch is not already bypassed due to an ancestor bypassing,
-	 * we can assume that the parent is not bypassing and thus will be the
-	 * host of the bypass DSQs.
-	 *
-	 * While the situation may change in the future, the following
-	 * guarantees that the nearest non-bypassing ancestor or root has bypass
-	 * dispatch enabled while a descendant is bypassing, which is all that's
-	 * required.
+	 * the nearest non-bypassing ancestor or root. The parent hosts them
+	 * unless it is bypassing too. Then they sit further up and the parent
+	 * consumes only its own bypass DSQs, empty until it leaves bypass and
+	 * becomes the host. Either way the nearest non-bypassing ancestor or
+	 * root has bypass dispatch enabled while a descendant is bypassing,
+	 * which is all that's required.
 	 *
 	 * bypass_dsp_enabled() test is used to determine whether to enter the
 	 * bypass dispatch handling path from both bypassing and hosting scheds.
@@ -5818,16 +5815,19 @@ static void scx_bypass(struct scx_sched
 	 * Bypass state is propagated to all descendants - an scx_sched bypasses
 	 * if itself or any of its ancestors are in bypass mode. A descendant's
 	 * depth is the sum of its own bypasses and its ancestors', so every
-	 * call propagates whether or not @sch changed state.
+	 * call propagates whether or not @sch changed state. The descendants'
+	 * claims are released below with @sch's, after their tasks have moved.
 	 */
 	raw_spin_lock(&scx_sched_lock);
 	scx_for_each_descendant_pre(pos, sch) {
 		if (pos == sch)
 			continue;
-		if (bypass)
-			inc_bypass_depth(pos);
-		else
+		if (bypass) {
+			if (inc_bypass_depth(pos))
+				enable_bypass_dsp(pos);
+		} else {
 			dec_bypass_depth(pos);
+		}
 	}
 	raw_spin_unlock(&scx_sched_lock);
 
@@ -5903,8 +5903,12 @@ static void scx_bypass(struct scx_sched
 	}
 
 	/* disarming must come after moving all tasks out of the bypass DSQs */
-	if (!bypass)
-		disable_bypass_dsp(sch);
+	if (!bypass) {
+		guard(raw_spinlock)(&scx_sched_lock);
+		scx_for_each_descendant_pre(pos, sch)
+			if (!pos->bypass_depth)
+				disable_bypass_dsp(pos);
+	}
 unlock:
 	raw_spin_unlock_irqrestore(&scx_bypass_lock, flags);
 }


