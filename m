Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9505C3164B4;
	Fri,  9 Oct 2026 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555313; cv=none; b=u+YWtIf85xZ8c8/3qTRtOq3vWb23t+vzikC9EvxPKSFDfr5ZORCHB/6WDqtIVoQVSkic6fEdYNhwUO/Y8JDk5+WBM3CVBQdkjTwdVvCie25yFcqLwF8Xi7Ywgn4WOPGKuK9fQk1miDAHS5P+bffGPXdOaw3RlZbuCuFRWAUXfdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555313; c=relaxed/simple;
	bh=bxE/u1V9+F/Yutb8vO1sza04xL5r8KGdnxAkiSMuo0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEs5xwnZ88CDFjqiJRU/zcgCVbAsqpca08diOUdHTz5iEk/F46VT865QEAIzb3oYgNm8Ofx+hVwMcrgJ99NEmtMKYYDcUSs+FyTe4JBx6MtL1bBnm+K2IC/r4rrtnVZSx0IuvHZbkMWue64o8znbaQ3lQBUymcNrzefXeYGHxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKoB6HwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKoB6HwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF341F000FF;
	Fri,  9 Oct 2026 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555305;
	bh=hLqitCyv/ggGVMIbGF6De4F3sdtA9RAKRxTiuAe9R1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKoB6HwY56aYNkrDO414G13t+HLzfD1b2AZ+tXFaVFEiTLYJzjC81fRqLM+IlSdAN
	 PgbadfQJBusB/itbPRBP8APOCo3ZQfOAZqisSKB/o/ujEaxEtvRHwAAQe8HlYJdT8p
	 05KDRA9kNIO727PjvEvDY9qanRIFhI8+t6mpIoiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Krush Chavan <krushchavan@outlook.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 004/428] selftests/cgroup: account for zswap shrinker writeback
Date: Fri,  9 Oct 2026 16:05:41 +0200
Message-ID: <20261009140946.120534742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Joshua Hahn <joshua.hahnjy@gmail.com>

[ Upstream commit 8c7fdc0b4c64d6583fff3e8f7696237a16ff7c29 ]

The test_no_invasive_cgroup_shrink selftest checks that when a cgroup has
zswapped out more memory than memory.zswap.max, it does not trigger
writeback for other cgroups.  To do this, it compares the writeback count
in a control cgroup and makes sure that it is 0, and then checks the
writeback count in an aggressor cgroup who does expect to see writeback.

However, when the zswap shrinker is enabled, the victim cgroup can see
legitimate writebacks not triggered by the aggressor.  In some Meta CI
tests, we have seen this failure mode happen.

Instead of checking that the victim cgroup has 0 writeback, compare the
writeback values before and after the aggressor runs and check that the
victim cgroup did not perform any additional writeback.  Note that this
can still lead to probabilistic failures if writebacks take longer than
5 seconds, but this should fix the systematic failure case and make
"not ok test_no_invasive_cgroup_shrink" less likely.

Link: https://lore.kernel.org/20260902194521.3652178-1-joshua.hahnjy@gmail.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Krush Chavan <krushchavan@outlook.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 6e7b89315bbf3..eb0933ace4aca 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_SHRINKER_ENABLED "/sys/module/zswap/parameters/shrinker_enabled"
 
 static int read_int(const char *path, size_t *value)
 {
@@ -443,6 +444,16 @@ static int test_zswap_writeback_disabled(const char *root)
 	return test_zswap_writeback(root, false);
 }
 
+static bool zswap_shrinker_enabled(void)
+{
+	char value[2];
+
+	if (read_text(PATH_ZSWAP_SHRINKER_ENABLED, value, sizeof(value)) <= 0)
+		return 0;
+
+	return value[0] == 'Y';
+}
+
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
@@ -452,6 +463,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
 	unsigned int off;
+	long zswpwb_before, zswpwb_after, zswpwb_target;
 	size_t allocation_size = page_size * 1024;
 	unsigned int nr_pages = allocation_size / page_size;
 	char zswap_max_buf[32], mem_max_buf[32];
@@ -487,6 +499,14 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
+	/* If the shrinker is enabled, try to let the writebacks finish first */
+	if (zswap_shrinker_enabled())
+		sleep(5);
+
+	zswpwb_before = get_cg_wb_count(zw_group);
+	if (zswpwb_before < 0)
+		goto out;
+
 	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
 	if (cg_enter_current(wb_group))
 		goto out;
@@ -499,9 +519,13 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 		getrandom(&wb_allocation[off], page_size/4, 0);
 	}
 
-	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
+	/* Verify that only zswapped memory from wb_group has been written back */
+	zswpwb_target = wait_for_writeback(wb_group, 5000);
+	zswpwb_after = get_cg_wb_count(zw_group);
+
+	if (zswpwb_target > 0 && zswpwb_before == zswpwb_after)
 		ret = KSFT_PASS;
+
 out:
 	cg_enter_current(root);
 	if (zw_group) {
-- 
2.53.0



