Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D32143C7A;
	Thu, 13 Jun 2024 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279472; cv=none; b=BKULhwgYn50jggLa2y9mEQZkx5+g+RGr8FyGVRt/McAwvi5dP6S8vzJLVC43m92ve9lWF+s7mTuqONvfGXRchVS7pJOWbMpI6MhBx/rB3ba1yCIMbkRMhxSY6uuJL4fV9iePKofilhCtcFZS7iApT1c/EvuoTV9LN+rcI3uuGRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279472; c=relaxed/simple;
	bh=lKDJKF+mjPiKZ5y6BdCjR5mkQ3LhW8Y/E9V59uNcOtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7Nk23gKX6zBJ6wOO9tC+4d/Xsudwj+2wp16cclPcvYC9Dmf+x2mUH7cVRqaDunUe7lRRppsdMUl/R3hiS6OwHzMXr9/2OqJmi+bObhPd6ba+4dwebsfGSR4W4XRvAUHxjzhWPjWYRaEpPrWb9O9Fz/tIbd0xaTIUECu+PEb7OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RObv51fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RObv51fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF7CC2BBFC;
	Thu, 13 Jun 2024 11:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279472;
	bh=lKDJKF+mjPiKZ5y6BdCjR5mkQ3LhW8Y/E9V59uNcOtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RObv51fUXwpmZ582nBTBZWhxHh59szSMRD1AxY7KxFYpEw2nDcQgqcbCnj3nLp4s3
	 4ni4RlRHvmDXQBk8mZsIbOdsMuqPMuly0XAYwo2SXNj46J1GefF+mK7+iA44Veu2fF
	 O/LCKergyLFt4FFSnt6TFF5w79yf+SYwaYwzkqlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 086/157] selftests: net: lib: avoid error removing empty netns name
Date: Thu, 13 Jun 2024 13:33:31 +0200
Message-ID: <20240613113230.754338145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 79322174bcc780b99795cb89d237b26006a8b94b upstream.

If there is an error to create the first netns with 'setup_ns()',
'cleanup_ns()' will be called with an empty string as first parameter.

The consequences is that 'cleanup_ns()' will try to delete an invalid
netns, and wait 20 seconds if the netns list is empty.

Instead of just checking if the name is not empty, convert the string
separated by spaces to an array. Manipulating the array is cleaner, and
calling 'cleanup_ns()' with an empty array will be a no-op.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Cc: stable@vger.kernel.org
Acked-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240605-upstream-net-20240605-selftests-net-lib-fixes-v1-2-b3afadd368c9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -10,7 +10,7 @@ BUSYWAIT_TIMEOUT=$((WAIT_TIMEOUT * 1000)
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 # namespace list created by setup_ns
-NS_LIST=""
+NS_LIST=()
 
 ##############################################################################
 # Helpers
@@ -133,6 +133,7 @@ cleanup_ns()
 	fi
 
 	for ns in "$@"; do
+		[ -z "${ns}" ] && continue
 		ip netns delete "${ns}" &> /dev/null
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
@@ -146,7 +147,7 @@ cleanup_ns()
 
 cleanup_all_ns()
 {
-	cleanup_ns $NS_LIST
+	cleanup_ns "${NS_LIST[@]}"
 }
 
 # setup netns with given names as prefix. e.g
@@ -155,7 +156,7 @@ setup_ns()
 {
 	local ns=""
 	local ns_name=""
-	local ns_list=""
+	local ns_list=()
 	local ns_exist=
 	for ns_name in "$@"; do
 		# Some test may setup/remove same netns multi times
@@ -171,13 +172,13 @@ setup_ns()
 
 		if ! ip netns add "$ns"; then
 			echo "Failed to create namespace $ns_name"
-			cleanup_ns "$ns_list"
+			cleanup_ns "${ns_list[@]}"
 			return $ksft_skip
 		fi
 		ip -n "$ns" link set lo up
-		! $ns_exist && ns_list="$ns_list $ns"
+		! $ns_exist && ns_list+=("$ns")
 	done
-	NS_LIST="$NS_LIST $ns_list"
+	NS_LIST+=("${ns_list[@]}")
 }
 
 tc_rule_stats_get()


