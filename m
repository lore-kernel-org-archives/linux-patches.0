Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09736245007;
	Tue, 29 Apr 2025 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947290; cv=none; b=ORhS4w9TDZbad3Dt6QLqGCdAdiIH8dsp3y2DOLWOeru/1lfGRVZqNWqzekDMD9JwkIYWzaXk1fOJQ2Myf5UGr3fM92+rRgtcI8N2hWdWV4Fvt6n3zxF5PvZB88u9YLjIoKNYm5nQlWbnC9RVa3Dulv2xnT/3OwEXiD7a5XdBQok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947290; c=relaxed/simple;
	bh=0yVc7Pze9kQQQVQyHMwmvkEjceBCUREtHThijEIOeiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyZqltGwDqjPvELCvdkCNbZGuTOva36rFqERa+DvShwkBkBP7j60X17YcNhg1rN0ufKxwooUWRh1tU+c2lSk1vGP+/UaAJXtmbNI/94sBKr2hydSBq0BM161uLNuZSQI41Y4nLGncRdaT3fNkH1Qm9zqwLVNbCVj8LZkTxjR0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTjXk7Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTjXk7Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F630C4CEE9;
	Tue, 29 Apr 2025 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947289;
	bh=0yVc7Pze9kQQQVQyHMwmvkEjceBCUREtHThijEIOeiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTjXk7YzJ4ECL9HNWmlUJdm9B7Cslq3QTeYPKj8E0/6+0SYpWnGoN0yeash1aIPv8
	 Y57LpIDzFLWC/3ofRCIzsVoHU+Bpk3REC0ZfgmgngA6MiwtnAk6ZiENiFQrvP3UkF9
	 nwJSLKzvT3SNshBDYwLfjs98Y5+hTd/iSeqqPn/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Mina Almasry <almasrymina@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/286] selftests/mm: generate a temporary mountpoint for cgroup filesystem
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161117.236326477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9c02223e2d9df5cb37c51aedb78f3960294e09b5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  | 4 ++--
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index 28192ec98498f..c44226b4e0bfb 100644
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -24,7 +24,7 @@ fi
 if [[ $cgroup2 ]]; then
   cgroup_path=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup2 none $cgroup_path
     do_umount=1
   fi
@@ -32,7 +32,7 @@ if [[ $cgroup2 ]]; then
 else
   cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
-    cgroup_path=/dev/cgroup/memory
+    cgroup_path=$(mktemp -d)
     mount -t cgroup memory,hugetlb $cgroup_path
     do_umount=1
   fi
diff --git a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
index c665b16f1e370..a4123632942dd 100644
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -19,7 +19,7 @@ fi
 if [[ $cgroup2 ]]; then
   CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
-    CGROUP_ROOT=/dev/cgroup/memory
+    CGROUP_ROOT=$(mktemp -d)
     mount -t cgroup2 none $CGROUP_ROOT
     do_umount=1
   fi
-- 
2.39.5



