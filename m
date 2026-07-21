Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9D739A7FD;
	Tue, 21 Jul 2026 19:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660917; cv=none; b=LcqUmN+McMF8XeA3WhKIlTjyGuU4L2mUKCwFzN6ks6j8WN+hN8numDQdJNgdFDm4vZy1bLnPj+0V2eCzga9R46LpiAydsL25awpD3VgqfFSY0EYbiNQ9kqQL+d5HCGBnszQ8UqFxEMUcMUWXCit5soOX+mCL4XdaAvYK1uGswrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660917; c=relaxed/simple;
	bh=xiAVgn7cVYrVxaj9oQtSJKnHfHkVIP/sa1Z0QU144Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4EXzU6ky9RvukFZE/xGtSQOwXIdsnzi7c07EuIu/CXfpl0Zky+LwWSdeQKhNr1pSwPHclY1vYBXZYH2EU3yxcSrOQPyU8P2BoOYOQyTCcKmMt9HLQW5itPmRX3TkM5XmgX0aMF1hLmOr4us/HzdQmllL6uB2fNsUl66o6JQN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybgrkuOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybgrkuOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E291F00A3A;
	Tue, 21 Jul 2026 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660916;
	bh=sFqBvybX01DyWc1sl7Dpo1oy4Ky5u1bjRpbEvREjZC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybgrkuOY3TD/BdcWcGDc4cN3sOfG7daYdwBuQwqHSPZytIPm9eDqqGiC5pV4b7f4L
	 wPZsaAfCXwTRJ8tqzSvqaIxh4Ak/iAM1wtnEJKMRBW6Flt2dAuA9Oz+UnGfOY7qquC
	 byoyQp8y2P/rHHuwkFHdwWe1C0N0gwoYzCs0HfXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1162/2077] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Tue, 21 Jul 2026 17:13:55 +0200
Message-ID: <20260721152620.228566652@linuxfoundation.org>
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

[ Upstream commit 76f9a212a0a93572a28b58d9869e9187c4022342 ]

The hugetlb_reparenting_test.sh script constructs hugetlb cgroup memory
interface file names based on the configured huge page size.  The script
formats the size only in MB units, which causes mismatches on systems
using larger huge pages where the kernel exposes normalized units (e.g.
"1GB" instead of "1024MB").

As a result, the test fails to locate the corresponding cgroup files when
1GB huge pages are configured.

Update the script to detect the huge page size and select the appropriate
unit (MB or GB) so that the constructed paths match the kernel's hugetlb
controller naming.

Also print an explicit "Fail" message when a test failure occurs to
improve result visibility.

Link: https://lore.kernel.org/837ce751965c93f74c95d89587debf1e93281364.1779296493.git.sayalip@linux.ibm.com
Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/mm/hugetlb_reparenting_test.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 11f914831146f4..d724b6e45432f8 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -48,6 +48,13 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+  UNIT="GB"
+  MB_DISPLAY=$((MB / 1024))
+else
+  UNIT="MB"
+  MB_DISPLAY=$MB
+fi
 
 function cleanup() {
   echo cleanup
@@ -88,6 +95,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -108,11 +116,13 @@ function assert_state() {
   fi
 
   assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
-  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
+  assert_with_retry \
+	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
   if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
     assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
-    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
+    assert_with_retry \
+	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
-- 
2.53.0



