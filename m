Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BD338654F;
	Sat, 17 Oct 2026 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255699; cv=none; b=mMTIzPs9jA10Z23806A8XckUM5sEtXzLRMrvsLn4488dWA5eQnP5vdEw8jxDkazyrACikP8/QQ1lxcOfCtLzm81/3vVUUo99lMvG3PlTfbXeolQ+tDXidWjIg88UWt9+7pnUldCPeU3DMoOJuRpVT0lWYC4YhfcygRWKb1rIfNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255699; c=relaxed/simple;
	bh=X832CtC31aHNt61969ze1fgZ+l/tKmK/uKq8c0pKVOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL5+31Z7ESJUAlrSDlr2zocGbYrKe0QX3Rp3uxKWUuVrNnw3NuQvCbydkjLxf4swT8p/USnszd16x0yBVSvFUvF5C6dMVbtXcY5Fm4wzLuz69Kiy5b4w0yczEDktiPTxXrC9HOyFdKs89Gf+cspf+ewrPJYQ2fbiqNdAtbdls+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xU7DEx0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU7DEx0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA2E1F000C4;
	Sat, 17 Oct 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255698;
	bh=TB+Gmx2y+bKFJi+ygUf1cAXCcVi+ZXflZhMgo2Hc0MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xU7DEx0WiHLCsa8G4M3x46O3AkgiRG5YikQd9FqCCf0hLYom5Bws0Cg4yw7emVQYJ
	 QCC+IzHTC4R5gYNnLdqJUsG5aU0lSfO8CwDg5OFLRzHSTzMSdWVORfKgfGG3+s/YXd
	 EChf5HpwSO17Op1v+DjUGGvKUe8pEJBTtpAf1KjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 862/869] tracing: Fix comment in tracing_buffers_splice_read()
Date: Sat, 17 Oct 2026 18:01:43 +0200
Message-ID: <20261017160058.957451398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 5cbea500775dd1944995f23320af030b9b24b24b ]

The comment about returning an error if the read fails on the first
iteration is slightly incorrect. It makes it sound like the only reason it
could fail on a later iteration is if the subbuf order changed. That is
incorrect, it could also fail if the length passed in was not a multiple
of the subbuf size. Fix the comment.

Link: https://lore.kernel.org/all/20260904143527.40e73d36@gandalf.local.home/
Link: https://patch.msgid.link/20260904144902.506862a1@gandalf.local.home
Fixes: dae8dda341d2 ("tracing: Fix subbuf resize races with trace_pipe_raw readers")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8af0fe8233433..115963797fab0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8107,11 +8107,13 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			r = ring_buffer_read_page(ref->buffer, ref->rpage, len, iter->cpu_file, 1);
 		} else if (!i) {
 			/*
-			 * We failed to read because the length is too small
-			 * or unaligned. If this is the first iteration, it's
-			 * an invalid userspace input. Otherwise, this is due
-			 * to a subbuf order change. Do not report an error
-			 * and just finish the read.
+			 * If this fails to read on the first iteration, it
+			 * means the length was too small and an error should
+			 * be returned to user space. Otherwise, at least
+			 * one sub-buffer was successfully read but this failed
+			 * due to either the length was unaligned or the
+			 * subbuf order changed. Either case, do not report
+			 * an error.
 			 */
 			ret = -EINVAL;
 		}
-- 
2.53.0



