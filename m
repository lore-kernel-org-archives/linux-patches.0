Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9964F19645B;
	Thu,  6 Jun 2024 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683028; cv=none; b=C7Ts8mPtYNmKIVAW1Wb0dvLTLEQ5URxmSvQSHFMcHiTTIW3eSl7UMNpkNE3vTLVMrzwnQv7F1XAzIz41xfQDeVHx2fPKx0xuMbDJGMg2/N/5Hvd02k7AobvHSgTe16oFsSBZxaVx8Q4lmt8kJA94Q/C1v0HWssiBxImVcY/73q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683028; c=relaxed/simple;
	bh=w2CUAcucQkaOs+gpG9RBa3qj6W6AxjXuhBOngF6LqHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnlIqap9bYHbJxpCU7iGYHVDRYoN9/O4US5clW7PiCyOPRVnIU3u45Mqef3Xu5IBxFTvw47ozFp+KXXdP+oMyhNa5/xURm+7kK6V6u1JONirnjG8RxJLvjdsIofKaJ+82b+XFVRYygE0IlHOU7ladNXtqT5p18K2YSo42Os5Bmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgtzVW/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgtzVW/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6D8C32781;
	Thu,  6 Jun 2024 14:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683028;
	bh=w2CUAcucQkaOs+gpG9RBa3qj6W6AxjXuhBOngF6LqHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgtzVW/crW3EPVMEk4LUqPRaHj3EXc/SByJKJvt1wjTNX0SKhyIb6mtrA1wquTaJF
	 qRdCLvjQfmBV93iW4OdEyUkjV8IikCK7HItHqsDguLNEKrM6+5hJnH05W+G2csdXB+
	 htZSoeC73p6QtF3wrSWWn7JOn3gvOd+lCNRne0lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 249/374] selftests: forwarding: Convert log_test() to recognize RET values
Date: Thu,  6 Jun 2024 16:03:48 +0200
Message-ID: <20240606131700.158972117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit a923af1ceee744c187d1c08a0d7dc9e8ab7ca482 ]

In a previous patch, the interpretation of RET value was changed to mean
the kselftest framework constant with the test outcome: $ksft_pass,
$ksft_xfail, etc.

Update log_test() to recognize the various possible RET values.

Then have EXIT_STATUS track the RET value of the current test. This differs
subtly from the way RET tracks the value: while for RET we want to
recognize XFAIL as a separate status, for purposes of exit code, we want to
to conflate XFAIL and PASS, because they both communicate non-failure. Thus
add a new helper, ksft_exit_status_merge().

With this log_test_skip() and log_test_xfail() can be reexpressed as thin
wrappers around log_test.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/e5f807cb5476ab795fd14ac74da53a731a9fc432.1711464583.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ea63ac142925 ("selftests/net: use tc rule to filter the na packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 92 ++++++++++++++-----
 tools/testing/selftests/net/lib.sh            |  9 ++
 2 files changed, 77 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 258d2082aa991..99ab42319e3e3 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -400,6 +400,62 @@ check_err_fail()
 	fi
 }
 
+log_test_result()
+{
+	local test_name=$1; shift
+	local opt_str=$1; shift
+	local result=$1; shift
+	local retmsg=$1; shift
+
+	printf "TEST: %-60s  [%s]\n" "$test_name $opt_str" "$result"
+	if [[ $retmsg ]]; then
+		printf "\t%s\n" "$retmsg"
+	fi
+}
+
+pause_on_fail()
+{
+	if [[ $PAUSE_ON_FAIL == yes ]]; then
+		echo "Hit enter to continue, 'q' to quit"
+		read a
+		[[ $a == q ]] && exit 1
+	fi
+}
+
+handle_test_result_pass()
+{
+	local test_name=$1; shift
+	local opt_str=$1; shift
+
+	log_test_result "$test_name" "$opt_str" " OK "
+}
+
+handle_test_result_fail()
+{
+	local test_name=$1; shift
+	local opt_str=$1; shift
+
+	log_test_result "$test_name" "$opt_str" FAIL "$retmsg"
+	pause_on_fail
+}
+
+handle_test_result_xfail()
+{
+	local test_name=$1; shift
+	local opt_str=$1; shift
+
+	log_test_result "$test_name" "$opt_str" XFAIL "$retmsg"
+	pause_on_fail
+}
+
+handle_test_result_skip()
+{
+	local test_name=$1; shift
+	local opt_str=$1; shift
+
+	log_test_result "$test_name" "$opt_str" SKIP "$retmsg"
+}
+
 log_test()
 {
 	local test_name=$1
@@ -409,40 +465,28 @@ log_test()
 		opt_str="($opt_str)"
 	fi
 
-	if [[ $RET -ne 0 ]]; then
-		EXIT_STATUS=1
-		printf "TEST: %-60s  [FAIL]\n" "$test_name $opt_str"
-		if [[ ! -z "$retmsg" ]]; then
-			printf "\t%s\n" "$retmsg"
-		fi
-		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
-			echo "Hit enter to continue, 'q' to quit"
-			read a
-			[ "$a" = "q" ] && exit 1
-		fi
-		return 1
+	if ((RET == ksft_pass)); then
+		handle_test_result_pass "$test_name" "$opt_str"
+	elif ((RET == ksft_xfail)); then
+		handle_test_result_xfail "$test_name" "$opt_str"
+	elif ((RET == ksft_skip)); then
+		handle_test_result_skip "$test_name" "$opt_str"
+	else
+		handle_test_result_fail "$test_name" "$opt_str"
 	fi
 
-	printf "TEST: %-60s  [ OK ]\n" "$test_name $opt_str"
-	return 0
+	EXIT_STATUS=$(ksft_exit_status_merge $EXIT_STATUS $RET)
+	return $RET
 }
 
 log_test_skip()
 {
-	local test_name=$1
-	local opt_str=$2
-
-	printf "TEST: %-60s  [SKIP]\n" "$test_name $opt_str"
-	return 0
+	RET=$ksft_skip retmsg= log_test "$@"
 }
 
 log_test_xfail()
 {
-	local test_name=$1
-	local opt_str=$2
-
-	printf "TEST: %-60s  [XFAIL]\n" "$test_name $opt_str"
-	return 0
+	RET=$ksft_xfail retmsg= log_test "$@"
 }
 
 log_info()
diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index b0bbde83b8461..e826ec1cc9d88 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -44,6 +44,15 @@ ksft_status_merge()
 		$ksft_pass $ksft_xfail $ksft_skip $ksft_fail
 }
 
+ksft_exit_status_merge()
+{
+	local a=$1; shift
+	local b=$1; shift
+
+	__ksft_status_merge "$a" "$b" \
+		$ksft_xfail $ksft_pass $ksft_skip $ksft_fail
+}
+
 busywait()
 {
 	local timeout=$1; shift
-- 
2.43.0



