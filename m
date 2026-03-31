Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9E2FE042;
	Tue, 31 Mar 2026 17:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976657; cv=none; b=DGRCiT4rKrZk/xtoF07dT2ECX4idnrrTx1gDPxfiD4mTNo0UNCyLKR6ElTS07k1CdaLjni24knaWt3lQkVEGV7mveacnQgxA6vu9hxV4Op0NIchAg9AVQQ7xWI8uwaTooJ6ycOwosaJfijbwIwNr8vTVQlTcQcPhlaPDDNtErkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976657; c=relaxed/simple;
	bh=EYSShiSVo6SLntcp+/X6iQY0ObyWc89XPWp1JKayZjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvsAMvfzGevoip76NwPPu2O07K7onxDU2Ox1qRIGOEK76CtfkMQvYnN/cwlMlNqDNQpMkwxLdsrTSYd9ANSy49bUNg40gVA91pQepdlR5Uauke8ZTnxCxSo8GCrbBj+VKse5jAsVpNxir2K5xIrcNwfJJ6qLFStKOOYjZJts4W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUY01rcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUY01rcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55DC19423;
	Tue, 31 Mar 2026 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976657;
	bh=EYSShiSVo6SLntcp+/X6iQY0ObyWc89XPWp1JKayZjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUY01rcBFVgU+aYtPcv328+aG6k6uxFlfz/2cpbZ80P+ghrff9vIjbGBMAY8JAiPT
	 6ANWlDtfUlEWKKtHnSi9PmM/G6IykmAGtWHZXXILWdrezOZpo60//tgZdszO58KRHi
	 +wyZphIhGp0xSVL1R8o9GGTqLZgiuI8L0DEtyHjU=
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
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 178/309] tracing: Fix potential deadlock in cpu hotplug with osnoise
Date: Tue, 31 Mar 2026 18:21:21 +0200
Message-ID: <20260331161800.016931002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Haiyang <luo.haiyang@zte.com.cn>

commit 1f9885732248d22f788e4992c739a98c88ab8a55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2073,8 +2073,8 @@ static void osnoise_hotplug_workfn(struc
 	if (!osnoise_has_registered_instances())
 		return;
 
-	guard(mutex)(&interface_lock);
 	guard(cpus_read_lock)();
+	guard(mutex)(&interface_lock);
 
 	if (!cpu_online(cpu))
 		return;
@@ -2237,11 +2237,11 @@ static ssize_t osnoise_options_write(str
 	if (running)
 		stop_per_cpu_kthreads();
 
-	mutex_lock(&interface_lock);
 	/*
 	 * avoid CPU hotplug operations that might read options.
 	 */
 	cpus_read_lock();
+	mutex_lock(&interface_lock);
 
 	retval = cnt;
 
@@ -2257,8 +2257,8 @@ static ssize_t osnoise_options_write(str
 			clear_bit(option, &osnoise_options);
 	}
 
-	cpus_read_unlock();
 	mutex_unlock(&interface_lock);
+	cpus_read_unlock();
 
 	if (running)
 		start_per_cpu_kthreads();
@@ -2345,16 +2345,16 @@ osnoise_cpus_write(struct file *filp, co
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


