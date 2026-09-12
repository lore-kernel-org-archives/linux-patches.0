Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673732BDC0E;
	Sat, 12 Sep 2026 11:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212423; cv=none; b=SSPGXGxYDgop8/D9uRzhHoVcjGQYhOS/bm8ITZxKZw9YqZ2hu7pJJldV3AYvB8p/VOJWLN8x9XjdMRW5QZnxASOvO4VMabAVt5qbrcX/mtgRZ9p5HoASulKfwRu3VSGlRxvJ9UBFVwRHNnQOVF2C1R3XJBQZTjihMEM+4TtNrmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212423; c=relaxed/simple;
	bh=Ku5yx/poFVrcY4U1LMul6/TodDVflnTlxZQB+Ejf1YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7+K5jCy4Xj1/t4WVatPnW44vUJJAdEZDCLHWboNfeW72oViP81sd8WDU45iCTe/evNvPunSVa85EY2T0KWpGUEGO32KnTioXuGFvFhkoCi5XXe4Vk3a32Cp2G2T2E/6blZgPqbsrxrU1yLgQbHZbz+RulFI5OxnPkIVsdlunQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4bwYgOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4bwYgOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581AD1F000FF;
	Sat, 12 Sep 2026 11:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212421;
	bh=8c9onnoiwqmaqHyh6aA18082nPrGpdrn1K07NArMEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4bwYgOjFn52rCxAeb9zvsgv1IEve9xdhuTgWaukbQpF6BaB78s9NJMRyn4YDQBMZ
	 raXr4ndu110Kez8l4NTth5aJyQNgMuq9R/b5SpZjpeCn5xFSQTQ/FM49C3h8lapK4N
	 HPHbOdYWd6dazPmaLV3tKwOnx8oZyi8fBJlmbgyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1434/1518] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify
Date: Sat, 12 Sep 2026 09:00:03 +0200
Message-ID: <20260912065655.992678920@linuxfoundation.org>
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



