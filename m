Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD5E471263;
	Tue, 21 Jul 2026 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657662; cv=none; b=FqjseoT01oXYjB+LO/q0pmII2krwecv2lsbCWg96KMAOFbnJr9bt41W/vVAZKTvET/CgDtyW6EAln/HtTfcrY7GO2OR3nd5GfDrLz6Yzyh4+fr7AG0OUcIoxft7IGnhoIj96MXHqGwQX6WPLdIPlw9UH2QPaPmuetEjP/dpT6Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657662; c=relaxed/simple;
	bh=tVTYXrUdKQ5ucEDNFis/AXruy0Ln8DMtL4rUb+zrKro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dltHf1lsHZUdIN8e1JWFug9UQ9gmwLMKv14ABx5ZFEKY2V2QMHP2NxgAXacWm0yd0Nzh5I9MdKzgaWEPQm2v+K8sRA7YQKT6Dm8T1fM1/+1HaIraSLSpfrpACDSV1HNZ0vECRH+w0Gh5VwiS8vmxrjoZSGHyAZlYXPv48aZPfiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOLM8w8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOLM8w8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71BF1F000E9;
	Tue, 21 Jul 2026 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657661;
	bh=UUVc9RzwbApTf/eD+V4fii5koVbVpBfZmigmibzxF7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOLM8w8qiB+mRdtRoK8ZqLK5fwwotZBzs8x1Dvq/iYDhEWpiP7flfg3IsMQSASFsF
	 adYhQLipb9OE6iHcm6JBFjAuIPG2Lck1pfdYMfylxdCoSfqfbkRdnkDQI/mapERYdW
	 GKXlfR8N7WPOT2RcrfTHuxc8w5/jGRfK2LLlIrCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0850/1611] selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
Date: Tue, 21 Jul 2026 17:16:06 +0200
Message-ID: <20260721152534.505145026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit a3f66e9b6e4dad38444656ffc28c28c33a4d4e1f ]

Patch series "selftests/mm: fix failures and robustness improvements", v7.

Powerpc systems with a 64K base page size exposed several issues while
running mm selftests. Some tests assume specific hugetlb configurations,
use incorrect interfaces, or fail instead of skipping when the required
kernel features are not available.

This series fixes these issues and improves test robustness.

This patch (of 13):

cleanup() resets nr_hugepages to 0 on every invocation, while the test
reconfigures it again in the next iteration.  This leads to repeated
allocation and freeing of large numbers of hugepages, especially when the
original value is high.

Additionally, with set -e, failures in earlier cleanup steps (e.g., rmdir
or umount returning EBUSY while background activity is still ongoing) can
cause the script to exit before restoring the original value, leaving the
system in a modified state.

Introduce a trap on EXIT, INT, and TERM to restore the original
nr_hugepages value once at script termination.  This avoids unnecessary
allocation churn and ensures the original value is reliably restored on
all exit paths.

Link: https://lore.kernel.org/cover.1779296493.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/5b8fbb29cd6ceffe6752e0af104f60cec072aa10.1779296493.git.sayalip@linux.ibm.com
Fixes: 7d695b1c3695 ("selftests/mm: save and restore nr_hugepages value")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
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
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index fa6713892d82d8..2b24d703e7ada9 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -12,6 +12,7 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -65,7 +66,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -585,4 +585,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.53.0



