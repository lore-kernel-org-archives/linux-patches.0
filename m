Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFDB1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F8FC433D2;
	Mon, 20 Mar 2023 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324813;
	bh=BCmNvDMhrMkhlmJKS0+v/dzhSURA4nc1L1BFv8Z3Rfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxdCPuydw7dNZ0gYnARlvIJgOO2gVJDlJj9U4ZtST84X1097yIcgvtpEhxbRZO1fq
	 pIg56VFo7SkrV5CmivGX0SGE6NPOePGeGgYkAuxdkCpP5IQOLSVXnhFA9WqF7FuRlF
	 6kSO2tgV7DbOSke8DqZUuEXybggoQBPYKhZsFza8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-hun Kim <sfoon.kim@samsung.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 61/99] tracing: Make splice_read available again
Date: Mon, 20 Mar 2023 15:54:39 +0100
Message-Id: <20230320145445.941093832@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sung-hun Kim <sfoon.kim@samsung.com>

commit e400be674a1a40e9dcb2e95f84d6c1fd2d88f31d upstream.

Since the commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops") is applied to the kernel, splice() and
sendfile() calls on the trace file (/sys/kernel/debug/tracing
/trace) return EINVAL.

This patch restores these system calls by initializing splice_read
in file_operations of the trace file. This patch only enables such
functionalities for the read case.

Link: https://lore.kernel.org/linux-trace-kernel/20230314013707.28814-1-sfoon.kim@samsung.com

Cc: stable@vger.kernel.org
Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Sung-hun Kim <sfoon.kim@samsung.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4705,6 +4705,8 @@ loff_t tracing_lseek(struct file *file,
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,


