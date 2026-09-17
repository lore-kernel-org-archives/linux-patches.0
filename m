Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4902F4E73BB;
	Thu, 17 Sep 2026 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658742; cv=none; b=IR1VfDhqb4GqRouX2DGhimWnnRIyhagTw4ecgotfuEHMXnDuhHfEgEM2kccJWRAhkF/xsbtGp0UrIgUYYYAJr1gO+5UDwz+OhdBXNoTzESv/qlo1zH5S3OTrt7yaxkOrDEPvi/3/+4W/rGKGdL9Q/iBa+Z7eqKmrDNACK1YHgMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658742; c=relaxed/simple;
	bh=huzYVSNY9grhqiQJeCzxDR3q/vk/NrYAIS2ZkL68dZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkEXsDUiCcnnc5kLCBzN4EGzjos+cm4VDg3DuPEyBOw5MkesC3aGc3rZJt1qdicWzzmNNQ7H3W+v96d9nlZnrWok+9CTiJIeWxMASB/maEB2bLYyoSrOwc3DarizsEMXbwIGDf831sOpj9IT4Tskbj9XKc441o2CTFy3jpc2pP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uX/OafwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uX/OafwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0181F000FF;
	Thu, 17 Sep 2026 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658731;
	bh=tccHEs0YVu6GYVlvEzYWRq7dG9meMXIVMzPNtLiUkwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uX/OafwLNNcCim1CngyTSklk65EA9Pa4H3+7X5cPK59lZAakH3rbbwcYUvYjV4Bov
	 KmmVryy4ZzVnkokWzShcXBT5s067zPsBUXclxd6E4j+gDHhd4f0C/OObzLXbBj0isL
	 xyS4QAt/pI5lhUQeDya2OTyho7a+RgqjHoFVc2RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemanth Selam <hemanth.selam@gmail.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 021/733] selftests/cgroup: set the test plan after the setup checks
Date: Thu, 17 Sep 2026 16:05:29 +0100
Message-ID: <20260917151351.219798444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Hemanth Selam <hemanth.selam@gmail.com>

[ Upstream commit 0c893d170ff8efe7b4067552932d26e7defba307 ]

The cgroup tests announce their plan before checking whether cgroup v2 is
available, so on a host without it they promise a number of results and
then skip out after the first one:

	TAP version 13
	1..3
	ok 1 # SKIP cgroup v2 isn't mounted
	# Planned tests != run tests (3 != 1)
	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

ksft_exit_skip() can only emit a well formed "1..0 # SKIP" line while no
plan has been printed, as the comment above it in kselftest.h points out.

Move ksft_set_plan() below the setup checks that can skip, so that a
skipped run reports:

	TAP version 13
	1..0 # SKIP cgroup v2 isn't mounted

Several of the tests skip more than once while setting up, for a missing
or unwritable controller as well, so the plan goes after the last of
them.  test_core joins its two setup paths at the post_v2_setup label and
sets the plan there.

Reporting each planned test as skipped instead would keep the plan where
it is, but the setup failures here mean the whole test cannot run rather
than its individual cases being skipped, which is what "1..0 # SKIP" is
for.

Fixes: 1dc830ee4c15 ("selftests/cgroup: conform test to KTAP format output")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c       | 2 +-
 tools/testing/selftests/cgroup/test_cpu.c        | 2 +-
 tools/testing/selftests/cgroup/test_cpuset.c     | 2 +-
 tools/testing/selftests/cgroup/test_freezer.c    | 2 +-
 tools/testing/selftests/cgroup/test_kill.c       | 2 +-
 tools/testing/selftests/cgroup/test_kmem.c       | 2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 tools/testing/selftests/cgroup/test_pids.c       | 2 +-
 tools/testing/selftests/cgroup/test_zswap.c      | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 88ca832d4fc13..64f4962a4659d 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -927,7 +927,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), &nsdelegate)) {
 		if (setup_named_v1_root(root, sizeof(root), CG_NAMED_NAME))
 			ksft_exit_skip("cgroup v2 isn't mounted and could not setup named v1 hierarchy\n");
@@ -940,6 +939,7 @@ int main(int argc, char *argv[])
 			ksft_exit_skip("Failed to set memory controller\n");
 
 post_v2_setup:
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 7a40d76b95487..8f96bfd19ab9f 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -799,7 +799,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -807,6 +806,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
 			ksft_exit_skip("Failed to set cpu controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index c5cf8b56ceb8f..52ed8fba685ae 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -250,7 +250,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -258,6 +257,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpuset"))
 			ksft_exit_skip("Failed to set cpuset controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 0569e93fa6b00..f28bb02e9783b 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -1491,9 +1491,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index f6cd23a8ecc71..99cafd9dc0136 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -278,9 +278,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 1db0ba1226b9b..cb47561b4b443 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -426,7 +426,6 @@ int main(int argc, char **argv)
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -441,6 +440,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ebf796f3cffe..3a84d068fbf36 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1798,7 +1798,6 @@ int main(int argc, char **argv)
 		page_size = BUF_SIZE;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1823,6 +1822,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Failed to query cgroup mount option\n");
 	has_localevents = proc_status;
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_pids.c b/tools/testing/selftests/cgroup/test_pids.c
index 9a387c815d2cd..710109b53dfe9 100644
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -148,7 +148,6 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -163,6 +162,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+pids"))
 			ksft_exit_skip("Failed to set pids controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (int i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..6e7b89315bbf3 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -810,7 +810,6 @@ int main(int argc, char **argv)
 		page_size = BUF_SIZE;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -827,6 +826,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
-- 
2.53.0



