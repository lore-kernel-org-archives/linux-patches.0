Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5751C57B1;
	Tue, 15 Oct 2024 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993777; cv=none; b=Q8avqFvRpiJUCJS7PByrb2CP66sWgf5x0sTjktxDEMMaUozAanrSGu7Pw49OMwzZDNA9CaMsRlyTDDuElYSZ/Jhos7G4Y1GTcSWWFrWH1TcbeOlFkBevHPOkJ5pBusxjIc1bRY+w9FkjPT0K853Q+chxXhA7y9zHk+Nh9F+i9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993777; c=relaxed/simple;
	bh=NqLZZmAG6PbRREanTgAkI3b4o9mYcC28rlPHKBjlefE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0okWYizkLH6o/OdSbllgR9BvfsVFE+HPrCNfZ7ff+LXq2/xjRd5NJZRAUj2bK9yWaZkIDdsZIX/Wh1+O7S1dqNstpKq3uxKVmUIFVl/l5PzvbXU2AGtZslHWSpsmLCH2eP17e1b08izQ0bGWodkCb9ybnylt/iBmtttVh/YZFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhYhxx7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhYhxx7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71E2C4CEC6;
	Tue, 15 Oct 2024 12:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993777;
	bh=NqLZZmAG6PbRREanTgAkI3b4o9mYcC28rlPHKBjlefE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhYhxx7JXOEi2wuJHFz94NGUXDukR2iwsNVJoHYtdCRKQe0ftS7isWl4yqVuhf0rD
	 xKlN9mjmGwkaYOiXC1wwACZJQVaTfElHmO9FZFd5yPqakvP/mSjIf15spnIfWlVm52
	 K9CpQEremOfFRJZBxkKgf4lx5Oe4NZuOnpU3zzrg=
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
Subject: [PATCH 5.15 485/691] selftests/mm: fix charge_reserved_hugetlb.sh test
Date: Tue, 15 Oct 2024 13:27:13 +0200
Message-ID: <20241015112459.589030644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 .../selftests/vm/charge_reserved_hugetlb.sh   |  2 +-
 .../testing/selftests/vm/write_to_hugetlbfs.c | 21 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index e14bdd4455f2d..8e00276b4e69b 100644
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -252,7 +252,7 @@ function cleanup_hugetlb_memory() {
   local cgroup="$1"
   if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
     echo killing write_to_hugetlbfs
-    killall -2 write_to_hugetlbfs
+    killall -2 --wait write_to_hugetlbfs
     wait_for_hugetlb_memory_to_get_depleted $cgroup
   fi
   set -e
diff --git a/tools/testing/selftests/vm/write_to_hugetlbfs.c b/tools/testing/selftests/vm/write_to_hugetlbfs.c
index 6a2caba19ee1d..1289d311efd70 100644
--- a/tools/testing/selftests/vm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/vm/write_to_hugetlbfs.c
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



