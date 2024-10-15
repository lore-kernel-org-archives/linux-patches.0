Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CCD1C07FF;
	Tue, 15 Oct 2024 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997919; cv=none; b=LAIJZRG2wur6AMzrtXR+AO40EHYn1VtdYHchzhvX3lEHsvDXWKfX+OKkomoBXcEA0mN8vlwTO+wbVganWp8fc5icfew2c5WhEr5TbtrI7GqHJVOl+HrIR5sGaq1UYz0ZKX/gRIBydYFM7199mjm2VeYiEPUfnRNZnVxwO2wOv6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997919; c=relaxed/simple;
	bh=UjqbBCNC0Qa+4fNF8ZIGFnCIdvfu1URxP1L8SKepnP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVQYXJ4REPehVYO8YAMe2hBF5dYw2JhuCUrmkdu7+EJRE3cArEWeHOPAp6r5T3BcCA/xwwjwE2oV3OI1bYjsVKfBZXzd1UBrbm+4CXvPSc/WLtyb3Ic+++m55l7XLKsW5Tnr7SjPUwP/l079rdyV9lNo/IpC17dDcGZm9k4Zn10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYhZWM1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYhZWM1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBE3C4CECE;
	Tue, 15 Oct 2024 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997919;
	bh=UjqbBCNC0Qa+4fNF8ZIGFnCIdvfu1URxP1L8SKepnP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYhZWM1NbXc9bMskmBE3PdbITdI/GJWnTCqoHdEebMlh+M+d/vpMvjCjM5NhS80TX
	 DwLjynGqVGlecaplYFvyWxcBnGLD+yDAYf8hUd41BIWMsB5xAfqiXIA4ZR3B3mGJYz
	 OBUcxwfbKhaJ8WKN5ZEI0st7nXMkwAH2tkrWidWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/518] rcuscale: Provide clear error when async specified without primitives
Date: Tue, 15 Oct 2024 14:43:50 +0200
Message-ID: <20241015123929.561803833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b9783eda6796..cfe861bac1bd4 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -398,7 +398,7 @@ rcu_scale_writer(void *arg)
 			udelay(writer_holdoff);
 		wdp = &wdpp[i];
 		*wdp = ktime_get_mono_fast_ns();
-		if (gp_async) {
+		if (gp_async && !WARN_ON_ONCE(!cur_ops->async)) {
 retry:
 			if (!rhp)
 				rhp = kmalloc(sizeof(*rhp), GFP_KERNEL);
@@ -454,7 +454,7 @@ rcu_scale_writer(void *arg)
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



