Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CF2AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FE9C433D2;
	Wed,  4 Jan 2023 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848824;
	bh=R62n4egSXnpXXXnV23Ku4Dc8+S1ZEFpdcEOk5E62XXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv3DfjIKgt6t14FnTq96CA8M/5xyu7Rxdigy+5LgARfJ1l190qtjBThahEdFaokdW
	 edPMnRnxZAStRT43ZEZfpIRUhv5A8WRerlfFG6y6G7tUM6dD4JpY1al6bvSVJ8M6H5
	 vTuxE22PpjtsZT/FMF17VOwlwohz4Xz7dw7AeyMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 090/207] tracing: Fix race where eprobes can be called before the event
Date: Wed,  4 Jan 2023 17:05:48 +0100
Message-Id: <20230104160514.789565938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit d5f30a7da8ea8e6450250275cec5670cee3c4264 upstream.

The flag that tells the event to call its triggers after reading the event
is set for eprobes after the eprobe is enabled. This leads to a race where
the eprobe may be triggered at the beginning of the event where the record
information is NULL. The eprobe then dereferences the NULL record causing
a NULL kernel pointer bug.

Test for a NULL record to keep this from happening.

Link: https://lore.kernel.org/linux-trace-kernel/20221116192552.1066630-1-rafaelmendsr@gmail.com/
Link: https://lore.kernel.org/all/20221117214249.2addbe10@gandalf.local.home/

Cc: stable@vger.kernel.org
Fixes: 7491e2c442781 ("tracing: Add a probe that attaches to trace events")
Reported-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -567,6 +567,9 @@ static void eprobe_trigger_func(struct e
 	if (unlikely(!rec))
 		return;
 
+	if (unlikely(!rec))
+		return;
+
 	__eprobe_trace_func(edata, rec);
 }
 


