Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714F7562600;
	Wed,  9 Sep 2026 13:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961970; cv=none; b=MGsenTI4bR69Es+B10RGcj85NG5G2PkH37pyS6hzT8JtzD0bbHWoRBWSZy2MyQlZ64EQTDUElMwIzKwyoaLZRSN3zlQbKXi+thARAkzXnONspikN5KygmBtHdyVR5rb1aizk0oJ72t4x1jOKNXZVPCGg05dfDsPftc6c+QYqKzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961970; c=relaxed/simple;
	bh=sdwKYkR9OFfoLmmdTDnmvUYp3f8T+sBPVbVSC8LizI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACr2Pa/2nCUvaVHgFSOXdJioisYY9WrHtLMOEYfP2LxoteCtAXo0L1hTHfEAZ2EiCNPEaJ3r9tbCRTQAaao+9s4z1uNhsAAFpi6KDXcbjC04wRJtkBC+qDjJbfEqyHsM9Ch2BnNQRTaKRCA36e8TV0tI3bXZtxpJjQYdgtNg0rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1munvRwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1munvRwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA091F00A3A;
	Wed,  9 Sep 2026 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961969;
	bh=i4/HpwDsSmeMZea03yX2lEA+A7SQt2VE1I2moLWzY8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1munvRwt6LScHXwhXHFFjIIvdsbYUQCnYvjQxplRyge3xo5NjMHf1IoZviRqe8ULC
	 hPdkalrhZhd8JxmiCYq6kEfswbkSvzK3LxVaD5OHfwO/frgCKNazFvfGQ5BdSwB3Aw
	 3IPQPs4P7xIbpcu9tuJVmmaCMfwCOk7x2NYjojHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 078/556] samples/damon/mtier: handle damon_stop() failure
Date: Wed,  9 Sep 2026 15:35:58 +0200
Message-ID: <20260909134233.242675159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 9dc5b6d66fd51b103eff21ed0df3e292f489ebc0 upstream.

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while letting
the DAMON contexts that have not yet stopped keep running.  This kind of
unexpected early DAMON context stops could happen due to memory allocation
failures in kdamond_fn().  Because damon_sample_mtier_stop() just
deallocates all DAMON contexts with damon_target and damon_region objects
that are linked to the contexts, the execution of the unstopped DAMON
context (kdamond) ends up using the memory that freed (use-after-free).
Fix the issue by separating the damon_stop() to be invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.  But,
it calls damon_stop() for each context one by one.  Hence this issue is
only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle.
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-5-sj@kernel.org
Link: https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org [1]
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -205,7 +205,8 @@ static int damon_sample_mtier_start(void
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }


