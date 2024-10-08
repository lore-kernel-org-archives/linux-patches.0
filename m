Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DC31D3653;
	Tue,  8 Oct 2024 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393455; cv=none; b=cAzB9eM8XgKDQsFd6V5QmYTCGwILx5DEyjBTdOanFHgdRP5ydKVQEGWe7m64KPIEkiTm5StBifPpKnKTRTuPwdebX/aRuM2pd8cYZxTOvcfVld0J0K1gc/epSnZvJB3nAMTsW90rV3ce7IRdUDzRvHcQIZilMJVGwQtUvX6YCqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393455; c=relaxed/simple;
	bh=CmGtCu+RCzcJumzlvBGnj5+J0H2gPmrzaQF7wlfg844=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyIiWWNXgZyMP1F7pVM9biK3heCPPo+zTD3dAlGz1zcmv0tUYLMfi10lPEZa2rcOMMKKrsiGoVHXt6BXmazRTuZTjtlT0gfW2qYKCzTf0n9DIRjnmBXLr1eSYphnYBxSrxLhcXcTsKXdPu6jneUT5poFYruah5MTF8OcM3+ICvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVj5ojr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVj5ojr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4024C4CEC7;
	Tue,  8 Oct 2024 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393455;
	bh=CmGtCu+RCzcJumzlvBGnj5+J0H2gPmrzaQF7wlfg844=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVj5ojr13Iwg+IimV7Ha9LFtf07f58jdEghfFNqFZzr6j4xMmA3wMUCHcfrHX7pb2
	 mK5q//cWOcs7EOqGjijXa2hjeKgwONG7Le7q1kkAq3sLQVOn+N1U4jxYhtXrLxLzqd
	 TRFBsYFVsnq3vKQL+I4ZVveqsnRrv6TvKm6fUEaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/386] rcuscale: Provide clear error when async specified without primitives
Date: Tue,  8 Oct 2024 14:06:11 +0200
Message-ID: <20241008115634.395128864@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ffdb30495e3cc..ed46d9e8c0e43 100644
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



