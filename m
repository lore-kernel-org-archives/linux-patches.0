Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D3471263;
	Tue, 21 Jul 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657664; cv=none; b=mMfNjKpjBn4B5G17EkbAR3A0wYkVJYWCud5uJLGLVR7PS7shPIPLcBGCjRTVNPV55gLiIIKnQw0J8Hi7+65PBLSMjGppl2K4kcbml3il87RqYVVRvHyx+nMCEpR3EDIkaf9CBsJQ/ia5/TRzlOehfOclPg9ITgxIAzih7gmaWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657664; c=relaxed/simple;
	bh=70gABVxj+LFwi7Jt3gFsQ7MLruJEBz8jpgS8smiZsvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOYOFvV4TeKG8mIPPMQL0yJ1UTrqph1WkkTOmjE7bQRAmRTW21lxGZ6A49xB1pITAkS2vK0dpJN50l9S5cKvnAc2qzGVE/8HbHYx6feci04iD0Nfn7p9i6hKEGu1RyC4RMPI9GvW8HiuYq1JkwC6nVeVemXK8Nnt6W0ssqtBU04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9AwGxOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9AwGxOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F09D1F000E9;
	Tue, 21 Jul 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657663;
	bh=lTTR8K+wNbkrrpXQdxj24fc32Is3CmmqIqCQhnKky3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9AwGxOjmuvchV7FBAyZwxCmUwN0ocaWoy+SmzWRdA+vZ/pqfBJi/OBc+aTfmzIQM
	 5i00iynysDQHzWWwUWkXmTc0u+Q+Ud96+Nb4VV7K3SLCUpCcAG5dAGx6WFvSzLmRip
	 RUdzp0zpIccmWlE2Nk3JxvrN7sRJDJTOdX5iGfu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Zi Yan <ziy@nvidia.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0851/1611] selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
Date: Tue, 21 Jul 2026 17:16:07 +0200
Message-ID: <20260721152534.530855812@linuxfoundation.org>
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

[ Upstream commit 7f9c0920ff3debae3cb4d60260e3daf56ab68395 ]

The test modifies nr_hugepages during execution and restores it from
cleanup() and again reconfigure it setup, which is invoked multiple times
across test flow.  This can lead to repeated allocation/freeing of
hugepages.

With set -e, failures in cleanup (e.g., rmdir/umount) can also cause early
exit before restoring the original value at the end.

Move restoration of the original nr_hugepages value to a trap handler
registered for EXIT, INT, and TERM signals so it is always restored on all
exit paths.  This also avoids unnecessary allocation churn across repeated
cleanup/setup cycles.

Link: https://lore.kernel.org/29db637c3c6ba6c168f6b33f59f059a0b39c35c8.1779296493.git.sayalip@linux.ibm.com
Fixes: 585a9145886a ("selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 0dd31892ff6794..11f914831146f4 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -12,6 +12,8 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
+
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -56,7 +58,6 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
@@ -240,4 +241,3 @@ if [[ $do_umount ]]; then
   rm -rf $CGROUP_ROOT
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.53.0



