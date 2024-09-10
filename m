Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6908F14D431;
	Tue, 10 Sep 2024 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962231; cv=none; b=IHh4xM7Ix400LfNXyr0d+Pxa3N++Ns+fjSt2/OkdTDqRpbdgPti0zDLWCbDRqj02sig5+30YHo1x3N3HJdOd80hEdcP1FgtUl472IItl+Y6Rxl/7NJ+zRDV4vrF90ZMpu1KHCM0WkByDdX2Mg72fq4Hcm5f8fhnK8w0Ef/Y96Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962231; c=relaxed/simple;
	bh=Jo1cgLeWcZMf2VQXqSo4Pe51cye0M8ZsBYdn2ISpBN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cd6tlE6qBygpAkLw3KIj+1v/PjraBKTt6YsllTF4JOP2BpEL6YUZ5lRaDdis7MMPkbusF4En9pPm2yXrLlzCum3CRD3SCLxE88tpoq98HQ6eZCTnm76W0hrL9BrZBOJtHJxYqXwODcantvWMfTsNc7qyDmHZJ59PH6OwfIfTmX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kca/2E7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kca/2E7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE8BC4CECD;
	Tue, 10 Sep 2024 09:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962231;
	bh=Jo1cgLeWcZMf2VQXqSo4Pe51cye0M8ZsBYdn2ISpBN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kca/2E7wlMK0zqBYmyK9dZX8//llwvztpX28gdUHoK3CSUv+FNMZJVxZfad/N8n8b
	 QO+yh0AgVaDolrCwsk0PdcUBoMQ7o04iTXmPv1fir8m8yWpXxOP0O3fBoS6sr71/11
	 GQaX0ljJ8rSgDI0+J9VhX9uZ4yrWmOo4Tlf6Cvb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 312/375] workqueue: wq_watchdog_touch is always called with valid CPU
Date: Tue, 10 Sep 2024 11:31:49 +0200
Message-ID: <20240910092633.038498330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 18e24deb1cc92f2068ce7434a94233741fbd7771 ]

Warn in the case it is called with cpu == -1. This does not appear
to happen anywhere.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 98f887f820c9 ("workqueue: Improve scalability of workqueue watchdog touch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c970eec25c5a..f26b0511b023 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7588,6 +7588,8 @@ notrace void wq_watchdog_touch(int cpu)
 {
 	if (cpu >= 0)
 		per_cpu(wq_watchdog_touched_cpu, cpu) = jiffies;
+	else
+		WARN_ONCE(1, "%s should be called with valid CPU", __func__);
 
 	wq_watchdog_touched = jiffies;
 }
-- 
2.43.0



