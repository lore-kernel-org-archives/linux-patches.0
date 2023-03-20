Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE51C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E53C433D2;
	Mon, 20 Mar 2023 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325238;
	bh=S6AoOAsIo8yAveuwlr6QRe1L5MwF2dsJT7Ztt/10cDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+Htno46A9JUsukPOXmqNtd9snEQckKy915jGvcHFQtucssRgUinA8ZUPXO1dthnC
	 sDLpQPbqA7aI7P4+qX0TEYdc/2bkL6dCLB1w8ZCdLMW5mVS5v+Xvic2Om+RgZnYkRv
	 yBnyTAsbTbuPOVklbhBmwncyU8hTise+dd/cK1NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-hun Kim <sfoon.kim@samsung.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 081/115] tracing: Make splice_read available again
Date: Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145452.819421221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
@@ -5093,6 +5093,8 @@ loff_t tracing_lseek(struct file *file,
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,


