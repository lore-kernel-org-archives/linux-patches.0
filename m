Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3268A1D4154;
	Tue, 15 Oct 2024 12:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993888; cv=none; b=UdKnewDPFXvNzRqnXFubLKzcTnkj72DrreO43MqAMj3pFlgCR3WMgs86yEuPmmfB58i9ryf4t2ArtY8sT5wzgELlKxiYxZZlfIqzoi7S6jwW9DdC35rrPddM+Youc6z6xs+imZE9Yjhc3qNf52KnpuxXLDn2NQXXueYx57ngUxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993888; c=relaxed/simple;
	bh=2YXnkZkt7omvpJoZw016kg/Ky0qTrai024VLziD9D1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kG9lgSVMJS6VbcVdV90X/j6Gl/H7tJT+NnKyeOP8POz3eS7RMI+31kl+Qnk9MBRUVWE6AHN/NhGQdEpsJA2wRNP0YL3PKu4iqFi8nA5QR5nu6b6GV3aroV0Uzi8dFwmTityS8cm4qEGa125zLYFmGC3euatqPYR6sGByN2h+8z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1oKej6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1oKej6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FC2C4CEC6;
	Tue, 15 Oct 2024 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993888;
	bh=2YXnkZkt7omvpJoZw016kg/Ky0qTrai024VLziD9D1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1oKej6xcUOJ9UXy4kQ3sJuq1P8yMrr7/eAZpT6KIMgcac+tykdRiSrRWL1Ngz3Tk
	 HRJ0C9yiV8m6gOiBdW8uL/MOW3vsYTGuxzyxxHIXeZ7XLVgyLlV60ATzyU//uUOHjw
	 yxQOABfj+Ft1qKj39MxU2JvZa4H6OwJl8hllDHdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 544/691] tracing/hwlat: Fix a race during cpuhp processing
Date: Tue, 15 Oct 2024 13:28:12 +0200
Message-ID: <20241015112501.930899055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
 


