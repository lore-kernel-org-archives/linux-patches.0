Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBBF53FD2B;
	Wed,  9 Sep 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961846; cv=none; b=JkibWVx5PwbcvSTn+YW6TY9JtlUhOwIDmINv7XqAVgJQ2y0qPB76nMYWIvlylE8V/YKFYIbOtYkBStLvKtvIgpnxuwuCcmXHZ9DG6nYty041iAMogGGGzC4XNJSabL8DuosV4UPoTR6pBgxWbMD92YYt76MIHUeHoMxfC4iW4CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961846; c=relaxed/simple;
	bh=oMWQs2fHuJmeR0SlYrmH1Pxf1d3uP2uwBwQHug6O2YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkF88lmD+Klqd90IIhO9arpAIdGqvWXMDEUfEOhmhdDYXybci3aRKjgcOPzqFtYWNzRwSJY/egnAiVnwnxE3S319JT4PMk1PTJsSaYU4dLKQ6d+fBGhOttVR6TLLBmpFtdFcS+phOmK0Ozw2sQgw3SCq93vcUrR0wwejbD7aEm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmigmA5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmigmA5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CD41F00A3A;
	Wed,  9 Sep 2026 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961845;
	bh=fQP1/K0+28nsUDdnK1tkOf/KagAUooS9XLoRy7JTBO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmigmA5Lpjasn5ijXRZYo9jjWjVEg5RIA/KjJAshTI4S8KQnxADQRGGJ+Vlon2hA6
	 k9O54G/GkF9z3oHaT3amy5Nenn0HlB6s/nVzEpdcEF3nUxYPaoAMbQ4eRpqL0S/DhZ
	 06dcKDq4LTxfPcVb4iwN+rKYxTH4xyPH4D2Qvao0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 079/556] samples/damon/prcl: handle damon_start() failure
Date: Wed,  9 Sep 2026 15:35:59 +0200
Message-ID: <20260909134233.280414736@linuxfoundation.org>
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

commit 8b724349229bb6ebbf781178be011ba9bc2cca57 upstream.

damon_sample_prcl_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup failures.
However, it is not doing the cleanup for damon_start() failure.  As a
result, when damon_start() fails, it leaks the memory for DAMON context.
Free the context in case of the failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_prcl/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_prcl/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance cannot
exclusively run.  And without this fix, by repeating the third and the
fourth commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-3-sj@kernel.org
Link: https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org [1]
Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/prcl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -106,8 +106,10 @@ static int damon_sample_prcl_start(void)
 	damon_set_schemes(ctx, &scheme, 1);
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);


