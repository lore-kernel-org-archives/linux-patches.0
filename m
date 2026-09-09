Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C125783C;
	Wed,  9 Sep 2026 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961911; cv=none; b=RyrO7UJNycLtJf3rW60dkF5DjSCFA0aJrhWytoPvXvQLbRMg7a4s9hZya40lu8WvjZqIyCsaHyJD83XEsfPMgj72e6MssqHDLcNGySs/iRGlgYJUcXW8/k+Y+wJ/4I17Fzo8o0NW7XQtI2mTUqCjc6JFeCAJXQPwZ90cQJmoD/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961911; c=relaxed/simple;
	bh=yIicVNs7FaR5moSCSBRXSQhG/ZA9ACLz/QExlA/xEN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVdvZyUncaFKxXSfUOLRUfDdgeG8kg2CZRFeF3yRkrPPHpHxnJGy1b5u4rU4R8UIeewLdQ6u1vXzuT2Vb0OdAqk4fYSZbk7epJvdKN1vHg0jNQQZc2/Whdk0A8C/OUiNiGmTa6V0JCxjCxKBHNzPFLWLu1vQFjOderYjD4N0Lqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+NRMEVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+NRMEVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623171F00A3A;
	Wed,  9 Sep 2026 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961909;
	bh=bQgNjZBFpWeJPtyNh5woVFHt8sCnNWzujsgk+ekrGtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+NRMEVNy3+yZQBlWwAMJjxXo0+Sdm+L+di5zlEc+WCZMvUtc1NIEcJNSDVUclgye
	 CH9DpbcVn7ZipGyiHdIEPHHwe9GdH9A5IlBeaU9GFIOLiag8PxNn1/HDLJ0aILqtYP
	 Emig+sfvyuEjgi+FAuCdkrzcqHvZpP1dgOOW3VQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 081/556] samples/damon/wsse: handle damon_start() failure
Date: Wed,  9 Sep 2026 15:36:01 +0200
Message-ID: <20260909134233.353665324@linuxfoundation.org>
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

commit e4742be45ea45bf554399ce89a09f71e525d7981 upstream.

Patch series "samples/damon: handle damon_{start,stop}() failures".

All DAMON sample modules are not correctly handling failures from
damon_start().  Among those, mtier also has an additional problem for
handling of damon_stop() failures.  wsse and prcl also have a problem in
their damon_call() failure handling.  As a result, memory leaks, next
DAMON operation disruptions, and use-after-free can happen.  Fix those.

Note that only the damon_start() failure caused issues can reliably be
reproduced.  Reproducing those issues require the admin permission,
though.


This patch (of 6):

damon_sample_wsse_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup failures.
However, it is not doing the cleanup for damon_start() failure.  As a
result, when damon_start() fails, it leaks the memory for DAMON context.
Free the context in case of the failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_wsse/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_wsse/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance cannot
exclusively run.  And without this fix, by repeating the third and the
fourth commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-2-sj@kernel.org
Link: https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org [1]
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/wsse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -87,8 +87,10 @@ static int damon_sample_wsse_start(void)
 	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
 }


