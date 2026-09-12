Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0425388E61;
	Sat, 12 Sep 2026 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224755; cv=none; b=O2oXNWPnnX7qw2gSAy+7n5s3Zkvs1A512q7orgmjSe9kfGrLppeMPgqyECmzni0jdDdes95VZOPdclDvqMIUJwGzkStXw0gvGYK/AxK+3OU4Q33ELuDuB/k9xJEm7hY6vmlfuAp95nKrf8smQ2UesQHiieo0d0jXElgsMElMYh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224755; c=relaxed/simple;
	bh=xDnZXIQBJyAUtqhGYxJdv3qvK5D867GHWm3WF1nhAdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEQWYHPoh1dZ5KM8c5sCWTEs95CMt4Acv39N6Lbtbb/jqIVI3O6vyv4YmFcSCNKDJlddylb47FVr5tzU91WQNI0mIz6ydLJiYTXeyv/Nl8sVhIu1fAXOc5mSZuqF9e4uTrxRBAba4LdiV/oDp0ZVzAArY5OtNrQQ6TIO7CBArq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSZnFoPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSZnFoPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26EA1F000FF;
	Sat, 12 Sep 2026 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224753;
	bh=D5NACvO0YHyMg6CVfxme08icBWwwSaWZ2xhQaihl55A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSZnFoPQXHLvG1JyZ5QFtBz77wcNdzJgqTJWmp/MoX03IX+ZdxXQO0KA33kPFBYZ1
	 FkuvGaZEcyqjpsOJ0sSvfqEOuR2QbUwk+S2pQOLl9/Cq4w2znJJs9hL+qC3gFGx3T+
	 KdfQCO4J5c6dvQjlPwsKIoPq7DuLA+4YcKlr192o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1059/1424] selftests/mm: fix ternary operator precedence in ksm_tests
Date: Sat, 12 Sep 2026 08:58:11 +0200
Message-ID: <20260912065631.022420104@linuxfoundation.org>
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

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 4e1fbffb3333626682a011db7c4b4e9e40ba96d4 ]

The KSM selftest uses conditional expressions to skip accesses to
merge_across_nodes on systems without NUMA support.  However, the ternary
operator is combined with logical OR without parentheses:

a || numa_available() ? 0 : b || c

Due to operator precedence rules, this is parsed as:

(a || numa_available()) ? 0 : (b || c)

instead of the intended:

a || (numa_available() ? 0 : b) || c

Add parentheses around the conditional expressions to ensure the
correct evaluation order.

Link: https://lore.kernel.org/ce859430287ed2642848c933a90eb9a69da361f0.1783446924.git.sayalip@linux.ibm.com
Fixes: 9aa1af954db0 ("selftests: vm: check numa_available() before operating "merge_across_nodes" in ksm_tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 57f9cba1b6802..ecb4b1057c6b3 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -316,8 +316,8 @@ static bool assert_ksm_pages_count(long dupl_page_count)
 static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_read_sysfs(KSM_FP("max_page_sharing"), &ksm_sysfs->max_page_sharing) ||
-	    numa_available() ? 0 :
-		ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes) ||
+	    (numa_available() ? 0 :
+		ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes)) ||
 	    ksm_read_sysfs(KSM_FP("sleep_millisecs"), &ksm_sysfs->sleep_millisecs) ||
 	    ksm_read_sysfs(KSM_FP("pages_to_scan"), &ksm_sysfs->pages_to_scan) ||
 	    ksm_read_sysfs(KSM_FP("run"), &ksm_sysfs->run) ||
@@ -332,8 +332,8 @@ static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
 static int ksm_restore(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_write_sysfs(KSM_FP("max_page_sharing"), ksm_sysfs->max_page_sharing) ||
-	    numa_available() ? 0 :
-		ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes) ||
+	    (numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes)) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), ksm_sysfs->pages_to_scan) ||
 	    ksm_write_sysfs(KSM_FP("run"), ksm_sysfs->run) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), ksm_sysfs->sleep_millisecs) ||
@@ -874,8 +874,8 @@ int main(int argc, char *argv[])
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
-	    numa_available() ? 0 :
-		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
+	    (numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1)) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
 		ksft_exit_fail_msg("Cannot set up KSM tunables\n");
 
-- 
2.53.0



