Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247CD1A2579;
	Thu,  6 Jun 2024 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683766; cv=none; b=R4Ju+5yK0AlreRfI9KS5lVHHOpUixFPIdfJXCPljEyYR1FusNu30jpJsWFPvDe8i+byJzitehfX9FOWnMvUguT3+KzXseCkrqo2nVPbe0C0nfjOe9XVGT1TR7Bfuz6+36r0YiVAgNlLYc9yv14RywadLEPuNFNeXrjI+NYKMXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683766; c=relaxed/simple;
	bh=Fy9wMyh9LsBSaKRmdlQSar4iSmQSWqZv14NbJ9ItOEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxCK0pk+ZZIF8smPEqoSsj2yYZ8bKBJvAUcJiFLyDijqDRmOn3ByplFlaInJ08pQfhYKwjuFIbmfJgPUVgoUUdYJUCQ38P4eNpDai+38cEUlOlXNJk4k3le5STUTuW9QPYxEgv24jAyGswRjzv/GK9+TBNH8aXJYIxsRg9C3Dv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1wXDKO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1wXDKO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC645C2BD10;
	Thu,  6 Jun 2024 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683765;
	bh=Fy9wMyh9LsBSaKRmdlQSar4iSmQSWqZv14NbJ9ItOEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1wXDKO6qPHZVav/tRPKuHenAQPasvmW9iVbImeCvIBQtBxHfxIMpMmIBg/RCqOir
	 hv6zogEM+CY8lqNZxkMqLdykAy9sDZT5WCBFu0aIhGNsX3gbGCsLtp+/12w9jiWyAi
	 foBsA4zznIknL202sHW6pB2cvfYL8TlPpYF0fSKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 706/744] selftests: mptcp: simult flows: mark unbalanced tests as flaky
Date: Thu,  6 Jun 2024 16:06:18 +0200
Message-ID: <20240606131755.118346091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit cc73a6577ae64247898269d138dee6b73ff710cc ]

These tests are flaky since their introduction. This might be less or
not visible depending on the CI running the tests, especially if it is
also busy doing other tasks in parallel.

A first analysis shown that the transfer can be slowed down when there
are some re-injections at the MPTCP level. Such re-injections can of
course happen, and disturb the transfer, but it looks strange to have
them in this lab. That could be caused by the kernel having access to
less CPU cycles -- e.g. when other activities are executed in parallel
-- or by a misinterpretation on the MPTCP packet scheduler side.

While this is being investigated, the tests are marked as flaky not to
create noises in other CIs.

Fixes: 219d04992b68 ("mptcp: push pending frames when subflow has free space")
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/475
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240524-upstream-net-20240524-selftests-mptcp-flaky-v1-2-a352362f3f8e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 25693b37f820d..6afc3ea211fc0 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -262,7 +262,7 @@ run_test()
 	do_transfer $small $large $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"
-	if [ $lret -ne 0 ]; then
+	if [ $lret -ne 0 ] && ! mptcp_lib_subtest_is_flaky; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
@@ -272,7 +272,7 @@ run_test()
 	do_transfer $large $small $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"
-	if [ $lret -ne 0 ]; then
+	if [ $lret -ne 0 ] && ! mptcp_lib_subtest_is_flaky; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
@@ -305,7 +305,7 @@ run_test 10 10 0 0 "balanced bwidth"
 run_test 10 10 1 25 "balanced bwidth with unbalanced delay"
 
 # we still need some additional infrastructure to pass the following test-cases
-run_test 10 3 0 0 "unbalanced bwidth"
+MPTCP_LIB_SUBTEST_FLAKY=1 run_test 10 3 0 0 "unbalanced bwidth"
 run_test 10 3 1 25 "unbalanced bwidth with unbalanced delay"
 run_test 10 3 25 1 "unbalanced bwidth with opposed, unbalanced delay"
 
-- 
2.43.0



