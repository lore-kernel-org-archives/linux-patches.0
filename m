Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81B36A03A;
	Thu, 30 Jul 2026 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426392; cv=none; b=pyGpdKduNdCWqNEy6DlD1VOD3MBtVsyRadsLc+T9ge5L6NXLHA9O8OBtdpPT63yBdq7QYMbXNRl0Poi/nkHBXGFhiKtAmMTVH73UAfCAEZNORbU5g2ZLvzrXrmQ8oAHMI6ItzCoJsV2GCmxCxVm3uP2z24xYwDHDDylU+uFVvOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426392; c=relaxed/simple;
	bh=78Zh62WBMv9D3DwqI11LymZ6TQWPKhB2TiR5ivhEuXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giMPycGV5wd1eVRJKevvpz7H4zIMZEz+zUrUNtl39ycSymj6Q51QqCatEhvLiPCV9X5bMXy/Wq92M+JNz8hcWnctQ7G3FXtBqRw9XYQUsrJ+fmCa+2RGZFujy9KxxnWO+AfHfeXbLMiJmEwyC1IgqWWoLOVzZUEw6+qFEaiAz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IL6moyGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IL6moyGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A941F000E9;
	Thu, 30 Jul 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426391;
	bh=GH+AELzUk96SLqAnRFsWPvFJw7h3GrjeyZBTNyz8WcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IL6moyGabHnNCwgYdi0p9jpSW/0gly9A9TkkuM/M8Y5MpCjGHNuk3ANfZSxKqrVo/
	 lSIh6njnZzSo6yQJ2/77j1qCjg46P+EDFP9D4nQ5EM0NJFwYKjs004q3V19STbbWvq
	 8Hg5eO3UJE8a7TtZ9ZojBiCKRtt6IuQgGpi7ipzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 376/602] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Thu, 30 Jul 2026 16:12:48 +0200
Message-ID: <20260730141443.862610295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

commit 144f29e85702234b23d2a62abf723e6a17eb5427 upstream.

If the mmio_pipe_open() fails to find a PCI device, the hiter->dev
will be assigned to NULL. The mmiotrace read() function dereferences the
hiter->dev if hiter exists.

Change the test of the read to not only check hiter being NULL, but also
the hiter->dev before dereferencing it.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260721211143.36dbd559@gandalf.local.home
Fixes: f984b51e0779 ("ftrace: add mmiotrace plugin")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260715143604.14481-1-gaikwad.dcg%40gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_mmiotrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -146,7 +146,7 @@ static ssize_t mmio_read(struct trace_it
 		goto print_out;
 	}
 
-	if (!hiter)
+	if (!hiter || !hiter->dev)
 		return 0;
 
 	mmio_print_pcidev(s, hiter->dev);


