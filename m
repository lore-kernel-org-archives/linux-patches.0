Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138A551AED3;
	Wed, 30 Sep 2026 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792853; cv=none; b=f0bnj9Uk1eJi6p9gO+zhmnBu/mCxdkqMf46eUJDNnnxu44qTQXoIrEUM+2qCMRPTP+seZlrs0QEy8uo4yy2vzpeZ/qb1kbw3rPg7syD9Ej4Q/2BMEjQ1Neo/rhn/slIK7OT8qQ2GTZ/3kBFYnAk6aQtTH1x5MVuwsb0VWZQQw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792853; c=relaxed/simple;
	bh=5uOUNnxrov+m4TgpleZr4sQjm4KYWqII4Gdhx446SIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWUKprpWhfJRNvcxPpYejxXs736Vnd6lXYroFGSgViryW0f1gkI0ZAMi4cI1UyLyOEAQIScTG7pLM11MntD0Lo8z5AErodMYViYxNsFTRSNNBW58sLy2qAevI/fqRDHC2PsOkku/6aKwgcAZcFa3UY2EN02VyVRJlyGC27lyPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKr7bW6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKr7bW6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05F1F000FF;
	Wed, 30 Sep 2026 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792852;
	bh=LCLNsXuyWAWFhF2MzuJBgL/9/9gNRXRR4EDjfQv//Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKr7bW6LN6oh2Eh2dFgUAzieNfjJ00xsPSbAN9LQ5tZEYh7c8z/scEZLiYJRAZVUM
	 +4FJ+hBqNn2DqW4D9k3eLi3zM1g0/xNofBU4CQ9lENr1oD4mcMpEHQ0K787TrdBl2B
	 DzT0LjsILqbzJ+8HAeLq0YovPWde+mLlG2E8fyxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/395] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 30 Sep 2026 17:25:10 +0200
Message-ID: <20260930152341.675788697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

[ Upstream commit c774ec8f0a5d02a06d34c27f5a7de7e333b91265 ]

O_TMPFILE, like O_CREAT, needs the third argument. Without it glibc
refuses the call at compile time as soon as fortification is on:

  In function 'open',
      inlined from 'get_temp_fd' at test_memcontrol.c:33:9:
  /usr/include/bits/fcntl2.h:52:11: error: call to '__open_missing_mode'
    declared with attribute error: open with O_CREAT or O_TMPFILE in
    second argument needs 3 arguments

The fortify checks take effect only once the compiler optimises, and
cgroup/Makefile builds with "-Wall -pthread" alone, so this goes
unnoticed in a plain build. Building the tests with the flags
distributions commonly use, -O2 -D_FORTIFY_SOURCE=3, loses
test_memcontrol entirely.

Fixes: 84092dbcf901 ("selftests: cgroup: add memory controller self-tests")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 1f64db1afa212..e383fad6e5bb3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -26,7 +26,7 @@ static bool has_recursiveprot;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.53.0



