Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37D27056D;
	Tue, 30 Sep 2025 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244787; cv=none; b=GTufgeJDSOY6lu1cAwLrjyMCZdM3S1c7MJiAeYj10Q1F0HxGYfgN2lCQV/QR/oy9TxNvoUcUn+kW6MSTSNht5WZ7GD14stzaWHnyfNuXvgYpQzWnZEdeMIUHS3yfbHVUXCN10/LJw0poJvHv3kjpRZR1vlMTfBcJfktfX0hHbys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244787; c=relaxed/simple;
	bh=sjjT1fXQwEOeb/03OS4B52jo99BkapC5w8u9DH8zAuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0gvdoZV6zQA999RRCYUa1DqOubTci95kb3OgkQBP93+xcEINVdzGqTvPQiLaZBG//PE3Q9Z9Wk1C/cTk1HdUP0bWTCV0iD9f72BvAyufqYrDhaXpkDVegr/fWb5RT7GrmIFVORw3ARDG7FHeW2yaorz4QpqsTcpJXxSyfyGj+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yN39QbKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yN39QbKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3ADC4CEF0;
	Tue, 30 Sep 2025 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244787;
	bh=sjjT1fXQwEOeb/03OS4B52jo99BkapC5w8u9DH8zAuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN39QbKGdDHL0aLIlPJKOCgqITduO7M3QDu22xpuDxKrYDA9yQR0alzB0CNO2QgXP
	 bsINlB+GeZ6D0HxjHkaTc3l9/JFrQ9zoEIXuKudAoW0u5oVOiVkiVHZxCeay1e89wl
	 hVZQuNWKZ22bvXDQ5BuaAhxYI5vUD7VD3YRtRrXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Menglong Dong <menglong8.dong@gmail.com>
Subject: [PATCH 6.16 113/143] tracing: fprobe: Fix to remove recorded module addresses from filter
Date: Tue, 30 Sep 2025 16:47:17 +0200
Message-ID: <20250930143835.737245612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c539feff3c8f8c86213eee2b237410714712c326 upstream.

Even if there is a memory allocation failure in fprobe_addr_list_add(),
there is a partial list of module addresses. So remove the recorded
addresses from filter if exists.
This also removes the redundant ret local variable.

Fixes: a3dc2983ca7b ("tracing: fprobe: Cleanup fprobe hash when module unloading")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Menglong Dong <menglong8.dong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index c8034dfc1070..5a807d62e76d 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -428,8 +428,9 @@ static int fprobe_addr_list_add(struct fprobe_addr_list *alist, unsigned long ad
 {
 	unsigned long *addrs;
 
-	if (alist->index >= alist->size)
-		return -ENOMEM;
+	/* Previously we failed to expand the list. */
+	if (alist->index == alist->size)
+		return -ENOSPC;
 
 	alist->addrs[alist->index++] = addr;
 	if (alist->index < alist->size)
@@ -489,7 +490,7 @@ static int fprobe_module_callback(struct notifier_block *nb,
 	for (i = 0; i < FPROBE_IP_TABLE_SIZE; i++)
 		fprobe_remove_node_in_module(mod, &fprobe_ip_table[i], &alist);
 
-	if (alist.index < alist.size && alist.index > 0)
+	if (alist.index > 0)
 		ftrace_set_filter_ips(&fprobe_graph_ops.ops,
 				      alist.addrs, alist.index, 1, 0);
 	mutex_unlock(&fprobe_mutex);
-- 
2.51.0



