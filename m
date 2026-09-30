Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1792051A14B;
	Wed, 30 Sep 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789035; cv=none; b=lflCRTW6vwK1h1uTdWu4E2j5TaR+ibYVbpq4iiDG7eoiufTaz7YY4lFY2pWhOiGIhp+qUs9r/pMFXBLlpqWNAtUjEbEtZhXWe6nlO0i1eZdteaKQZblLX8RDKAZgmBY6qDlYtGPrvBPEJJsigXuAYcSYY2o5sGb4QfOjSrbTz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789035; c=relaxed/simple;
	bh=dYfQhySkbhlME62pmax5aP2YUEu63q22++wjp2tddf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHL5JUUzm6aiZ9ao28PVcofbi4yvLw42PEO9slaMM3ESV7qmKBf3VNUkgSfLycwkiAbRt/uJy66A55M3OrhV6UQcLfVAdDhyCBmF0sXhdAbhDlkJairw/hqVHIvXel2AY+/CP1wKwon/IkJ1mfiZopjskxshO6NbbPyFQwiBQlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk/H6rYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk/H6rYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C69A1F000FF;
	Wed, 30 Sep 2026 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789033;
	bh=o137q4iYex5n+5D3em4THWTMNenZAHZbmQvn5gj2bJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rk/H6rYZKyBswIX4jYLMuvjbltcPGk3tAx+CVCvENoWbDk6IodItpDHc/qXVHO40r
	 vbu5poOsYLaRZuPoON1VuKlk0nCi4QP+KY3Xv1VY5l72vBvZM8nL3l8JnfoDldhZMj
	 X2vIckO/1wXygFyWSR9KRgEbMjJ46bx9cpvQG11g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/877] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 30 Sep 2026 17:20:45 +0200
Message-ID: <20260930152421.882307807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44baef99fdb0e..d817aec949fe4 100644
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



