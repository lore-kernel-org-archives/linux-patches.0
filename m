Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576643E022B;
	Wed, 30 Sep 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796628; cv=none; b=fS4IFHO3rnotS4oxMkst3Y/xI2x/PVxSmZl9xlyJt9+ggPT7Phnjgpj5GMD2ydVOsdj26CaCHwl1m+Axsnltsef+xNSTMS35gDFJnsdic9DMUwjA8U2gJoEg57PAAZ01kZZKqhSbSe/6yses1T52s8XzH081pn77QnvMDQZAXbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796628; c=relaxed/simple;
	bh=4s9MdB2Hr4vRStuNh79v+lSZhcQA2bNgovRRzjpAMhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grqQgomlWxUDaP5CWiBOEHlK2e282AV6nLmYMf7ashm9NnQnKPjKa5OYJF2lMDhn/iG33rGni5P8BWdKqi+Lmpl4tWB3J+Sz2Hblq6EUKPiAeIqpYwE1afJFXT7RBZsTZD6JlFQCn2aWSFSNfybVia3ccdWsBrHJ8Y+oSPYPhCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIOB+X86; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIOB+X86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B8B1F000FF;
	Wed, 30 Sep 2026 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796627;
	bh=7p2P9CQhBQI4gSupb6IAt9mOs3A/2soK92+PbXEr72U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIOB+X86wW6fLGlnX0tfVYtr5zrMIjBUImSdHWeLfgbpkd/ASscuK4OeSdfTFPPV/
	 QdDkm2Z56v+HLcs0V7htwia8GOWMqBcAuRW5Ff+iM/48BpxPySNnYFdHVo+Jfphhpx
	 FMLYgHpEi/g0KsEnWPQRqoGkPkfkgLYxO6cy1s7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0979/1193] selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode
Date: Wed, 30 Sep 2026 17:27:43 +0200
Message-ID: <20260930152455.994021367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 609ac5652a46c..25b0ff273d649 100644
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



