Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52519E966;
	Wed, 23 Apr 2025 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421091; cv=none; b=QQiIx/JVJkqwCBi8LBuP3pPfGy/IOwZEdtDK8Xei/dCN0Yp7/oyL5lqlqijTLEg8elSPqhKLmOMgrx5lYEF/207/PTS57K6FWwqHvbCRs+O2Nz1wWsZz1/bWoSiONXZw79hRpnBM4TUEgxpH9FUFC+ArIpibJGl5L7nRLamxmls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421091; c=relaxed/simple;
	bh=y3L0iDXdc1Yz0P2d/jW9n0mKkw+vgD7SHC3fgsQNkYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/BL5iOGAIsWQQ2Iyl1FP9HXBLl4vEIDE8cLiqpt/CChZzpk3jTT6xycsEbGtteRyBSGxSuY5H4ojFDUtVLqxJOiIpS52DiFfzRAU7eRGQNVuODkgZAlVUkdKyWKSSp1u1AsaFZ7baNzaoaOhjQ/kEHJyDTuhEDYPGFP0vQFBZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZYn9l1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZYn9l1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E16AC4CEE2;
	Wed, 23 Apr 2025 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421091;
	bh=y3L0iDXdc1Yz0P2d/jW9n0mKkw+vgD7SHC3fgsQNkYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZYn9l1YhvFX6kHncdRSLqHt3EipCjDk2jTeeiIoAtCFLUFPXEXEXJKq3dTpvKqTQ
	 IvJyGS81C0hjkGU6HV4xKYhJ7HnOlyrdIVnleOYaCcX0fFZUqtM3f0J2sNdHBC84nO
	 PxyFatYOoVAs0F2uewZIJ3PZlzLCjAvBvL5nrBgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Mina Almasry <almasrymina@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 151/241] selftests/mm: generate a temporary mountpoint for cgroup filesystem
Date: Wed, 23 Apr 2025 16:43:35 +0200
Message-ID: <20250423142626.713189737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 9c02223e2d9df5cb37c51aedb78f3960294e09b5 upstream.

Currently if the filesystem for the cgroups version it wants to use is not
mounted charge_reserved_hugetlb.sh and hugetlb_reparenting_test.sh tests
will attempt to mount it on the hard coded path /dev/cgroup/memory,
deleting that directory when the test finishes.  This will fail if there
is not a preexisting directory at that path, and since the directory is
deleted subsequent runs of the test will fail.  Instead of relying on this
hard coded directory name use mktemp to generate a temporary directory to
use as a mountpoint, fixing both the assumption and the disruption caused
by deleting a preexisting directory.

This means that if the relevant cgroup filesystem is not already mounted
then we rely on having coreutils (which provides mktemp) installed.  I
suspect that many current users are relying on having things automounted
by default, and given that the script relies on bash it's probably not an
unreasonable requirement.

Link: https://lkml.kernel.org/r/20250404-kselftest-mm-cgroup2-detection-v1-1-3dba6d32ba8c@kernel.org
Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |    4 ++--
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -29,7 +29,7 @@ fi
 if [[ $cgroup2 ]]; then
   cgroup_path=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup2 none $cgroup_path
     do_umount=1
   fi
@@ -37,7 +37,7 @@ if [[ $cgroup2 ]]; then
 else
   cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup memory,hugetlb $cgroup_path
     do_umount=1
   fi
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -23,7 +23,7 @@ fi
 if [[ $cgroup2 ]]; then
   CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
-    CGROUP_ROOT=/dev/cgroup/memory
+    CGROUP_ROOT=$(mktemp -d)
     mount -t cgroup2 none $CGROUP_ROOT
     do_umount=1
   fi


