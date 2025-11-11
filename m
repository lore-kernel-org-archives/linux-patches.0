Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0144305E1B;
	Tue, 11 Nov 2025 01:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823864; cv=none; b=QdP0fWGUrY4kpcLCJvA8fDPncqRotGGsIo6U4l14JR02x7T2ig8dS4Kll9U8bJqtO5ix99lbJBWhzlFg7/1j10DgYqRCLiEi3Mwc5yber3oL0mOMvrL3PChUBSYJ4wor38NpbCGIp3cXWnHAPFJ6DnXP8cwwrbpiZXxvzG90x1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823864; c=relaxed/simple;
	bh=OVufMZiUR9yJPmHb2iS57k3MZ9fi6B6dQK0Dr5XhigQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJmEBR1OTjUcx2rOBOvvcDvpcjCBg4Cf8qGOIzIdY4m07phPjq5MRjAH87ZGYRDAHcF+/kA5DS5LJFaAgtCJjaEDA4ohmQhHEwMBbmR7hkQNpIWBLseVEKEsENkuS5HD6OSrExXFO4+xjkMzD+UNmsrHaIYCyXU9q6gNtCGmi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnuPeHbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnuPeHbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727D4C19422;
	Tue, 11 Nov 2025 01:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823863;
	bh=OVufMZiUR9yJPmHb2iS57k3MZ9fi6B6dQK0Dr5XhigQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnuPeHbQnQuzKxL7KtULKff0Eq+3pXAyz5O3anNrf+aBsrxrTZKjatDuq92CMuGRy
	 PP0xoQjxvq7F/jrZnjfpQXPwLIPH7osyVBIR4h5wA/oVytL/5875gQSelxij+wxUVO
	 KYjdJSKdif6y+Rga/5bIJjf9LpAe//5l9pMfRO/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/565] selftests: traceroute: Return correct value on failure
Date: Tue, 11 Nov 2025 09:43:15 +0900
Message-ID: <20251111004534.505980074@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

[ Upstream commit c068ba9d3ded56cb1ba4d5135ee84bf8039bd563 ]

The test always returns success even if some tests were modified to
fail. Fix by converting the test to use the appropriate library
functions instead of using its own functions.

Before:

 # ./traceroute.sh
 TEST: IPV6 traceroute                                               [FAIL]
 TEST: IPV4 traceroute                                               [ OK ]

 Tests passed:   1
 Tests failed:   1
 $ echo $?
 0

After:

 # ./traceroute.sh
 TEST: IPv6 traceroute                                               [FAIL]
         traceroute6 did not return 2000:102::2
 TEST: IPv4 traceroute                                               [ OK ]
 $ echo $?
 1

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250908073238.119240-5-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/traceroute.sh | 38 ++++++-----------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/net/traceroute.sh b/tools/testing/selftests/net/traceroute.sh
index b50e52afa4f49..1ac91eebd16f5 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -10,28 +10,6 @@ PAUSE_ON_FAIL=no
 
 ################################################################################
 #
-log_test()
-{
-	local rc=$1
-	local expected=$2
-	local msg="$3"
-
-	if [ ${rc} -eq ${expected} ]; then
-		printf "TEST: %-60s  [ OK ]\n" "${msg}"
-		nsuccess=$((nsuccess+1))
-	else
-		ret=1
-		nfail=$((nfail+1))
-		printf "TEST: %-60s  [FAIL]\n" "${msg}"
-		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
-			echo
-			echo "hit enter to continue, 'q' to quit"
-			read a
-			[ "$a" = "q" ] && exit 1
-		fi
-	fi
-}
-
 run_cmd()
 {
 	local ns
@@ -205,9 +183,12 @@ run_traceroute6()
 {
 	setup_traceroute6
 
+	RET=0
+
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
 	run_cmd $h1 "traceroute6 2000:103::4 | grep -q 2000:102::2"
-	log_test $? 0 "IPV6 traceroute"
+	check_err $? "traceroute6 did not return 2000:102::2"
+	log_test "IPv6 traceroute"
 
 	cleanup_traceroute6
 }
@@ -265,9 +246,12 @@ run_traceroute()
 {
 	setup_traceroute
 
+	RET=0
+
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
 	run_cmd $h1 "traceroute 1.0.2.4 | grep -q 1.0.1.1"
-	log_test $? 0 "IPV4 traceroute"
+	check_err $? "traceroute did not return 1.0.1.1"
+	log_test "IPv4 traceroute"
 
 	cleanup_traceroute
 }
@@ -284,9 +268,6 @@ run_tests()
 ################################################################################
 # main
 
-declare -i nfail=0
-declare -i nsuccess=0
-
 while getopts :pv o
 do
 	case $o in
@@ -301,5 +282,4 @@ require_command traceroute
 
 run_tests
 
-printf "\nTests passed: %3d\n" ${nsuccess}
-printf "Tests failed: %3d\n"   ${nfail}
+exit "${EXIT_STATUS}"
-- 
2.51.0



