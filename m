Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462928E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDFBC433C8;
	Wed, 20 Sep 2023 11:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210806;
	bh=AeuKo47GmHnPnoasCjD9P4PdGssduLsocNvcMgccMEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtrGZcl+T0TgIZyNGO/oRmOvLW25cRAiqn5P9KYSja4yTxK2teCs4A3UVQ6uPpDvT
	 PeMBkOoif5dFl9knw0Lui6OdPSoHkoiFU7BxSaxh5CgFUoRYQPgbiA5rkTz59WL97F
	 sPHZP0B5U2E8jCYe7sxJQoUBMRc/nSG/evZt66YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.5 185/211] tracing: Have tracing_max_latency inc the trace array ref count
Date: Wed, 20 Sep 2023 13:30:29 +0200
Message-ID: <20230920112851.609944709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7d660c9b2bc95107f90a9f4c4759be85309a6550 upstream.

The tracing_max_latency file points to the trace_array max_latency field.
For an instance, if the file is opened and the instance is deleted,
reading or writing to the file will cause a use after free.

Up the ref count of the trace_array when tracing_max_latency is opened.

Link: https://lkml.kernel.org/r/20230907024803.666889383@goodmis.org
Link: https://lore.kernel.org/all/1cb3aee2-19af-c472-e265-05176fe9bd84@huawei.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Fixes: 8530dec63e7b4 ("tracing: Add tracing_check_open_get_tr()")
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1772,7 +1772,7 @@ static void trace_create_maxlat_file(str
 	init_irq_work(&tr->fsnotify_irqwork, latency_fsnotify_workfn_irq);
 	tr->d_max_latency = trace_create_file("tracing_max_latency",
 					      TRACE_MODE_WRITE,
-					      d_tracer, &tr->max_latency,
+					      d_tracer, tr,
 					      &tracing_max_lat_fops);
 }
 
@@ -1805,7 +1805,7 @@ void latency_fsnotify(struct trace_array
 
 #define trace_create_maxlat_file(tr, d_tracer)				\
 	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
-			  d_tracer, &tr->max_latency, &tracing_max_lat_fops)
+			  d_tracer, tr, &tracing_max_lat_fops)
 
 #endif
 
@@ -6706,14 +6706,18 @@ static ssize_t
 tracing_max_lat_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	return tracing_nsecs_read(filp->private_data, ubuf, cnt, ppos);
+	struct trace_array *tr = filp->private_data;
+
+	return tracing_nsecs_read(&tr->max_latency, ubuf, cnt, ppos);
 }
 
 static ssize_t
 tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
-	return tracing_nsecs_write(filp->private_data, ubuf, cnt, ppos);
+	struct trace_array *tr = filp->private_data;
+
+	return tracing_nsecs_write(&tr->max_latency, ubuf, cnt, ppos);
 }
 
 #endif
@@ -7770,10 +7774,11 @@ static const struct file_operations trac
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_max_lat_read,
 	.write		= tracing_max_lat_write,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tr,
 };
 #endif
 


