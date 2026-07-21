Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EB946F4AB;
	Tue, 21 Jul 2026 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660920; cv=none; b=B3LSwTNxBSOjqvkyfMnCyhkJ0Apt5bYbWccMhzKyGZB7vVik9pohGQLt0OrMniYmgb/uofjgbDQwJCZg7/uB1TxkODeM2yAICij6/lpODXZO6PxhTns35RkdWu+DD+82a6aVTa9nK8jX+VfpDuk/Pb0qZGAMhYoGMKsnDKeHZ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660920; c=relaxed/simple;
	bh=9WB/EfTEEf+nQY6V6DrpERhVuOoHI3l7bkwDwZ/7RsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH2+3oIoaKpOuuVeIRdrXz2vSeZFQ+7kaLA7NXNo1/T9tUucKsZBD37/X5VFFBKBeQyDMcK91597NYnkjytR24qBoXO3wzKwowA3bd9JEV0YwpFVBQWSF0FO3AmzZ2cuemLIoyYJsuudG5igHp8N+VaoJgQ2Xt0dhSHFhdhGrAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHY6ouTL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHY6ouTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5CE1F00A3A;
	Tue, 21 Jul 2026 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660919;
	bh=7gZRHQckFyVoN6WtGgvfIuPfxTbxkxVCEWajWGG3ia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHY6ouTL9WJVMETkTfwag15vg5DAXmmVGBA5jxB5C09ShUJulmiuaO5o7Srtr6UY9
	 E9UiOjl0TCe+fO017EQ2J6e4Hs6TkG28pkbOvERyi6/zhG3NkDV7O3auVHrIKEqk0t
	 yI8Sag6/Oq5uWQHyoa3G4Xa7kPimgUGY2dHsEr+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1163/2077] selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
Date: Tue, 21 Jul 2026 17:13:56 +0200
Message-ID: <20260721152620.252600983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 7bbdc459527075c4d0b96133de25a53822397af0 ]

The test currently moves the calling shell ($$) into the target cgroup
before executing write_to_hugetlbfs.  This results in the shell and any
intermediate allocations being charged to the cgroup, introducing noise
and nondeterminism in accounting.  It also requires moving the shell back
to the root cgroup after execution.

Spawn a helper process that joins the target cgroup and exec()'s
write_to_hugetlbfs.  This ensures that only the workload is accounted to
the cgroup and avoids unintended charging from the shell.

The test currently validates both hugetlb usage and memory.current.
However, memory.current includes internal memcg allocations and per-CPU
batched accounting (MEMCG_CHARGE_BATCH), which are not synchronized and
can vary across systems, leading to non-deterministic results.

Since hugetlb memory is accounted via hugetlb.<size>.current,
memory.current is not a reliable indicator here.  Drop memory.current
checks and rely only on hugetlb controller statistics for stable and
accurate validation.

Link: https://lore.kernel.org/fb57491ba83cb0a499c72922e1579b61bee514db.1779296493.git.sayalip@linux.ibm.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/mm/hugetlb_reparenting_test.sh  | 42 ++++++++-----------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index d724b6e45432f8..95f517c3bd167a 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -105,22 +105,17 @@ function assert_with_retry() {
 }
 
 function assert_state() {
-  local expected_a="$1"
-  local expected_a_hugetlb="$2"
-  local expected_b=""
+  local expected_a_hugetlb="$1"
   local expected_b_hugetlb=""
 
-  if [ ! -z ${3:-} ] && [ ! -z ${4:-} ]; then
-    expected_b="$3"
-    expected_b_hugetlb="$4"
+  if [ ! -z ${2:-} ]; then
+    expected_b_hugetlb="$2"
   fi
 
-  assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
   assert_with_retry \
 	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
-  if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
-    assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
+  if [[ -n "$expected_b_hugetlb" ]]; then
     assert_with_retry \
 	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
@@ -154,18 +149,17 @@ write_hugetlbfs() {
   local size="$3"
 
   if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/$cgroup/cgroup.procs
+    cg_file="$CGROUP_ROOT/$cgroup/cgroup.procs"
   else
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.mems
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.cpus
-    echo $$ >"$CGROUP_ROOT/$cgroup/tasks"
-  fi
-  ./write_to_hugetlbfs -p "$path" -s "$size" -m 0 -o
-  if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/cgroup.procs
-  else
-    echo $$ >"$CGROUP_ROOT/tasks"
+    cg_file="$CGROUP_ROOT/$cgroup/tasks"
   fi
+
+  # Spawn helper to join cgroup before exec to ensure correct cgroup accounting
+  bash -c 'echo $$ > "$1"; exec ./write_to_hugetlbfs -p "$2" -s "$3" -m 0 -o' _ \
+	  "$cg_file" "$path" "$size" & pid=$!
+  wait "$pid"
   echo
 }
 
@@ -203,21 +197,21 @@ if [[ ! $cgroup2 ]]; then
   write_hugetlbfs a "$MNT"/test $size
 
   echo Assert memory charged correctly for parent use.
-  assert_state 0 $size 0 0
+  assert_state $size 0
 
   write_hugetlbfs a/b "$MNT"/test2 $size
 
   echo Assert memory charged correctly for child use.
-  assert_state 0 $(($size * 2)) 0 $size
+  assert_state $(($size * 2)) $size
 
   rmdir "$CGROUP_ROOT"/a/b
   echo Assert memory reparent correctly.
-  assert_state 0 $(($size * 2))
+  assert_state $(($size * 2))
 
   rm -rf "$MNT"/*
   umount "$MNT"
   echo Assert memory uncharged correctly.
-  assert_state 0 0
+  assert_state 0
 
   cleanup
 fi
@@ -231,16 +225,16 @@ echo write
 write_hugetlbfs a/b "$MNT"/test2 $size
 
 echo Assert memory charged correctly for child only use.
-assert_state 0 $(($size)) 0 $size
+assert_state $(($size)) $size
 
 rmdir "$CGROUP_ROOT"/a/b
 echo Assert memory reparent correctly.
-assert_state 0 $size
+assert_state $size
 
 rm -rf "$MNT"/*
 umount "$MNT"
 echo Assert memory uncharged correctly.
-assert_state 0 0
+assert_state 0
 
 cleanup
 
-- 
2.53.0



