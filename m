Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388254E06CC;
	Wed, 30 Sep 2026 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786951; cv=none; b=qY5T/SCKFTnoBIPBPGYh0eO/hwP5Dq3S65aLOxbA5nKDhbIvGFSeQZtg/XP1juwq8nMiGbYm+MwloHVognCz69MtCTzvfBxuoZDNbGeOKqEjU74r3pxkwaUUN6vVA0XHUZ5qaUS6MktGaqUY8XMCaiElDOMiga2SRKVCxN2xY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786951; c=relaxed/simple;
	bh=23WU42OW7V9ITO4EeMlMhXFbUwT0FVFbxSxwhZnu2dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGJIs9uIge3zE7HlcNcWvHsBNls6pp71aNaJP24RFuSC7S5PQXvzFAWWfDKp66uMYy0S6j+12Q3IMmS5KNDwtVrGv+Z1BBfIn+3xGfL4A9+/uX/ewJWH5cjOgWPjmatYG/HBaWzZ/0edZPtTCDHMvxHnqmxC2zxFmk3WSbGU4W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3r/Vk68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3r/Vk68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9325A1F000FF;
	Wed, 30 Sep 2026 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786950;
	bh=hBW2zjIbLl+qiTsXhoAgiEAP3HRTsR101lfYx906ezI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3r/Vk68CqT8csY38vgUblWNa7J/Ivt//CkNUwaOp2lp3/lfkRvL6irBPGzuybFQs
	 rN/DIYTz41Owz/wOv3Zcz6nEbO9hYX/guC3L5bFYLNrVYquPh8OOSpiXrNIK59vrUM
	 hZv33TX4fGl/rWqkk+C/TGVsC24hXefpluauZp7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 057/457] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 30 Sep 2026 17:22:42 +0200
Message-ID: <20260930152347.269399872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3a84d068fbf36..0ed82347044ed 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -30,7 +30,7 @@ static int page_size;
 
 int get_temp_fd(void)
 {
-	return open(".", O_TMPFILE | O_RDWR | O_EXCL);
+	return open(".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
 }
 
 int alloc_pagecache(int fd, size_t size)
-- 
2.53.0



