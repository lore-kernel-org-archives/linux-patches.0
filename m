Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A02BDC0E;
	Sat, 12 Sep 2026 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212427; cv=none; b=gMEb+Cbtq39aNCfUb74t5e8UJNlttMeXZRXGru3XDMtMzDYq+jfkeoySLN9wgyLBxPzhq3oetVFYTSvDDJDyNQIFYOiYrKxDXMug3g831/6wnl7y/3g5ueAaeT5mcFsclGg9wpvt6yIMdytoTDN4hEj2X3TO8lmau7iC5PANV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212427; c=relaxed/simple;
	bh=y3xbZSQKz6d/4u/5AqK2LVEibkeL3GH2mgzVHMETxO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XU40PdR7W5jn1Mjip4rjqA2HNFCUQwHqsjWIdaPoLc7iHmBkcefMrNJAH2s6QfauaOmoxBHEclFNuZOIkDcq1Eh3FzpvRQ3qco7htK76MWQ/5uxnXD5D5NKBSeF8qu1/9d/Dz+SzTmrGmxNOnPtpg41MqdTV+EgYvThAY+GJMvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw7zcpiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw7zcpiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E81E1F000FF;
	Sat, 12 Sep 2026 11:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212426;
	bh=6uSopiCni+sD838ya+I1rV+7GiCiJUGVtEc3Sp68RPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kw7zcpiD6RxRATj2aTjYDV+R+4UzS9NoW8LZP+zJjXge3lK8W8K/csNaCBruvmo30
	 7SNhvQFgTFUnO5AE3cysu6/BWRcO3pe+KlIz2CvVWAe3hMy12E6bVaTI2SErrxTLin
	 1us0rxuTcws+T0q6doqeZZg9qVF33x7x8u5qKbd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1435/1518] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify
Date: Sat, 12 Sep 2026 09:00:04 +0200
Message-ID: <20260912065656.015571572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6727b7618f49401acf373fa3ec5712e2ec52e5cf ]

ftrace_direct_multi_init() assigns kthread_run()'s return value to
simple_tsk without an IS_ERR() check. When kthread_run() fails it
returns ERR_PTR(-ENOMEM), but init still returns 0, so the module loads
with simple_tsk holding an error pointer. On unload,
ftrace_direct_multi_exit() then passes that ERR_PTR to kthread_stop(),
leading to a null-pointer-dereference.

Check the return value of kthread_run() with IS_ERR(); on failure,
unregister the ftrace direct call and propagate the error code.

Link: https://patch.msgid.link/20260826015050.10772-1-vulab@iscas.ac.cn
Fixes: e1067a07cfbc ("ftrace/samples: Add module to test multi direct modify interface")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/ftrace/ftrace-direct-multi-modify.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/samples/ftrace/ftrace-direct-multi-modify.c b/samples/ftrace/ftrace-direct-multi-modify.c
index 7a7822dfeb50a..b03766c6217bc 100644
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -364,9 +364,15 @@ static int __init ftrace_direct_multi_init(void)
 
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
 
 static void __exit ftrace_direct_multi_exit(void)
-- 
2.53.0



