Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB9B12FB31;
	Wed, 19 Jun 2024 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802594; cv=none; b=hVPBIs4uRqT/k5jRMFvENohSOHNwhDtP45Hkqx/VYhHCF4asHGJgDouuKuHUGx2sAFBvgZwk+NgCMD7H0A2Gom1dFJ5WBR+YvlfnAypbp4KK4QMmZdjWpXOGb7U0lowyTwfmv+eP/w1PeypzsAEbJ1SGALFx6D1EWv40ijHFBZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802594; c=relaxed/simple;
	bh=XBjeOhCRQmqJLqO7p6lwr6yXekT/5Y61dCOSbiXE5xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeJwsxA7BbD1Un76Mu6/VUq7EaCA9hNIcfqukvAUKAbp9ALdBXG/eyHdT1+5JKEGGAtOx/5Ni23H41ogaUY9nQcli9FbacYTPIo+YxePAooYTPfcV252clq3lBIv66W77FiJ+8OL+7AlxAIGYgxinBXGACyWb6q9+99W+7d1lPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5QGkvcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5QGkvcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CEFC2BBFC;
	Wed, 19 Jun 2024 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802594;
	bh=XBjeOhCRQmqJLqO7p6lwr6yXekT/5Y61dCOSbiXE5xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5QGkvcsEQsgFLnuX+kl2v8Ms2/qFd6of3tJr6sKDaS20EqM4oeBq5Fas2qnGEA3D
	 r4+LU0G2aAJJi2D0sflfF/fNZiMILTBy64SJGwR2ufrEIDS8edJh7Tc4ehuYjPaNuB
	 b1Z5f2vtpbaItpyOVlKYRAWT77ueTZuU24TIWDJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 248/267] selftests: forwarding: Avoid failures to source net/lib.sh
Date: Wed, 19 Jun 2024 14:56:39 +0200
Message-ID: <20240619125615.839554332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

commit 2114e83381d3289a88378850f43069e79f848083 upstream.

The expression "source ../lib.sh" added to net/forwarding/lib.sh in commit
25ae948b4478 ("selftests/net: add lib.sh") does not work for tests outside
net/forwarding which source net/forwarding/lib.sh (1). It also does not
work in some cases where only a subset of tests are exported (2).

Avoid the problems mentioned above by replacing the faulty expression with
a copy of the content from net/lib.sh which is used by files under
net/forwarding.

A more thorough solution which avoids duplicating content between
net/lib.sh and net/forwarding/lib.sh has been posted here:
https://lore.kernel.org/netdev/20231222135836.992841-1-bpoirier@nvidia.com/

The approach in the current patch is a stopgap solution to avoid submitting
large changes at the eleventh hour of this development cycle.

Example of problem 1)

tools/testing/selftests/drivers/net/bonding$ ./dev_addr_lists.sh
./net_forwarding_lib.sh: line 41: ../lib.sh: No such file or directory
TEST: bonding cleanup mode active-backup                            [ OK ]
TEST: bonding cleanup mode 802.3ad                                  [ OK ]
TEST: bonding LACPDU multicast address to slave (from bond down)    [ OK ]
TEST: bonding LACPDU multicast address to slave (from bond up)      [ OK ]

An error message is printed but since the test does not use functions from
net/lib.sh, the test results are not affected.

Example of problem 2)

tools/testing/selftests$ make install TARGETS="net/forwarding"
tools/testing/selftests$ cd kselftest_install/net/forwarding/
tools/testing/selftests/kselftest_install/net/forwarding$ ./pedit_ip.sh veth{0..3}
lib.sh: line 41: ../lib.sh: No such file or directory
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth1 ingress pedit ip src set 198.51.100.1               [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth2 egress pedit ip src set 198.51.100.1                [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth1 ingress pedit ip dst set 198.51.100.1               [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth2 egress pedit ip dst set 198.51.100.1                [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth1 ingress pedit ip6 src set 2001:db8:2::1             [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth2 egress pedit ip6 src set 2001:db8:2::1              [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth1 ingress pedit ip6 dst set 2001:db8:2::1             [FAIL]
        Expected to get 10 packets, but got .
./pedit_ip.sh: line 135: busywait: command not found
TEST: dev veth2 egress pedit ip6 dst set 2001:db8:2::1              [FAIL]
        Expected to get 10 packets, but got .

In this case, the test results are affected.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240104141109.100672-1-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/lib.sh |   27 +++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -38,7 +38,32 @@ if [[ -f $relative_path/forwarding.confi
 	source "$relative_path/forwarding.config"
 fi
 
-source ../lib.sh
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+busywait()
+{
+	local timeout=$1; shift
+
+	local start_time="$(date -u +%s%3N)"
+	while true
+	do
+		local out
+		out=$("$@")
+		local ret=$?
+		if ((!ret)); then
+			echo -n "$out"
+			return 0
+		fi
+
+		local current_time="$(date -u +%s%3N)"
+		if ((current_time - start_time > timeout)); then
+			echo -n "$out"
+			return 1
+		fi
+	done
+}
+
 ##############################################################################
 # Sanity checks
 


