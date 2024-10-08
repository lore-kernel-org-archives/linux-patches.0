Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5011DE88F;
	Tue,  8 Oct 2024 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390014; cv=none; b=fq+R44xljBTe0Sn5V72vdHeed/MJujv+3epQJH29u9U7FmbYWNrGar4QbE+VSxGkiVeNHidoZ9d7LJy+dpmMPGNoN74m6YAOSAIp2lflYgBmutnkm+qmgY4mGgQ2TnkZT3jumvAZYPbf/MExRFpdZdv0Bn1G6hpRlvK//xICyEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390014; c=relaxed/simple;
	bh=mUKto5OliWA5AJE3T0klG7C/g4GT4ZDTvikvfHwAidA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmgZ9TPk3ZJ6D1T/PD3UP/Rg0d6XUmQQXuRuZS665rvC6rm7v4F7C+gG2+G07MPcERSHSgLwPS18dFPFDkTLoZcvZJc1kTN5hV11CpMfEXAZd5w4J0UbirH12DN3G7Xw5XtkprAA0VODJGGsES4+1tx2pTiUU9gf8uHaRWO580U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNMJAigZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNMJAigZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41360C4CEC7;
	Tue,  8 Oct 2024 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390014;
	bh=mUKto5OliWA5AJE3T0klG7C/g4GT4ZDTvikvfHwAidA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNMJAigZGbNTMbl1ih1m6ZGfFO+PFyagxh/5q7HViXqdaoLcOJOKmUiEDqoC4R127
	 /3hr9w302/bmCFA4+IxkmEtHvmXaSZeKrYV+KZ4qmu1aolfSAS/lQgEGI5n0S9PN0U
	 n/NW8fJoObmKiOZWZIsBoRntyNaiuhesCQHKGJsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/482] rcuscale: Provide clear error when async specified without primitives
Date: Tue,  8 Oct 2024 14:03:48 +0200
Message-ID: <20241008115654.798622859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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
index 8db4fedaaa1eb..a5806baa1a2a8 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -498,7 +498,7 @@ rcu_scale_writer(void *arg)
 			schedule_timeout_idle(torture_random(&tr) % writer_holdoff_jiffies + 1);
 		wdp = &wdpp[i];
 		*wdp = ktime_get_mono_fast_ns();
-		if (gp_async) {
+		if (gp_async && !WARN_ON_ONCE(!cur_ops->async)) {
 retry:
 			if (!rhp)
 				rhp = kmalloc(sizeof(*rhp), GFP_KERNEL);
@@ -554,7 +554,7 @@ rcu_scale_writer(void *arg)
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



