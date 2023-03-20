Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B001C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A7FC433D2;
	Mon, 20 Mar 2023 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326186;
	bh=UMqypIEzTOMxGEZh1af3eG/Lpa/XJAyAYGqPcQkCnJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY70BuJouYmg7PDcEnQg9Pg4QMHH9RhdadhN5AsQJeCki8AomIXC67jxWDezWOpOj
	 H0WTvZtjsN2/ZREM1g5LZtXaxs6a5/hdFNB3EI3ri5+6wwlZY94fOUZaCYyHt/1Kaw
	 YtYhFCd6QD/qzV+cQJSYSxQKdAm0iZy+al3+fz6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 192/211] trace/hwlat: Do not start per-cpu thread if it is already running
Date: Mon, 20 Mar 2023 15:55:27 +0100
Message-Id: <20230320145521.566663850@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tero Kristo <tero.kristo@linux.intel.com>

commit 08697bca9bbba15f2058fdbd9f970bd5f6a8a2e8 upstream.

The hwlatd tracer will end up starting multiple per-cpu threads with
the following script:

    #!/bin/sh
    cd /sys/kernel/debug/tracing
    echo 0 > tracing_on
    echo hwlat > current_tracer
    echo per-cpu > hwlat_detector/mode
    echo 100000 > hwlat_detector/width
    echo 200000 > hwlat_detector/window
    echo 1 > tracing_on

To fix the issue, check if the hwlatd thread for the cpu is already
running, before starting a new one. Along with the previous patch, this
avoids running multiple instances of the same CPU thread on the system.

Link: https://lore.kernel.org/all/20230302113654.2984709-1-tero.kristo@linux.intel.com/
Link: https://lkml.kernel.org/r/20230310100451.3948583-3-tero.kristo@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: f46b16520a087 ("trace/hwlat: Implement the per-cpu mode")
Signed-off-by: Tero Kristo <tero.kristo@linux.intel.com>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_hwlat.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -492,6 +492,10 @@ static int start_cpu_kthread(unsigned in
 {
 	struct task_struct *kthread;
 
+	/* Do not start a new hwlatd thread if it is already running */
+	if (per_cpu(hwlat_per_cpu_data, cpu).kthread)
+		return 0;
+
 	kthread = kthread_run_on_cpu(kthread_fn, NULL, cpu, "hwlatd/%u");
 	if (IS_ERR(kthread)) {
 		pr_err(BANNER "could not start sampling thread\n");


