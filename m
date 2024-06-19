Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B7DAD58;
	Wed, 19 Jun 2024 13:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802957; cv=none; b=bH7k0YUJJCxJ9RrfuK0r/rfy8+/JfJ7P0f8eeWFrIB//vP3JqyTJaoLyao6hZqLZx9TzhpiTsfMI/0LPkvrbpE2CP9mWz9tHJ25xROj2tsLWVqu1I17plmQZ9DlId71PJ6I80vjWe5eM3uAGfJ3fIpB5+tFFmrd0kpeCLPvIUXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802957; c=relaxed/simple;
	bh=ZzfasRV7K5MBdxZ2IYDttpCN25YFF4BIaCPqV/DX2Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndykDAoUWPLAlxvIurCD8WmDWJs2ZrD9xh4djg91cHg5jqQ6XJCnPl0lXXwmduvA20qOcu16UJy6Tfklyaz1Qqzk6eUodJByA1H31EWsj8/gAKLAieCBV1KGozgua6qIFsLbYQ524wHMZNX/mBn/h41jGnpu0FSI7+oF6XZRQp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7jZ392J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7jZ392J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF82AC2BBFC;
	Wed, 19 Jun 2024 13:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802957;
	bh=ZzfasRV7K5MBdxZ2IYDttpCN25YFF4BIaCPqV/DX2Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7jZ392JPNcWouliq24H8a6WeOPYwVwbONjOhKSRSezn8iRJPlBap+uajVPtp/myg
	 25Osq+xG8KQdHxdH/CW4DHL9HYxXxoEgmEOO9gBn6EU1ODGPVFd3kjHMgznVbYzB9g
	 vzL2rcOgYECPuw/BkX8xbXp4na4JzHh0QV+prAEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Sri Jayaramappa <sjayaram@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 077/281] selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation
Date: Wed, 19 Jun 2024 14:53:56 +0200
Message-ID: <20240619125612.803842285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit fb9293b6b0156fbf6ab97a1625d99a29c36d9f0c ]

Reset nr_hugepages to zero before the start of the test.

If a non-zero number of hugepages is already set before the start of the
test, the following problems arise:

 - The probability of the test getting OOM-killed increases.  Proof:
   The test wants to run on 80% of available memory to prevent OOM-killing
   (see original code comments).  Let the value of mem_free at the start
   of the test, when nr_hugepages = 0, be x.  In the other case, when
   nr_hugepages > 0, let the memory consumed by hugepages be y.  In the
   former case, the test operates on 0.8 * x of memory.  In the latter,
   the test operates on 0.8 * (x - y) of memory, with y already filled,
   hence, memory consumed is y + 0.8 * (x - y) = 0.8 * x + 0.2 * y > 0.8 *
   x.  Q.E.D

 - The probability of a bogus test success increases.  Proof: Let the
   memory consumed by hugepages be greater than 25% of x, with x and y
   defined as above.  The definition of compaction_index is c_index = (x -
   y)/z where z is the memory consumed by hugepages after trying to
   increase them again.  In check_compaction(), we set the number of
   hugepages to zero, and then increase them back; the probability that
   they will be set back to consume at least y amount of memory again is
   very high (since there is not much delay between the two attempts of
   changing nr_hugepages).  Hence, z >= y > (x/4) (by the 25% assumption).
   Therefore, c_index = (x - y)/z <= (x - y)/y = x/y - 1 < 4 - 1 = 3
   hence, c_index can always be forced to be less than 3, thereby the test
   succeeding always.  Q.E.D

Link: https://lkml.kernel.org/r/20240521074358.675031-4-dev.jain@arm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sri Jayaramappa <sjayaram@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 71 ++++++++++++++------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 5e9bd1da9370c..e140558e6f53f 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -82,13 +82,16 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
+		     unsigned long initial_nr_hugepages)
 {
 	unsigned long nr_hugepages_ul;
 	int fd, ret = -1;
 	int compaction_index = 0;
-	char initial_nr_hugepages[20] = {0};
 	char nr_hugepages[20] = {0};
+	char init_nr_hugepages[20] = {0};
+
+	sprintf(init_nr_hugepages, "%lu", initial_nr_hugepages);
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
@@ -102,23 +105,6 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 		goto out;
 	}
 
-	if (read(fd, initial_nr_hugepages, sizeof(initial_nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	/* Start with the initial condition of 0 huge pages*/
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
 	/* Request a large number of huge pages. The Kernel will allocate
 	   as much as it can */
 	if (write(fd, "100000", (6*sizeof(char))) != (6*sizeof(char))) {
@@ -146,8 +132,8 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 
 	lseek(fd, 0, SEEK_SET);
 
-	if (write(fd, initial_nr_hugepages, strlen(initial_nr_hugepages))
-	    != strlen(initial_nr_hugepages)) {
+	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
+	    != strlen(init_nr_hugepages)) {
 		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
 			       strerror(errno));
 		goto close_fd;
@@ -171,6 +157,41 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 	return ret;
 }
 
+int set_zero_hugepages(unsigned long *initial_nr_hugepages)
+{
+	int fd, ret = -1;
+	char nr_hugepages[20] = {0};
+
+	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto out;
+	}
+	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
+		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto close_fd;
+	}
+
+	lseek(fd, 0, SEEK_SET);
+
+	/* Start with the initial condition of 0 huge pages */
+	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
+		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
+			       strerror(errno));
+		goto close_fd;
+	}
+
+	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
+	ret = 0;
+
+ close_fd:
+	close(fd);
+
+ out:
+	return ret;
+}
 
 int main(int argc, char **argv)
 {
@@ -181,6 +202,7 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
+	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
@@ -189,6 +211,10 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
+	/* Start the test without hugepages reducing mem_free */
+	if (set_zero_hugepages(&initial_nr_hugepages))
+		ksft_exit_fail();
+
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
 	if (setrlimit(RLIMIT_MEMLOCK, &lim))
@@ -232,7 +258,8 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size) == 0)
+	if (check_compaction(mem_free, hugepage_size,
+			     initial_nr_hugepages) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
-- 
2.43.0



