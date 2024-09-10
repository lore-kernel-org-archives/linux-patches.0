Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75624183CB0;
	Tue, 10 Sep 2024 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963183; cv=none; b=uvpfizpoSecajatUudOOOaXnlaT9+JzKBfzfaax5d7Yn06YJXrkKk2JlyRI0Wn5puKEUJbV3KK/RdyjVl3lmccSq1pdXDSmyWyLuGWUc+Wt/1vaz1dNyzwS8G5asLJZ6p/uFGWTlGq4ceFea42j5xLTTMAg26i8kfM9gAn//D8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963183; c=relaxed/simple;
	bh=zULc15tXiH4v5iM9vQutk6LLRXk1dz9xujc9rY3+uks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbc8xZkSGfnrAy9bu7qcFNftMTBtxAvP8DyLDeY/zSa1UWP3F5Mxjyi8K+nsqi2KFr9QCw2jAx2SPCx4Jhx7WqNQ4vS4e0oAjjD2UWHHlc6QCDaniEfwG1hyC19A5JqxfERM0RpvNKyWSmZPy4wvUm+mU/SpFbjk5A8TGg0jz1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hX+xItDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX+xItDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F307CC4CEC3;
	Tue, 10 Sep 2024 10:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963183;
	bh=zULc15tXiH4v5iM9vQutk6LLRXk1dz9xujc9rY3+uks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX+xItDdZKc12+WN0LO8NH8xNp0aDuAcVhHAHuqNaAFHPHlZrhBw0hlhCZlDQgwTh
	 cwQmtThWhGT6+YHb7GXgTFmC1vD7E2AGbuohuBU3455evHBZkLlRfsl/D5kXtGuRnS
	 +JVJPnzYH096Z/hj4JecqnwNxcejMQ46WG8AK+lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/192] workqueue: wq_watchdog_touch is always called with valid CPU
Date: Tue, 10 Sep 2024 11:33:07 +0200
Message-ID: <20240910092604.639838923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3b6ac232e21..4da8a5e702f8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5893,6 +5893,8 @@ notrace void wq_watchdog_touch(int cpu)
 {
 	if (cpu >= 0)
 		per_cpu(wq_watchdog_touched_cpu, cpu) = jiffies;
+	else
+		WARN_ONCE(1, "%s should be called with valid CPU", __func__);
 
 	wq_watchdog_touched = jiffies;
 }
-- 
2.43.0



