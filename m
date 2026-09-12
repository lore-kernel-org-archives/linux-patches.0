Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF741A92A;
	Sat, 12 Sep 2026 09:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205229; cv=none; b=HvQUbD3x97UqYUoYbJSK4QS1w7Lujui1C3m+Ybti7E/6yTT2/wq9ZOjSzwYQLhXNBLo42znH87MpmN4FPhsQaVmoLv3Vgb64E9YPzwwwwn4WHKTvCsl+cFzLpP2T3b1GzBfA+g9CKAjJswJo9+O819wXAt+CHe3x9lKMNSeCbrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205229; c=relaxed/simple;
	bh=KApnRKBwkuFjU0WNbMfxrGeTWJv66+E7Xk41pnF7S6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsX9Ym9mT5dAQLo+UHA8RsNM+kL8ds/UBWVBNw/RauuR/5r6c2Ysy6hSZ//0Etr83hiV/MJlB3xTqDUZAh17rwLIYOu/Vs1yd/ahZI+3OlyZnVEcymJ77QZAk9xl8rP+PY7e6li8EXdRG2OaZg7/GrP1ShJd3LOeLXLSSamYhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJTV8usB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJTV8usB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1961F000FF;
	Sat, 12 Sep 2026 09:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205227;
	bh=ylbC9gBvclZfsRnEP/4M0ubAPuuoliDkJOV0XKcw6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJTV8usBvczNbav83NdSUhqj2UMWd/gMl0mNbC87LKeQ4XLolvyJ5UNwLHOma8qci
	 ef8UJ6bfp0vqfRMwydgLGbA/xn/DFkvz0YF4gJLLA8djPALF/GH7xQr2whnd5WEIz3
	 GF4eh4wZTo1chkPsNH5AjMungplqFbtMJytORwok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1774/1815] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify
Date: Sat, 12 Sep 2026 08:58:44 +0200
Message-ID: <20260912065730.656502787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit d79fb758e7e2e7a181eab630c0545a56041c473d ]

ftrace_direct_init() assigns kthread_run()'s return value to simple_tsk
without an IS_ERR() check. When kthread_run() fails it returns
ERR_PTR(-ENOMEM), but init still returns 0, so the module loads with
simple_tsk holding an error pointer. On unload, ftrace_direct_exit()
then passes that ERR_PTR to kthread_stop(), leading to a
null-pointer-dereference.

Check the return value of kthread_run() with IS_ERR(); on failure,
unregister the ftrace direct call and propagate the error code.

Link: https://patch.msgid.link/20260826015034.10755-1-vulab@iscas.ac.cn
Fixes: ae0cc3b7e7f5 ("ftrace/samples: Add a sample module that implements modify_ftrace_direct()")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-modify.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index 1ba1927b548ee..164d9dd6fd921 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -320,9 +320,15 @@ static int __init ftrace_direct_init(void)
 	ftrace_set_filter_ip(&direct, (unsigned long) my_ip, 0, 0);
 	ret = register_ftrace_direct(&direct, my_tramp);
 
-	if (!ret)
-		simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
-	return ret;
+	if (ret)
+		return ret;
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
+	if (IS_ERR(simple_tsk)) {
+		unregister_ftrace_direct(&direct, my_tramp, true);
+		return PTR_ERR(simple_tsk);
+	}
+
+	return 0;
 }
 
 static void __exit ftrace_direct_exit(void)
-- 
2.53.0



