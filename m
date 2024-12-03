Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE151F893D;
	Tue,  3 Dec 2024 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240281; cv=none; b=gPaOTmO5c2JiAb0na4fjFiRsoU6CcSPedkJYa80/uFJkZTfhqDNjmCOhjZrRqyY6aP30NhF98IHCxj6cZbITKCKNsHsmJGTCFbJbsUH5bWE9sy4xvynBgKv8eCJ//x9t4DjmqJxoQ8tO0ce8hvfBaUKyf53uR24O56o2NbU0YAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240281; c=relaxed/simple;
	bh=by/h09U+gTUro1C3GMS0IFglHX3GNZsSsjWFL5qwIFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO65GpLtc7p/LJw0sDczMcgfUT3qw4X8BPQKe5Y2ddwNUW9cFdgOVZqgNpvgaoCzJRy0N1RSqO7CXGhzS7BCee3OOHJT8kOA33iXsbUcAPshKBPmkSMUTq2+Ci2BkI2zY7XO4ur49ilCsQk1tPUURUpLFUU4i9+D/LmF5oBa380=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj0TaiT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj0TaiT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CA6C4CECF;
	Tue,  3 Dec 2024 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240281;
	bh=by/h09U+gTUro1C3GMS0IFglHX3GNZsSsjWFL5qwIFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj0TaiT6zA4wIaWWJzWcgs9Ar4CIPaPjBBcFvASuzlC/HB9uZZ2rMZEVWTntG9T8I
	 nImDM/HgSVyBg61TiJi1YpMycXpXMkbVmDZQAejOm+BLOu165qs+cxkN7R77qloWwY
	 gE2UzIV++X49hkENywo/6LIOHVSOT4pLukyTPnZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Michal Schmidt <mschmidt@redhat.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/826] rcu/srcutiny: dont return before reenabling preemption
Date: Tue,  3 Dec 2024 15:36:35 +0100
Message-ID: <20241203144746.124928446@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



