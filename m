Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1203C309EF2;
	Sat, 12 Sep 2026 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226300; cv=none; b=mTYPbjuQ6iuZMMDAa3hUHe3pEAWZ9GAOJpjCqC3z7qqIcDSO0sev2V2vpem9SZ+pAvNnBjxRLYLDUJ0uv9q24BJ8GkkXyojuB+Vlg6I8EzOVkoaJtsCOQJK1AJhXsF/HKIVx7ikBjCekfhuHsM+ep5Hcz7ZxXGHlfbOHkEjlHpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226300; c=relaxed/simple;
	bh=Bs+ZoONZqu0WN7ZgNUCx+VcEX9JjEnEQTIo0iEyYKy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7qe70OthcIv4wLXMTa0OR1Cqam1xBGr8tgEMt1gqYYCWGB529KFG2bumrnpdDCKyf0084bXQBc9Ta1eraR7w+XE24l8kLr/5Y+A4bNp+LdPKaroF41hCGOkZwAXHxQirbWb1TFOX1p+LGy+bA11EBa/Jl/DJ/fOgp8AP3qmR7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd463xag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd463xag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95391F000FF;
	Sat, 12 Sep 2026 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226299;
	bh=VIHbHpB4v9t7ncNSv7xpmXaQIIzijQBkLV/GZGNvvl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zd463xagP792ns4bCbpvvPHQJDJxaJgVKT5QkW/oi7x3IJWzb/URgdGJJGcwMrlnV
	 ghEpbWIhCOySThp709cGIG49oeEjU9f1kIbXFXPn4JwBky+91P3ghzB2zAuya4zFTX
	 vN5w0bGA69Q+bOLmlh2Bt+gqfI5No5BJhfQAD+lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1375/1424] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify
Date: Sat, 12 Sep 2026 09:03:27 +0200
Message-ID: <20260912065638.052741558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eeeafe3375c4b..394fab99fc4cc 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -202,9 +202,15 @@ static int __init ftrace_direct_init(void)
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



