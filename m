Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216435;
	b=OQeF0hJ9UsjMYlquQwvtyjaO0o7T6x0+PpmPV2BFhwj+NO00FoE0a+RyiNEmwFD0XWSo
	 BhDW+bNJ4TAjx29iQyzuaXK7u3YuGjVFSvSejpNQ52iajZzm9S24cqFgqsOZKZwiz9XhP
	 EvAh+Ax3OttvRks4aCwUOZ0mus+8K7xcg7ScAIQJUUaqTZZyDb8zL1HXG+SUH0Lsy7zhW
	 ECo98tZ5hYanvHplyJhW7xPQkSm5TrllDOCCL9uyoGGErOjh0m+qhDIyPKNnN7WLPn0B0
	 qlpf3leBrhR92tVrSCKsS/0j+wo1SD/F3DSv1Qn/hTQVMS/olp/QE8YFv0i6y5g1dgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HgFe3Z90c8195tu9CGXnRTt7iKkgmHM8EH54vTbFTVo=;
	b=dXE6I/ZGf7ijtbITUpweiOS/OVe/AK+zpqSNq7lJ1HK2W3TwFUEAhDoG+rVC6X9FqVNX
	 PoW4T+wFYDILnKTlwmpBfnSPgl7asrBwI+G0yT+LHIcWCAh0XXyYZRrKD8ITM8rEcMTDb
	 XFXbmuDZLbE61CxDswU8thSjhvCcwMuXn9fzsJvaA0pBRShJFCtYuKhXE983fXZcZdqoJ
	 FWnxH6JmTriHQCc6s4Kn66wQDilcooVTCGmAPey0+pBlsbmyejqeDobmdg5AzboNfHpaX
	 zPRKSJqNIAYrHxPpubrwC1peiJeDWroQwldSVl585Ip1gPwByRztexMr45yKHT4TbwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG7byFNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E0606A332;
	Wed, 28 Oct 2026 19:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GG7byFNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37CD1F01825;
	Wed, 28 Oct 2026 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216435;
	bh=HgFe3Z90c8195tu9CGXnRTt7iKkgmHM8EH54vTbFTVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG7byFNimwgHLxfzjP/IeAtltcCAEpP4uTu7a+eNDn5SD7IKRt+McWvbPdQIkK9vC
	 ZA9c4UxYdW8Kw5FAGAQWJ7OFjrddA+NpGgUzwhbnsVrAPDc8ijYYp7TktNEgeIdkQp
	 CkybW5EYmrSdG1ZznVfMZ04vYbMyizXeCc/2UbXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1512/1887] samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify
Date: Wed, 28 Oct 2026 18:00:08 +0100
Message-ID: <20261028170533.871563732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 samples/ftrace/ftrace-direct-multi-modify.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/samples/ftrace/ftrace-direct-multi-modify.c b/samples/ftrace/ftrace-direct-multi-modify.c
index 6f23b1413745c..6859bc931ad01 100644
--- a/samples/ftrace/ftrace-direct-multi-modify.c
+++ b/samples/ftrace/ftrace-direct-multi-modify.c
@@ -140,9 +140,16 @@ static int __init ftrace_direct_multi_init(void)
 
 	ret = register_ftrace_direct_multi(&direct, my_tramp);
 
-	if (!ret)
-		simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
-	return ret;
+	if (ret)
+		return ret;
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample-fn");
+	if (IS_ERR(simple_tsk)) {
+		unregister_ftrace_direct_multi(&direct, my_tramp);
+		ftrace_free_filter(&direct);
+		return PTR_ERR(simple_tsk);
+	}
+
+	return 0;
 }
 
 static void __exit ftrace_direct_multi_exit(void)
-- 
2.53.0



