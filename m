Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293E2494F0;
	Wed,  8 Apr 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672343; cv=none; b=Y3DOMIFLPlnc55nBa2e8/9iwX7KyJpm/SE3WA7agYqndQZ5dE/OwWof75iwNxcfsV37r8RwzIoZxrwMIcjAK78NniuEhctLndPBHA6eIxxAz4Keje7pZlIWTXlVC6SfwMjrRjw9SpU7uX5wplt0KyLRAVeVpVN3ggJy6yF4lOCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672343; c=relaxed/simple;
	bh=DVJP+Duv88kvSV0bNYIirID3TtT/OgN5Qwu1TTwMic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6PFrDxGNgPI5gZfHe6cbnRUBSUD7GZIZbfIDflSTxfSfPkTiE21u+3tAcEfTagkkg3FHa84D4a9Hlp1ZzAwM6iRi5z26qK3JKTG2Ywxb5NN7B2V7PCztaRebIb2/cke2DY0u+Ry5veUvI/n/0VC3Ouz+c/uE4UxTAgpjPy9xD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHTcfPYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHTcfPYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68468C19421;
	Wed,  8 Apr 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672343;
	bh=DVJP+Duv88kvSV0bNYIirID3TtT/OgN5Qwu1TTwMic0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHTcfPYjOwxKdn4l6oKIvv+CH7bENyfzs0S6J+j+zDAiPzxrYRZ4vhY9qdvGgJ9nP
	 XZsrVUKyqeU8xNYbRv1wh0OW25xzjg47bJhS9wq9/xyRPM5nXbw4a8r6hfXL/acc+1
	 UepOnUqQRqF1fLTr/ENEIqbY+yQj7UEmjh9cK940=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mathieu.desnoyers@efficios.com,
	zhang.run@zte.com.cn,
	yang.tao172@zte.com.cn,
	ran.xiaokai@zte.com.cn,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Luo Haiyang <luo.haiyang@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 283/312] tracing: Fix potential deadlock in cpu hotplug with osnoise
Date: Wed,  8 Apr 2026 20:03:20 +0200
Message-ID: <20260408175944.325910616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Luo Haiyang <luo.haiyang@zte.com.cn>

[ Upstream commit 1f9885732248d22f788e4992c739a98c88ab8a55 ]

The following sequence may leads deadlock in cpu hotplug:

    task1        task2        task3
    -----        -----        -----

 mutex_lock(&interface_lock)

            [CPU GOING OFFLINE]

            cpus_write_lock();
            osnoise_cpu_die();
              kthread_stop(task3);
                wait_for_completion();

                      osnoise_sleep();
                        mutex_lock(&interface_lock);

 cpus_read_lock();

 [DEAD LOCK]

Fix by swap the order of cpus_read_lock() and mutex_lock(&interface_lock).

Cc: stable@vger.kernel.org
Cc: <mathieu.desnoyers@efficios.com>
Cc: <zhang.run@zte.com.cn>
Cc: <yang.tao172@zte.com.cn>
Cc: <ran.xiaokai@zte.com.cn>
Fixes: bce29ac9ce0bb ("trace: Add osnoise tracer")
Link: https://patch.msgid.link/20260326141953414bVSj33dAYktqp9Oiyizq8@zte.com.cn
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Luo Haiyang <luo.haiyang@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ adapted guard() macros to lock/unlock calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1809,8 +1809,8 @@ static void osnoise_hotplug_workfn(struc
 	if (!osnoise_has_registered_instances())
 		goto out_unlock_trace;
 
-	mutex_lock(&interface_lock);
 	cpus_read_lock();
+	mutex_lock(&interface_lock);
 
 	if (!cpu_online(cpu))
 		goto out_unlock;
@@ -1820,8 +1820,8 @@ static void osnoise_hotplug_workfn(struc
 	start_kthread(cpu);
 
 out_unlock:
-	cpus_read_unlock();
 	mutex_unlock(&interface_lock);
+	cpus_read_unlock();
 out_unlock_trace:
 	mutex_unlock(&trace_types_lock);
 }
@@ -1950,16 +1950,16 @@ osnoise_cpus_write(struct file *filp, co
 	if (running)
 		stop_per_cpu_kthreads();
 
-	mutex_lock(&interface_lock);
 	/*
 	 * osnoise_cpumask is read by CPU hotplug operations.
 	 */
 	cpus_read_lock();
+	mutex_lock(&interface_lock);
 
 	cpumask_copy(&osnoise_cpumask, osnoise_cpumask_new);
 
-	cpus_read_unlock();
 	mutex_unlock(&interface_lock);
+	cpus_read_unlock();
 
 	if (running)
 		start_per_cpu_kthreads();


