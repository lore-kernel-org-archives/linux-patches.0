Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AD72690D6;
	Tue,  8 Apr 2025 12:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115284; cv=none; b=ipnWdA+iLMuOgaNeTbXrv06QkpOCh5qLvs60zRehjEZ0ZuevGeZCDbooeMZzs/2WcRU2uqqWd47WQWazrkq8flK7DZgpEIu3MRx/Npd8yLeMiQBS8QEfy5meUjUiQaaol4eJ9fziFNNaZjIw6Gs1CAhQmZpcBrjohY75/jN3l1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115284; c=relaxed/simple;
	bh=6sfaPXRXIQD52Q+egzDDDffwugzEXemG2fQ7QdBVfkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbL5ENsXFKWhAUBocet83mp3IjLiztc/nLGdc37NwXYiOlxKbwfGA3pCDrArKV1NNxz+hzktQ2/T9t4OKHH3zFz2knV3QClJuk61ucC29s8uAhX1R098tLo3a7XSE9ZD79L45zuLEm5o4w0jjAzGYQNiPDa1cScD233w+kf2w9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4TXJaK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4TXJaK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297C3C4CEE5;
	Tue,  8 Apr 2025 12:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115284;
	bh=6sfaPXRXIQD52Q+egzDDDffwugzEXemG2fQ7QdBVfkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4TXJaK+MMsQvmsIh+V1c1DgqiFfupksm7lyos8V/2NHScywNBrm7PUPLtby8Fzgy
	 zbJtYzSyr19dzKPUlBtp+XYQ/KH+C9FV6vF3155m/KDM8faiMQY0l4bV2FAJ/PrDSG
	 YyDnXmbNl63irVF5b1rlqZ5HGLNmc87y8eDC8bDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 416/499] tracing: Correct the refcount if the hist/hist_debug file fails to open
Date: Tue,  8 Apr 2025 12:50:28 +0200
Message-ID: <20250408104901.600630108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit 0b4ffbe4888a2c71185eaf5c1a02dd3586a9bc04 ]

The function event_{hist,hist_debug}_open() maintains the refcount of
'file->tr' and 'file' through tracing_open_file_tr(). However, it does
not roll back these counts on subsequent failure paths, resulting in a
refcount leak.

A very obvious case is that if the hist/hist_debug file belongs to a
specific instance, the refcount leak will prevent the deletion of that
instance, as it relies on the condition 'tr->ref == 1' within
__remove_instance().

Fix this by calling tracing_release_file_tr() on all failure paths in
event_{hist,hist_debug}_open() to correct the refcount.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Link: https://lore.kernel.org/20250314065335.1202817-1-wutengda@huaweicloud.com
Fixes: 1cc111b9cddc ("tracing: Fix uaf issue when open the hist or hist_debug file")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index ad7419e240556..53dc6719181e5 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5689,12 +5689,16 @@ static int event_hist_open(struct inode *inode, struct file *file)
 	guard(mutex)(&event_mutex);
 
 	event_file = event_file_data(file);
-	if (!event_file)
-		return -ENODEV;
+	if (!event_file) {
+		ret = -ENODEV;
+		goto err;
+	}
 
 	hist_file = kzalloc(sizeof(*hist_file), GFP_KERNEL);
-	if (!hist_file)
-		return -ENOMEM;
+	if (!hist_file) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	hist_file->file = file;
 	hist_file->last_act = get_hist_hit_count(event_file);
@@ -5702,9 +5706,14 @@ static int event_hist_open(struct inode *inode, struct file *file)
 	/* Clear private_data to avoid warning in single_open() */
 	file->private_data = NULL;
 	ret = single_open(file, hist_show, hist_file);
-	if (ret)
+	if (ret) {
 		kfree(hist_file);
+		goto err;
+	}
 
+	return 0;
+err:
+	tracing_release_file_tr(inode, file);
 	return ret;
 }
 
@@ -5979,7 +5988,10 @@ static int event_hist_debug_open(struct inode *inode, struct file *file)
 
 	/* Clear private_data to avoid warning in single_open() */
 	file->private_data = NULL;
-	return single_open(file, hist_debug_show, file);
+	ret = single_open(file, hist_debug_show, file);
+	if (ret)
+		tracing_release_file_tr(inode, file);
+	return ret;
 }
 
 const struct file_operations event_hist_debug_fops = {
-- 
2.39.5



