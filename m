Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8C377A9A;
	Sat, 12 Sep 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203518; cv=none; b=gE94uqGNwmwgi4GKa7ldmg6FZoCprCS6gAnXXlkCSjTK6bXyv7e2FymxWCRNa9EVfMu8T0n7ooYjGHpOAuBdAxMH8Ew7DG1bHYtfPE+lcg97Km+cMI8wW05TucA2vhgrx5JgyjkxvBl1OcBq+1bVZR2etzG2Tvf8/YCLmYU9XOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203518; c=relaxed/simple;
	bh=knQFzsfAWGByNVizd+UODes6RL11pJBkJW0ovVN+96s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TuVBpl4Iyc1fHNg5LM0AOce8QFvohI7mgI3MpAMNavAR9vmaup9Btkg3T8LCFWdYQE3mNd1u6ImuV8jwR0jlTviSrXbo7/QOcNysxXqSR2SCn8aWkGmSd9lWGXU+ayCEluVyFrpdnKTvX/u+TKFLH41D6T1xsDB7MksMLoM9ndk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlTTMCon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlTTMCon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6991F000FF;
	Sat, 12 Sep 2026 08:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203517;
	bh=u+UBhtkSXa7gXN8cN3FB37sUz988ghTOu1rmU0C7Lws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlTTMConzXdJVvfDjc75FmlKr/+5/SXWD+fzw6dHB0uXJWuL7y2dAtMOAzf1hwcQa
	 hDPpDDHn/HT+JKbwM73hPUH5LuQY7YIoPDmDdcW/sTJT1suKCpMKh9GYsotv6XIHmY
	 Yhbl9y5wJT/Le6MDcmB7aiaehecgGqCWQcX2LL5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1425/1815] selftests/namespaces: Fix racy pipe handshake in timens and pidns_separate
Date: Sat, 12 Sep 2026 08:52:55 +0200
Message-ID: <20260912065722.472755506@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>

[ Upstream commit dcacab904fe78d60840ba947a104993ee9ded887 ]

In timens_separate and pidns_separate both the child and the grandchild
write a 'Y' readiness byte to the same pipe, but the parent expects a
single 'Y' followed by the grandchild's pid. If the grandchild's byte
arrives first, the parent takes it for the child's and reads the pid
misaligned, ending up with a garbage value.

The parent stores that pid in self->grandchild_pid so that
FIXTURE_TEARDOWN() can kill the grandchild. A garbage pid leaves the real
grandchild alive in pause(), holding the test runner's TAP pipe open and
hanging the whole collection.

The grandchild has nothing to report, so drop its write() and leave the
child as the sole writer.

Fixes: fdb48976b637 ("selftests/namespaces: Kill grandchild in nsid fixture teardown")
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Link: https://patch.msgid.link/20260810-selftests-namespaces_race-v1-1-4307e833783e@marliere.net
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/namespaces/nsid_test.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/namespaces/nsid_test.c b/tools/testing/selftests/namespaces/nsid_test.c
index 46dc838cba82d..a16f31f41d38f 100644
--- a/tools/testing/selftests/namespaces/nsid_test.c
+++ b/tools/testing/selftests/namespaces/nsid_test.c
@@ -649,8 +649,6 @@ TEST_F(nsid, timens_separate)
 		/* Fork a grandchild to actually enter the new namespace */
 		pid_t grandchild = fork();
 		if (grandchild == 0) {
-			/* Grandchild is in the new namespace */
-			write(pipefd[1], "Y", 1);
 			close(pipefd[1]);
 			pause();
 			_exit(0);
@@ -771,8 +769,6 @@ TEST_F(nsid, pidns_separate)
 		/* Fork a grandchild to actually enter the new namespace */
 		pid_t grandchild = fork();
 		if (grandchild == 0) {
-			/* Grandchild is in the new namespace */
-			write(pipefd[1], "Y", 1);
 			close(pipefd[1]);
 			pause();
 			_exit(0);
-- 
2.53.0



