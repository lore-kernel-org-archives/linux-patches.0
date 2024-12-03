Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7791E1F7555;
	Tue,  3 Dec 2024 14:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237950; cv=none; b=D+bgoYLPqra99QvQnxv+OIb3hj97sj6Wbb0q5p2CTt/JNneHf+ujqUb10Jx815/9dVHJDvtiWfQcgGhVlFqiCTFd+A0HnFiY2kKunKXnvqzc+LQeVS/0HHKAQ8KrUJZu2NJUU4IqLEESSFHzE+aiKI1n2GOVIi27akcRGxYOgas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237950; c=relaxed/simple;
	bh=DAG+jv6j4xu6vNp2VX1wbLVOnDR5gJUH3tSqUo4H9ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXdnyB2MGcnwlAjvONK6F9UoSX+Zm20U/vgGb6IaD1vEkogxL9lsAF/ltrE2vOCr55Ptp/P2V+8p71IOOLbPL9crtqDaaQWbMIbup8d6D1Q2rsj+eYj90RYvLaT0/jqLjLrgntjOW475b0mdqqV4VeOL61nyOrDkKbMpj6Y+uWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciq0yI24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciq0yI24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DECC4CECF;
	Tue,  3 Dec 2024 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237950;
	bh=DAG+jv6j4xu6vNp2VX1wbLVOnDR5gJUH3tSqUo4H9ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciq0yI24P63sHUP61hrmJrPaH1nio187/PYfbovBiPJoxgpWGei7BUfcbqMFoIfig
	 cc2ni+ZwScY/KpbbhXbeUgV2KwdaVHAG+jF1tobisoKcHqCkxTLgfFvM0/RGxTlol+
	 UbWLFV2paNYvyCABy/NTLabP1emcSaz0V+KJH0f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Michal Schmidt <mschmidt@redhat.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 117/817] rcu/srcutiny: dont return before reenabling preemption
Date: Tue,  3 Dec 2024 15:34:49 +0100
Message-ID: <20241203144000.282498682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 0ea3acbc804c2d5a165442cdf9c0526f4d324888 ]

Code after the return statement is dead. Enable preemption before
returning from srcu_drive_gp().

This will be important when/if PREEMPT_AUTO (lazy resched) gets merged.

Fixes: 65b4a59557f6 ("srcu: Make Tiny SRCU explicitly disable preemption")
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutiny.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index 549c03336ee97..4dcbf8aa80ff7 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -122,8 +122,8 @@ void srcu_drive_gp(struct work_struct *wp)
 	ssp = container_of(wp, struct srcu_struct, srcu_work);
 	preempt_disable();  // Needed for PREEMPT_AUTO
 	if (ssp->srcu_gp_running || ULONG_CMP_GE(ssp->srcu_idx, READ_ONCE(ssp->srcu_idx_max))) {
-		return; /* Already running or nothing to do. */
 		preempt_enable();
+		return; /* Already running or nothing to do. */
 	}
 
 	/* Remove recently arrived callbacks and wait for readers. */
-- 
2.43.0



