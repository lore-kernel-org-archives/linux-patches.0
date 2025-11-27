Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD3F29BD89;
	Thu, 27 Nov 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255275; cv=none; b=Wy3xYs5sZ0rsChHcUwDeO5hm+6x8Jrx8y7RmItNgLqvXSTaL0WXn/KNBpoW1LjiDI12yHrfNHGi3oTDXErlvn1s/Ul6QZhJAItrV9Fu92GaHOavJCWFd2nYchoZqwPTacn+o11r5f3gtdJ4/4hxLxkpqV3WDgO0CqOdi5OrZyQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255275; c=relaxed/simple;
	bh=hUdCD70F6GEE14GTcHqqvqsCcOmyW2jMKCfIn6ceNGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7Luu9MgJJWxRvQaYE2zekFN+/FqDvykRJl2Pdm0J6zWt4asd89abX84xTV6pyFdb4tg+olV6ktEXyR8aNSzvjpFeCS9Nv2MCLd5okoHsqJUWTdBPezIUSEKS2kn2xMsdSS075tJ6EVXa+VlwCYX5UKjJkFNFCMhVQZsNrsHE34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2m3VCpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2m3VCpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2455AC4CEF8;
	Thu, 27 Nov 2025 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255275;
	bh=hUdCD70F6GEE14GTcHqqvqsCcOmyW2jMKCfIn6ceNGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2m3VCpXjbVYDO2bUtk54Uti0tP5vUfavqCM7b4jHgwpTeuo49JRf4fy1vnZ/J4Mc
	 g838tZ7cH3Jq34zHGbzwke6kJq+sV7TydH0L1vbHEXVLXWQebNbS2IMhvshNSwk832
	 G8Flmv1h846NbxPmSLXS3szOiHTRVO/Kx8MTRKI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/112] selftests: net: lib: Do not overwrite error messages
Date: Thu, 27 Nov 2025 15:46:11 +0100
Message-ID: <20251127144035.367286075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit bed22c7b90af732978715a1789bca1c3cfa245a6 ]

ret_set_ksft_status() calls ksft_status_merge() with the current return
status and the last one. It treats a non-zero return code from
ksft_status_merge() as an indication that the return status was
overwritten by the last one and therefore overwrites the return message
with the last one.

Currently, ksft_status_merge() returns a non-zero return code even if
the current return status and the last one are equal. This results in
return messages being overwritten which is counter-productive since we
are more interested in the first failure message and not the last one.

Fix by changing ksft_status_merge() to only return a non-zero return
code if the current return status was actually changed.

Add a test case which checks that the first error message is not
overwritten.

Before:

 # ./lib_sh_test.sh
 [...]
 TEST: RET tfail2 tfail -> fail                                      [FAIL]
        retmsg=tfail expected tfail2
 [...]
 # echo $?
 1

After:

 # ./lib_sh_test.sh
 [...]
 TEST: RET tfail2 tfail -> fail                                      [ OK ]
 [...]
 # echo $?
 0

Fixes: 596c8819cb78 ("selftests: forwarding: Have RET track kselftest framework constants")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251116081029.69112-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib_sh_test.sh | 7 +++++++
 tools/testing/selftests/net/lib.sh                    | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib_sh_test.sh b/tools/testing/selftests/net/forwarding/lib_sh_test.sh
index ff2accccaf4d4..b4eda6c6199ed 100755
--- a/tools/testing/selftests/net/forwarding/lib_sh_test.sh
+++ b/tools/testing/selftests/net/forwarding/lib_sh_test.sh
@@ -30,6 +30,11 @@ tfail()
 	do_test "tfail" false
 }
 
+tfail2()
+{
+	do_test "tfail2" false
+}
+
 txfail()
 {
 	FAIL_TO_XFAIL=yes do_test "txfail" false
@@ -132,6 +137,8 @@ test_ret()
 	ret_subtest $ksft_fail "tfail" txfail tfail
 
 	ret_subtest $ksft_xfail "txfail" txfail txfail
+
+	ret_subtest $ksft_fail "tfail2" tfail2 tfail
 }
 
 exit_status_tests_run()
diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index bb4d2f8d50d67..501615d285300 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -40,7 +40,7 @@ __ksft_status_merge()
 		weights[$i]=$((weight++))
 	done
 
-	if [[ ${weights[$a]} > ${weights[$b]} ]]; then
+	if [[ ${weights[$a]} -ge ${weights[$b]} ]]; then
 		echo "$a"
 		return 0
 	else
-- 
2.51.0



