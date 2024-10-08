Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B71C4613;
	Tue,  8 Oct 2024 12:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391693; cv=none; b=ry+vx+6Fcj4JZSc5zZ05R2kFLc/7AhWso0Sght3As+E4McisQaE4ibuLbBYGlBjwimXVExILL3prQG1fivAyFZrHLQv0XV5Ux+d+Tnm7vKc13fPaAzRoagFavPuqmfv1kL5AVx5jUTRIX/Gfl0O/+gW1HDzzaSds8Yim3Xlbr98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391693; c=relaxed/simple;
	bh=YwNb4eHhO/Z3v+kTOs8HM304MxYsmPCirlnja5iRukI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmjVnD9EchwWVyAVhVJOqPhHoGn0iLN5O7T+4ihuwus9qv6Q2F3Mivh7yqCYMiTkU/R+h+DR8X+XTJBuE1/ec0eXBCgTlTvyxyKw6LsbinzXfwJpDkH18qzOIssB8RgQvhgLBvm7432xyqIbiF1Of+6uq2idIWmF0Tc9i6IBZ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ2TT5Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ2TT5Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3B1C4CEC7;
	Tue,  8 Oct 2024 12:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391693;
	bh=YwNb4eHhO/Z3v+kTOs8HM304MxYsmPCirlnja5iRukI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ2TT5WkSwGywEbyVtSEU2WW+FPQayfgACj7pUNJ+vBEGge5vPThBIZCoK0sbyBLu
	 sM3UcFF/iwFfIKJaGF1sDpsqgHAOXFLFfK3x7asiD+VCi+pjNWreXZ2m3d8I2crPqA
	 ix/MuNwK52/A9NwEL/oG2GJo7X0PUZF58rpi/rk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 194/558] rcuscale: Provide clear error when async specified without primitives
Date: Tue,  8 Oct 2024 14:03:44 +0200
Message-ID: <20241008115709.985638302@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b53a9e8f5904f..f88c75b3cea3b 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -499,7 +499,7 @@ rcu_scale_writer(void *arg)
 			schedule_timeout_idle(torture_random(&tr) % writer_holdoff_jiffies + 1);
 		wdp = &wdpp[i];
 		*wdp = ktime_get_mono_fast_ns();
-		if (gp_async) {
+		if (gp_async && !WARN_ON_ONCE(!cur_ops->async)) {
 retry:
 			if (!rhp)
 				rhp = kmalloc(sizeof(*rhp), GFP_KERNEL);
@@ -555,7 +555,7 @@ rcu_scale_writer(void *arg)
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



