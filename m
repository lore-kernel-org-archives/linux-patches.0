Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3471E1DED74;
	Tue,  8 Oct 2024 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392759; cv=none; b=evUXbsxnYw3A6FwiO4SHHE6k0rWSNNTPjprcp8NEP4LKfzrWhDsN12Sxm6wwTPWEO5rnRLpIqYQqDvcQpYnHDVZRONQ/NThtOehXgb+kAACP0UP9zEf+sXJiPztZftD5c3LBpV9EPyBwo7x9tK+lTFx+zKHf3s+IrNdiUMTsqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392759; c=relaxed/simple;
	bh=fVM+AA3pZjjg3nasl5dMLS2qicy/MutCHrahxrjAI/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBNZBQy0lx6P0yVV2j8kOKwLY5pTXuzGlvHkC0VKU6fa8mpFk3fkR/HVL5xjGwcimhhTLLdDwpLMgfRzaxN2cz5tJFjZFnSf4NMoc0r2+en6VMkM8Ap6VtNlO/OY6FHL/VEXkqLIIgLyuLpL96dZu8wRFTeXExRL9sxT+3ethyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLdBBg1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLdBBg1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8A5C4CEC7;
	Tue,  8 Oct 2024 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392758;
	bh=fVM+AA3pZjjg3nasl5dMLS2qicy/MutCHrahxrjAI/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLdBBg1wt/CsQLSyDiRapdraQw7HU0VR9uSbDtAu2h7B3RK2IlgDYLO5Y6i0l2nqw
	 CrXwQcKCwkajuVCcVoSW1+Fjq04nGLgCWH+NO+2qpdpS7klsFlbyjWmdljr3Xl9kwz
	 f84fY0x41GKnGVYlr2DT3hvnAPThHbuDyFD32tcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.11 509/558] tracing/hwlat: Fix a race during cpuhp processing
Date: Tue,  8 Oct 2024 14:08:59 +0200
Message-ID: <20241008115722.259876265@linuxfoundation.org>
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
 


