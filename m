Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83122F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9ECC433EF;
	Wed, 12 Apr 2023 08:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289577;
	bh=OpCqSmB2KGNKYp4UT7PsVELkb4AQtCutdujDYdVQPBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYSc98XgS6/sP/ZPtb+tr9RtAX+7V3ViONq3oHfJaoowod3ya2UDLf204EuPL5czX
	 Cq1pPfD1HaOn7r6G64mFZ6tH9T1iokYhbjOHan5RnsLf+B5GVtm1Jf+OYpeTFMh9aj
	 RSBNrpMwl4OgBPuAV53+h+V5/6JYuUhV4wWvLs1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 123/173] tracing/osnoise: Fix notify new tracing_max_latency
Date: Wed, 12 Apr 2023 10:34:09 +0200
Message-Id: <20230412082843.109095719@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit d3cba7f02cd82118c32651c73374d8a5a459d9a6 upstream.

osnoise/timerlat tracers are reporting new max latency on instances
where the tracing is off, creating inconsistencies between the max
reported values in the trace and in the tracing_max_latency. Thus
only report new tracing_max_latency on active tracing instances.

Link: https://lkml.kernel.org/r/ecd109fde4a0c24ab0f00ba1e9a144ac19a91322.1680104184.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: dae181349f1e ("tracing/osnoise: Support a list of trace_array *tr")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1296,7 +1296,7 @@ static void notify_new_max_latency(u64 l
 	rcu_read_lock();
 	list_for_each_entry_rcu(inst, &osnoise_instances, list) {
 		tr = inst->tr;
-		if (tr->max_latency < latency) {
+		if (tracer_tracing_is_on(tr) && tr->max_latency < latency) {
 			tr->max_latency = latency;
 			latency_fsnotify(tr);
 		}


