Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CA144CAE6;
	Tue, 16 Jun 2026 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625062; cv=none; b=jM1teMQo1YxdE2CExzavNsB7ZHdCiMJ43tz7NRqwbZD6tpu59/M1mN8ausMdXaJs+sDofMkEhBSNF/tovXbK5MXoev1ObyQ0Met0JwZ+B2gMD6gTGErguircR6Ho7Zn9Nwr2WBrpsUtOZw8J6RPK2GETCX8YM//QpXUdoFtcGus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625062; c=relaxed/simple;
	bh=RI3OdWmTjCmq7rG9w5Dh11iI2eSTmkCxgTj5gVlXVC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkKnwPQ8q1+dJU6ww3xXzpe9VOI269ANtqUH3QSWbr+uLk/0o8b6+f2pJWyjtkvCZc9k30bWmHd2WNhfsz6ga3HnX3cv5MCxbhzt7OJmdZSLDKY/szADaOD8gBE0WiN21FfCfxHeU2F8HM5yDXaUsXtT38mbGNPKdKA2oeuNFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfedKV5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfedKV5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8A71F000E9;
	Tue, 16 Jun 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625061;
	bh=WJ5Rnw95TeEdJXUi3nHwtiMFcpf6mRQnCBuV5Wsmues=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfedKV5snvwEkolU/ium05URPugdqEqEYIJ8ThWTIRdyjdYru/6XplYlNDqVZl56u
	 Aw18qRxTO1rJzEgFxY4yhh3qmuEm7gYqfvRlgYAO9iHZvDPy2X3fYzsnB17ANuiM5j
	 zBC0tPGhbTed3m63FkNR2Zi8eqUPNC4ryNjfmi/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/325] selftests: harness: fix pidfd leak in __wait_for_test
Date: Tue, 16 Jun 2026 20:27:47 +0530
Message-ID: <20260616145101.254327562@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 0eb307d61317b42b120ab02099b597226318358a ]

Fix the pidfd leak in kselftest_harness.h's __wait_for_test() where
childfd = syscall(__NR_pidfd_open, t->pid, 0) is never closed.

Fixes: 73a3cde97677 ("selftests: harness: Implement test timeouts through pidfd")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Link: https://patch.msgid.link/a82e275ccfb2609a1984d90ab559fa3af78f1e81.1776678050.git.tanggeliang@kylinos.cn
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index fe162cbfc09121..6928915a643b1e 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -996,6 +996,7 @@ static void __wait_for_test(struct __test_metadata *t)
 	poll_child.fd = childfd;
 	poll_child.events = POLLIN;
 	ret = poll(&poll_child, 1, t->timeout * 1000);
+	close(childfd);
 	if (ret == -1) {
 		t->exit_code = KSFT_FAIL;
 		fprintf(TH_LOG_STREAM,
-- 
2.53.0



