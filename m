Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95D73446C5;
	Tue, 11 Nov 2025 01:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824723; cv=none; b=V/qaVyL7mPYTLovbL/zPgseioZ/su8oqjDZvEnvRT+1wFmPjntSv/q6207wjBoMUeuD1TzMcKiLDS5gXMeiLJJTegMEOVwJ8BfBoRu+xl1QWNKRM0YlsZK9+Q1808kOkwGoeL1kkKmJI0IZkidPkRSWAXt6dTpE2HJshaOq/M60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824723; c=relaxed/simple;
	bh=JU4BPVXOpMZkVLR4mE17kAyxO22PE9ZZukx1fMmJP4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+SS7dkyCuAFS52mrULqgST4Ehndvn+RhdkF9LT/6e0YKBnuxsGD/SsvWOQ4rSYoRx07/I3hubPDFiGuo0yJ2DhBgIgW68jy+j2hzRpGLFa1T+lzt5drKkL1DXxmEGOOsgmX5e/hUySt5bCfi2/zNCpuR1H7kpBTIGuYKym6IUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBG7LquF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBG7LquF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EBAC113D0;
	Tue, 11 Nov 2025 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824723;
	bh=JU4BPVXOpMZkVLR4mE17kAyxO22PE9ZZukx1fMmJP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBG7LquFU7MyD+5Zhhghh2JLPNr/vhcclU0NxKDFBx1xN+0sj4Xa+iUBrrgC0eWxm
	 DKmCb5a7vd0UAFlDk9Mwn6tVh0duqhvPKTfgrBldQtDT96Tfgao+RLqzo12K3qi7fr
	 MaVMowZpYEr09TBXGOD0tnFZeD/fZmZmvwkDe3+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	syzbot+92a3745cea5ec6360309@syzkaller.appspotmail.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 505/565] ring-buffer: Do not warn in ring_buffer_map_get_reader() when reader catches up
Date: Tue, 11 Nov 2025 09:46:01 +0900
Message-ID: <20251111004538.307325814@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit aa997d2d2a0b2e76f4df0f1f12829f02acb4fb6b upstream.

The function ring_buffer_map_get_reader() is a bit more strict than the
other get reader functions, and except for certain situations the
rb_get_reader_page() should not return NULL. If it does, it triggers a
warning.

This warning was triggering but after looking at why, it was because
another acceptable situation was happening and it wasn't checked for.

If the reader catches up to the writer and there's still data to be read
on the reader page, then the rb_get_reader_page() will return NULL as
there's no new page to get.

In this situation, the reader page should not be updated and no warning
should trigger.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Reported-by: syzbot+92a3745cea5ec6360309@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/690babec.050a0220.baf87.0064.GAE@google.com/
Link: https://lore.kernel.org/20251016132848.1b11bb37@gandalf.local.home
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7223,6 +7223,10 @@ consume:
 		goto out;
 	}
 
+	/* Did the reader catch up with the writer? */
+	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
+		goto out;
+
 	reader = rb_get_reader_page(cpu_buffer);
 	if (WARN_ON(!reader))
 		goto out;


