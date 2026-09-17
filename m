Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD44848B5;
	Thu, 17 Sep 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659493; cv=none; b=KeJxE5f8UgoeYP70Thr0FTU7bFKyR8x5nz2RCFSoZMDEgAy7tJwErX6RWbvCwabAYTq+Yy7KYH1Cbc7aOT/Y753aoiI528pmlcvC8TRkYYzxfCj6MNo4wk87tzuHvNqa+sNeTr4j5Pjkx5DdPmmevwDwyrnQIRfJrdaNUCoqJnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659493; c=relaxed/simple;
	bh=HLiCHF/Z3ttqCKvPMM4YrFBNT27ZNh3e2323TfKGfFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv7XB83CJx3PKfJaUwWGaoUyipBliFjTZMSbnUOyq8jYBl8xETN1BH0HOMm1XeZElnTBREW7f+GxR7HjEJcNrBjLDEmd8Qb2B0v7HMhgMA26S0he53vJp5+EaC5aZDufD1bSI+6E/dEnGSNP2LE8qcqsk44kI6Cj/AQP7uaSV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce2hPiEe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce2hPiEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2EB1F000FF;
	Thu, 17 Sep 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659481;
	bh=Bf4BzwWjo6ocgBulkWDMkLs6z8uI/FevXDds+v6HnxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ce2hPiEe6xpve/U5Cha9zxezQWLJzCkyOjotFYYwEawTsjQh76pVT82KTSqv5ucc9
	 BK52srZwcozoF9LjJXIu9YK/wOZlg8tgEuSTLNS3fwgFL/wgi/QsQFDyvEjBPksmBK
	 4yT/KZarUCehpuA45tIUN83py+b/duBZ2ae5sRS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 271/733] tracing: Fix comment in tracing_buffers_splice_read()
Date: Thu, 17 Sep 2026 16:09:39 +0100
Message-ID: <20260917151358.098570665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fef4a7403f3e5..beb4c35519d3b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7294,11 +7294,13 @@ ssize_t tracing_buffers_splice_read(struct file *file, loff_t *ppos,
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



