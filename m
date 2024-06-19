Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F30912FB27;
	Wed, 19 Jun 2024 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802925; cv=none; b=rX34pkXqH9DjrE8FpWdSKqrXyzDgPksWj3WY3qSeHca3ZhJIfgHzeFXsQKWVCIrTP3tS2v0Co3iVVAwj1I9Hs7KJLQMnUEZENV2l+EhDIPXSsqyRr7Y2h0O7Z6M1kSIaBvntU+qZBdPeWkMxHl2ePIV1/DVD/mpdwJ3vL/5e2CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802925; c=relaxed/simple;
	bh=Xj/73lCK0toh16hmKmG9ObXL2J6QN/L1N5nlHbe7BrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv9LlUeHuiNNwYHnSl7hu21nv9afFWnpIEUI0sQYKfakN/30w0IStST1biaiHc8iYJy5XRedJxfABDFmY56dTIy2/iTb4H7Z8S04RZlGNmw0uCT5TYXprcEFIfwXmohH83Qi4q6kQ5Kzi007fZNjleL3mk6N5llJFDLNAIK4GOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv9b/ZuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv9b/ZuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B87C2BBFC;
	Wed, 19 Jun 2024 13:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802925;
	bh=Xj/73lCK0toh16hmKmG9ObXL2J6QN/L1N5nlHbe7BrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv9b/ZuVJ/mJiS05SvwFDOGhzKWMHR+33s6+1ldmlaHg3mCzuFPU9UjG5G8AB6IwC
	 yKDplFIrb6xzFGNtyOIuMtd+PR4go6qgcFcCjydvhT93+4aTcwc8z76ImW6M0Ij8v3
	 D2cMtHdcbYzgIj/gHlTY2UogUoHc3BjgwaDS0jy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/281] selftests/mm: ksft_exit functions do not return
Date: Wed, 19 Jun 2024 14:53:55 +0200
Message-ID: <20240619125612.765858086@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 69e545edbe8b17c26aa06ef7e430d0be7f08d876 ]

After commit f7d5bcd35d42 ("selftests: kselftest: Mark functions that
unconditionally call exit() as __noreturn"), ksft_exit_...() functions
are marked as __noreturn, which means the return type should not be
'int' but 'void' because they are not returning anything (and never were
since exit() has always been called).

To facilitate updating the return type of these functions, remove
'return' before the calls to ksft_exit_...(), as __noreturn prevents the
compiler from warning that a caller of the ksft_exit functions does not
return a value because the program will terminate upon calling these
functions.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: fb9293b6b015 ("selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c      | 6 +++---
 tools/testing/selftests/mm/cow.c                  | 2 +-
 tools/testing/selftests/mm/gup_longterm.c         | 2 +-
 tools/testing/selftests/mm/gup_test.c             | 4 ++--
 tools/testing/selftests/mm/ksm_functional_tests.c | 2 +-
 tools/testing/selftests/mm/madv_populate.c        | 2 +-
 tools/testing/selftests/mm/mkdirty.c              | 2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c        | 4 ++--
 tools/testing/selftests/mm/soft-dirty.c           | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 326a893647bab..5e9bd1da9370c 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -185,7 +185,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 
 	if (prereq() || geteuid())
-		return ksft_exit_skip("Prerequisites unsatisfied\n");
+		ksft_exit_skip("Prerequisites unsatisfied\n");
 
 	ksft_set_plan(1);
 
@@ -233,7 +233,7 @@ int main(int argc, char **argv)
 	}
 
 	if (check_compaction(mem_free, hugepage_size) == 0)
-		return ksft_exit_pass();
+		ksft_exit_pass();
 
-	return ksft_exit_fail();
+	ksft_exit_fail();
 }
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 363bf5f801be5..fe078d6e18064 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1779,5 +1779,5 @@ int main(int argc, char **argv)
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
 				   err, ksft_test_num());
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index ad168d35b23b7..d7eaca5bbe9b1 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -456,5 +456,5 @@ int main(int argc, char **argv)
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
 				   err, ksft_test_num());
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 7821cf45c323b..bdeaac67ff9aa 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -229,7 +229,7 @@ int main(int argc, char **argv)
 			break;
 		}
 		ksft_test_result_skip("Please run this test as root\n");
-		return ksft_exit_pass();
+		ksft_exit_pass();
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
@@ -268,5 +268,5 @@ int main(int argc, char **argv)
 
 	free(tid);
 
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index d615767e396be..508287560c455 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -646,5 +646,5 @@ int main(int argc, char **argv)
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
 				   err, ksft_test_num());
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 17bcb07f19f34..ef7d911da13e0 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -307,5 +307,5 @@ int main(int argc, char **argv)
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
 				   err, ksft_test_num());
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/mkdirty.c b/tools/testing/selftests/mm/mkdirty.c
index 301abb99e027e..b8a7efe9204ea 100644
--- a/tools/testing/selftests/mm/mkdirty.c
+++ b/tools/testing/selftests/mm/mkdirty.c
@@ -375,5 +375,5 @@ int main(void)
 	if (err)
 		ksft_exit_fail_msg("%d out of %d tests failed\n",
 				   err, ksft_test_num());
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index d59517ed3d48b..2d785aca72a5c 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1484,7 +1484,7 @@ int main(int argc, char *argv[])
 	ksft_print_header();
 
 	if (init_uffd())
-		return ksft_exit_pass();
+		ksft_exit_pass();
 
 	ksft_set_plan(115);
 
@@ -1660,5 +1660,5 @@ int main(int argc, char *argv[])
 	userfaultfd_tests();
 
 	close(pagemap_fd);
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 7dbfa53d93a05..d9dbf879748b2 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -209,5 +209,5 @@ int main(int argc, char **argv)
 
 	close(pagemap_fd);
 
-	return ksft_exit_pass();
+	ksft_exit_pass();
 }
-- 
2.43.0



