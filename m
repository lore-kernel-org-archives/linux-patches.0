Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4497119B3FF;
	Tue, 15 Oct 2024 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993554; cv=none; b=pmdGA/mQIymZYQuqNAemTT5MWTXnREWjO2di2ZSNNoHab+JiCtbZT98Edw3fwiUeB8PxX5Bwwx/M4GGtuelqx1eRvVo0TxMLUuYVotbdVViZZHGireygnyRdARJdg8lOVR+iy9W8HDRtfXtZPxhrje6Harrj1ToPJk9iSbYyAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993554; c=relaxed/simple;
	bh=myBGadC8f3sFZO2G100cEvMFBmX88w6tEu2tvejQpvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj+y9s5aICEkUjcigYGZRTwNDRkLa7MET3gERZPoCrMFBeCAJJTLBWX6eWXY2TXWmSWzHQ/7HTVim/Ia1JdquPUJvFcI6HQ26BSdWJxxGIC+RSGfOWKVdcwsmDIG/ZeSpwMtZe0/TVUdvYpUW5IUimEx4AV4C88XBt/29m/y61A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxx66o0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxx66o0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75F7C4CEC6;
	Tue, 15 Oct 2024 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993554;
	bh=myBGadC8f3sFZO2G100cEvMFBmX88w6tEu2tvejQpvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxx66o0yLlZm4BTVilNTrwIQNIzTVMwaM5VVr6G2RLORspJASM+IcJVYzw8xZ5exW
	 Z0vRez+et0QpH22qxFMEAdDIL8bISG024mE2fPD2PATzxEhNzTwSZDxMIjCF+RMcO+
	 ouet55DIsj9/BwDZUCZ2twVkypNMRe8dw7oP4OL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/691] rcuscale: Provide clear error when async specified without primitives
Date: Tue, 15 Oct 2024 13:26:33 +0200
Message-ID: <20241015112458.009707086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 11377947b5861fa59bf77c827e1dd7c081842cc9 ]

Currently, if the rcuscale module's async module parameter is specified
for RCU implementations that do not have async primitives such as RCU
Tasks Rude (which now lacks a call_rcu_tasks_rude() function), there
will be a series of splats due to calls to a NULL pointer.  This commit
therefore warns of this situation, but switches to non-async testing.

Signed-off-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index a83cb29d37607..f90955dc15327 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -428,7 +428,7 @@ rcu_scale_writer(void *arg)
 			udelay(writer_holdoff);
 		wdp = &wdpp[i];
 		*wdp = ktime_get_mono_fast_ns();
-		if (gp_async) {
+		if (gp_async && !WARN_ON_ONCE(!cur_ops->async)) {
 retry:
 			if (!rhp)
 				rhp = kmalloc(sizeof(*rhp), GFP_KERNEL);
@@ -484,7 +484,7 @@ rcu_scale_writer(void *arg)
 			i++;
 		rcu_scale_wait_shutdown();
 	} while (!torture_must_stop());
-	if (gp_async) {
+	if (gp_async && cur_ops->async) {
 		cur_ops->gp_barrier();
 	}
 	writer_n_durations[me] = i_max + 1;
-- 
2.43.0



