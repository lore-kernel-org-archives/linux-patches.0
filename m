Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE1E1779B1;
	Tue,  8 Oct 2024 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390924; cv=none; b=EriJ90bF32F8JKTBwkYPjiNRl6lQ7U2G3aBt6u4rj+ng6beU251hOjbSf9FGKSxs6lmq/hCgVWY/82bK77kg/HyLLQjXqBZoIWDg/rg9ktEVB/hjeV2EhEwmW1ea9i/G9FsQ/4XmXW7rztdTfBwm98KNK9VV+m2PK/tgXHHu25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390924; c=relaxed/simple;
	bh=u1n6UQQH5qwb4aNKfIsmdoWmC0w5aZxMS+SgKO5tzqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv/xdLx2pF7t6l+iSSigyXd5SNt7YlQp6e2dwnFYzc7btltgdS/FzI4XlF5/d+mqhEE7Qb4wbvHGlPsUyCFGiX/t+qEd/AGsjVC3fdrn6NmxXZixASiSrL9VkYB+ptYhK2b8eracVjg/pZlmmhnF34gNcDm8OYbQKfl6E1Fiyjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFIYjHCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFIYjHCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32760C4CEC7;
	Tue,  8 Oct 2024 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390924;
	bh=u1n6UQQH5qwb4aNKfIsmdoWmC0w5aZxMS+SgKO5tzqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFIYjHCzqiHMno9C5CypVypkpotHtEwPQ5QQO3sghMC5ASt1CMWWR0kpLqU+H55nV
	 vbr//omEYBs8dEAFA0qeO2u86aVmKLZZXVqz8cDxpLZ/rESvfjadUBpVQpmMUQfq7I
	 ey9wjqwWLtvyMf+16J97tBFD7APBAx78F97rLvyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 428/482] tracing/hwlat: Fix a race during cpuhp processing
Date: Tue,  8 Oct 2024 14:08:11 +0200
Message-ID: <20241008115705.366838191@linuxfoundation.org>
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

From: Wei Li <liwei391@huawei.com>

commit 2a13ca2e8abb12ee43ada8a107dadca83f140937 upstream.

The cpuhp online/offline processing race also exists in percpu-mode hwlat
tracer in theory, apply the fix too. That is:

    T1                       | T2
    [CPUHP_ONLINE]           | cpu_device_down()
     hwlat_hotplug_workfn()  |
                             |     cpus_write_lock()
                             |     takedown_cpu(1)
                             |     cpus_write_unlock()
    [CPUHP_OFFLINE]          |
        cpus_read_lock()     |
        start_kthread(1)     |
        cpus_read_unlock()   |

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240924094515.3561410-5-liwei391@huawei.com
Fixes: ba998f7d9531 ("trace/hwlat: Support hotplug operations")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_hwlat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -520,6 +520,8 @@ static void hwlat_hotplug_workfn(struct
 	if (!hwlat_busy || hwlat_data.thread_mode != MODE_PER_CPU)
 		goto out_unlock;
 
+	if (!cpu_online(cpu))
+		goto out_unlock;
 	if (!cpumask_test_cpu(cpu, tr->tracing_cpumask))
 		goto out_unlock;
 


