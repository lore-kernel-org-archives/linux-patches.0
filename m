Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F91118C32F;
	Tue, 10 Sep 2024 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963843; cv=none; b=lOml/PonO12Q4iG90nNljPsS1RLVswrtmM0WYK+5fdFZhT6dJGzql+n8jMhUW014brbtd5GVrGexFwih2xbev9sF3CCRo9TcNtvU+oqdu2ktOLHha2593gqklKSJauiMuGo8ORIftFsbIdidT7yP6CrStlcvfijyxqqnOvOM12c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963843; c=relaxed/simple;
	bh=F2FPTDYJocgqpbMu/nYUCRcBRbgxtNyxpwEOzY0/JXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm+789fv9coE89Vd1lpxc1+chTpU01gLRdWRvpfr5LP4sCtRmc+vlKo0p2sT8nOLUcmgtfSlU5rMOI1yQZr4orHWJpkEAvvNujuLyDR/UnjocCImeoTTxzLpQZNE3z65B7HeL2/I82A10CGK29SlmRpaYg53w3gZpIJDeKLjkIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ut/J3BKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ut/J3BKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB224C4CEC3;
	Tue, 10 Sep 2024 10:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963843;
	bh=F2FPTDYJocgqpbMu/nYUCRcBRbgxtNyxpwEOzY0/JXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut/J3BKdZd713kYt46udPqePgplqTYiqybQlsns8G1D/9nQJsrSYoJlVsCisErVgK
	 5Y3TBVJ+5VPQihJjtvhWKS8KYx7EAs2Yv3F7Kw/ALvs/4LwjWg4BGX8mb5NEbhpgi+
	 vfbdr/Rf/ziAWkrvTVmio7Zl3OsYk632Kyitddi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/214] workqueue: wq_watchdog_touch is always called with valid CPU
Date: Tue, 10 Sep 2024 11:33:37 +0200
Message-ID: <20240910092606.571051663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 18e24deb1cc92f2068ce7434a94233741fbd7771 ]

Warn in the case it is called with cpu == -1. This does not appear
to happen anywhere.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d5f30b610217..f7975a8f665f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5937,6 +5937,8 @@ notrace void wq_watchdog_touch(int cpu)
 {
 	if (cpu >= 0)
 		per_cpu(wq_watchdog_touched_cpu, cpu) = jiffies;
+	else
+		WARN_ONCE(1, "%s should be called with valid CPU", __func__);
 
 	wq_watchdog_touched = jiffies;
 }
-- 
2.43.0



