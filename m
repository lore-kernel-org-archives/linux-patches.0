Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D34418F0;
	Tue, 16 Jun 2026 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623234; cv=none; b=bxbXKwYNKU0XoANUXbm/sfpZDoCVLudCEz+duEu3HQjS/SeLgX/fGRJMO/efWrVsrvw3gEHnZAImR5xnZ9X03legFsdKO/hK/jObmNj0bUSFMct0JF9mC2Yr991K2KwpdFRJwKcBhF5VlI/yN17HuiKVvV63eZEjIsfv9RLRXaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623234; c=relaxed/simple;
	bh=S/qsbs4fzlirU61bfRE1H21mlPStYGMzRWv2WDkSIAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETjvCut7mDGqrwub2eivJ8ZXRE5BE3Q+JzzRJ2jhVuohU5848WATq2xN3j7w9kJ2vz12kMxfeM9XZLhjsZPIbdzcjjD/AQtqZPiFVyz7epKdOmX2GJl2QJrlSl6rEjFZRs2A1pMUCpk7df0TwZfUKzK3MhgpOMNhV/DAvi/tkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ey/F16BB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ey/F16BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E5D1F000E9;
	Tue, 16 Jun 2026 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623232;
	bh=W2FUBznP+qlnSNW9+ADuNR61iC/AzMwEdgMnVe0011c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ey/F16BBJoQPVzxif7DSqn5pHERWVOQcfRXdEMGdwfBdo0gs5q9rgnZ2XbPJWtWA3
	 4QWeJTXxjUXyMTAl0t2D/lNuw+X8f9LmKauc4abYxlaxiVIPGeLC8S/a3vVsWThFWN
	 hoRJctpLBydV6qxKy1m5LQ1ackHBx3bKjkQk1JdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 077/378] selftests: harness: fix pidfd leak in __wait_for_test
Date: Tue, 16 Jun 2026 20:25:08 +0530
Message-ID: <20260616145114.219571118@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4afaef01c22e97..27d1bf5fd86180 100644
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



