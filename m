Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C7B46C4B5;
	Tue, 21 Jul 2026 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660935; cv=none; b=Rlgza9G+O0SMiMaEucdTuGVmqNcZSX+bAR7/GUazO06Ia/C8I+6QVlR9urMU0L94bcVJqDpIq1lX1U3ahg9w900PSH/f+/2jr3sOehjvdgD/AubckLKz7VRiAs0seMjwp61p+DJFIf9Z136qcPitrBtnNDxAOvHBMcV0zuKMg5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660935; c=relaxed/simple;
	bh=SS42SYPfsq8c4EC0zrZfEGy2ZOKmuiKr7UCiVcGnddI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYRx95hQKGAK7nvNSaHki43MPDFtklqaK/EZk1CH0tHAXaJRjreiNhcLHHcTC88k1bd7GpeLLxkLa54OQaSquI1f6aOzbCoTJvOsEtrt/k1pFqeJKAVmZlDqKdm2CUJNn7s82rqyGyOFXf/DUm/FIlkN3CKqK6TpnTwcqbxF1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCTI5xuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCTI5xuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645771F000E9;
	Tue, 21 Jul 2026 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660933;
	bh=3HWkCRY95mcPZd/mu7X3Wmo3AtbkD5OsNM29ncrU9DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCTI5xuMmBshBky1CnWEW0uOvoP/lFml9vBl3yIGv0i4jWxQQidz4F5JQSeEtFRrr
	 0+0kFyPmxbIQg0k1urkiCuxwMb2oWIzP/m5xw0hfx0KkoIUwPUKHMTQHHv9/e4R+R7
	 mPcdxprhH1Bxm6NsUW+nmao6T2HHAN5YW1T4+l3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Li Wang <li.wang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1169/2077] selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Tue, 21 Jul 2026 17:14:02 +0200
Message-ID: <20260721152620.394249102@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 157adc22f01cdd0c0dc1b9e4389ed2377d9b69d3 ]

Currently when running THP and HugeTLB tests, if HAVE_HUGEPAGES is set
run_test() drops caches, compacts memory and runs the test.  But if
HAVE_HUGEPAGES is not set it skips the tests entirely, even if THP tests
have nothing to do with HAVE_HUGEPAGES.

Replace the check if HAVE_HUGEPAGES is set with a check of how much memory
is available.  If there is less than 256 MB of available memory, drop
caches and run compaction and then continue to run a test regardless of
HAVE_HUGEPAGES value.

Link: https://lore.kernel.org/20260511162840.375890-55-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 90c132f8379b ("selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index c17b133a81d248..913a32a47baf85 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -234,19 +234,17 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
-		local skip=0
-
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
-			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+			mem_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
+			mem_Mb=$((mem_kb / 1024))
+
+			if (( $mem_Mb < 256 )); then
 				echo 3 > /proc/sys/vm/drop_caches
 				sleep 2
 				echo 1 > /proc/sys/vm/compact_memory
 				sleep 2
-			else
-				echo "hugepages not supported" | tap_prefix
-				skip=1
 			fi
 		fi
 
@@ -255,12 +253,8 @@ run_test() {
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		if [ "${skip}" != "1" ]; then
-			("$@" 2>&1) | tap_prefix
-			local ret=${PIPESTATUS[0]}
-		else
-			local ret=$ksft_skip
-		fi
+                ("$@" 2>&1) | tap_prefix
+                local ret=${PIPESTATUS[0]}
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
-- 
2.53.0



