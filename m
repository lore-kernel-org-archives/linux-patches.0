Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEE5305680;
	Sat, 12 Sep 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226304; cv=none; b=XZ8sjL9pIUhA2FQFJ2A9kvwB99+HyeqSaehccTInfsbL3hpShB4jO9GBM78pi9mt6+i54kc1khzd4IcNc8Ko5mD6GcowBBkHEXJx4D1QPqxSR7j0NMFTAYZCwf78Qn0pQhtKONTfCARP0f/q85aJaSKMQm72RqVedokC/FUNBPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226304; c=relaxed/simple;
	bh=nWXIg0q5JHHi90Tyynj40c1vU6liI/5/XG3hgcjQ7XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji6J27OK+HBApHjCTFtWocCak/rVBesSz8wYWr05p+/irDmahJGZ4GxV8wqDQr7Z629xsm/RTDR0Pu1UItnrxBsf4b6ulKXekWPIqmcduEadFxJtRd8oSeBG/rQD7Zccjdu7rC3nJ1Zxpezlwauuo0hsIjU56U8SAVyucn2i8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJV73CD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJV73CD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B29D1F000FF;
	Sat, 12 Sep 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226303;
	bh=TNo5qzdf8Q47K9OgFDLti5267Cjcx1pYWfMrqH0wKKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJV73CD2BTtVG2hb8tVbrdGfvvb8yaDr3GQ/w5iKMagoSJ6susHT5DCzvcEW+DI92
	 9pgnPwWa0kS/J/yfw2InOSqT5xnJ/zopVDzJOExwAEW/lwvTxzLx1PZt2VTc7ew3TN
	 JvhLAPI10zgYxgC+fvgZ6kJf14xjTUSnK/7p+T44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1376/1424] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify
Date: Sat, 12 Sep 2026 09:03:28 +0200
Message-ID: <20260912065638.074158465@linuxfoundation.org>
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
index 35a4966035588..e16eeca8c135a 100644
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -224,9 +224,15 @@ static int __init ftrace_direct_multi_init(void)
 
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



