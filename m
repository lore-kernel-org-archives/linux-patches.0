Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4EC1DFE00;
	Tue,  8 Oct 2024 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392160; cv=none; b=tsPAv0pPoNBvGTMoHSgsnDq201azMalZx+nIy6oFJ3Q3h8Te5V1q7qK7y9/RDLEXIWrMcDhmGSjlIDZxdEeKHX67f+9Rfgop1MBlMhTMCTVFeOPc5efnMPJP5MjwlZByE5EDcazymnhAshtJYMzHKzBRr1063CtEhrPp0wGC0Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392160; c=relaxed/simple;
	bh=Q1qdwYFAV0lruSv8FDt+QzgLVjn+IGyiHmFjMbKPrCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESE747AeoOCh77CamIPv5VpzvU9a/ankxdNjDyOeyCVXxy1QxyCFVmQSF4jNUFDTkN3zoMmzWy2Ofm4kkn4MC5JN64OYhBggwLBimMt8aRL9y8CNnPSXdGpTrTurR5Kjc1JduZIXrbhmCH8zgkcp6RK0XiGpCNe+V7ysxy5TTao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un+onaxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un+onaxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F0C4CECC;
	Tue,  8 Oct 2024 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392160;
	bh=Q1qdwYFAV0lruSv8FDt+QzgLVjn+IGyiHmFjMbKPrCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un+onaxMm4cjlk7UQ5PuAN2JYgtMfD2TQH++hBvKNrUoS8CeM+8ye0bZ14VAQl1uo
	 gjrgXVlyvaoROyAkpfCgdxgu6kT2ffQSQbCQzKdejSPkZSUFcq9D9nFd9bk2ZpvuPT
	 XJr7+l1qXvlimrstCnJnfZz9rseLEAdy5r9ShLDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Mario Casquero <mcasquer@redhat.com>,
	Mina Almasry <almasrymina@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 333/558] selftests/mm: fix charge_reserved_hugetlb.sh test
Date: Tue,  8 Oct 2024 14:06:03 +0200
Message-ID: <20241008115715.408096164@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit c41a701d18efe6b8aa402efab16edbaba50c9548 ]

Currently, running the charge_reserved_hugetlb.sh selftest we can
sometimes observe something like:

  $ ./charge_reserved_hugetlb.sh -cgroup-v2
  ...
  write_result is 0
  After write:
  hugetlb_usage=0
  reserved_usage=10485760
  killing write_to_hugetlbfs
  Received 2.
  Deleting the memory
  Detach failure: Invalid argument
  umount: /mnt/huge: target is busy.

Both cases are issues in the test.

While the unmount error seems to be racy, it will make the test fail:
	$ ./run_vmtests.sh -t hugetlb
	...
	# [FAIL]
	not ok 10 charge_reserved_hugetlb.sh -cgroup-v2 # exit=32

The issue is that we are not waiting for the write_to_hugetlbfs process to
quit.  So it might still have a hugetlbfs file open, about which umount is
not happy.  Fix that by making "killall" wait for the process to quit.

The other error ("Detach failure: Invalid argument") does not seem to
result in a test error, but is misleading.  Turns out write_to_hugetlbfs.c
unconditionally tries to cleanup using shmdt(), even when we only
mmap()'ed a hugetlb file.  Even worse, shmaddr is never even set for the
SHM case.  Fix that as well.

With this change it seems to work as expected.

Link: https://lkml.kernel.org/r/20240821123115.2068812-1-david@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mario Casquero <mcasquer@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Tested-by: Mario Casquero <mcasquer@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   |  2 +-
 .../testing/selftests/mm/write_to_hugetlbfs.c | 21 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index d680c00d2853a..67df7b47087f0 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -254,7 +254,7 @@ function cleanup_hugetlb_memory() {
   local cgroup="$1"
   if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
     echo killing write_to_hugetlbfs
-    killall -2 write_to_hugetlbfs
+    killall -2 --wait write_to_hugetlbfs
     wait_for_hugetlb_memory_to_get_depleted $cgroup
   fi
   set -e
diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
index 6a2caba19ee1d..1289d311efd70 100644
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -28,7 +28,7 @@ enum method {
 
 /* Global variables. */
 static const char *self;
-static char *shmaddr;
+static int *shmaddr;
 static int shmid;
 
 /*
@@ -47,15 +47,17 @@ void sig_handler(int signo)
 {
 	printf("Received %d.\n", signo);
 	if (signo == SIGINT) {
-		printf("Deleting the memory\n");
-		if (shmdt((const void *)shmaddr) != 0) {
-			perror("Detach failure");
+		if (shmaddr) {
+			printf("Deleting the memory\n");
+			if (shmdt((const void *)shmaddr) != 0) {
+				perror("Detach failure");
+				shmctl(shmid, IPC_RMID, NULL);
+				exit(4);
+			}
+
 			shmctl(shmid, IPC_RMID, NULL);
-			exit(4);
+			printf("Done deleting the memory\n");
 		}
-
-		shmctl(shmid, IPC_RMID, NULL);
-		printf("Done deleting the memory\n");
 	}
 	exit(2);
 }
@@ -211,7 +213,8 @@ int main(int argc, char **argv)
 			shmctl(shmid, IPC_RMID, NULL);
 			exit(2);
 		}
-		printf("shmaddr: %p\n", ptr);
+		shmaddr = ptr;
+		printf("shmaddr: %p\n", shmaddr);
 
 		break;
 	default:
-- 
2.43.0



