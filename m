Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAC12FB31;
	Wed, 19 Jun 2024 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802650; cv=none; b=HlSVegtw6sIK1ppOzWWO71SnOH/ma+s2b6LuAjiCIsPB8iBZZ7Cew7Sj2J9TF2J/Z9wPg9wyecBg4U6sIlvrPMHYjAWwKkZi+2z+feO6zU8R1wW48BegRZ3kXcjtPaFsFMGAkZ13mPJjf3big+fn1QZzS2ORGBYYqt0rzG8uy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802650; c=relaxed/simple;
	bh=VoQnp8RmEiviXvJN1SNCRfFqdAoH451sBjvLr7rdM7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkvbo/Jp89bMp/nwr2ZfLp1LquqzMRNZXfM1sgqQhW6/dgaOobDjpsPmdSOie7/MXKLRD5L4f1CWcMDJ239nr0QujHA4P5IEgmVvui68igamKMF21w6RC5HVI/UDRaRlCF4k8bqr8zmtFm2+RslgNKgT4gudHOncgmHYrVrghRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er63WK84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er63WK84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC272C2BBFC;
	Wed, 19 Jun 2024 13:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802650;
	bh=VoQnp8RmEiviXvJN1SNCRfFqdAoH451sBjvLr7rdM7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Er63WK84mQBsa+/UJ5QPOiIotHsJOnFdCnNpeo0aGiKkpOunguzDWonEh2syCVnnb
	 Svg+PQy7c6f6yACLhhdBxkzJPDbvE+N5gvE+Jla0FwCrbOkvzuuExnhR0pvOU9DKU2
	 hPgeBJHWHmjubnGzCkfsnJVM1Eu4qeOEqazF09p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 254/267] selftests: net: lib: avoid error removing empty netns name
Date: Wed, 19 Jun 2024 14:56:45 +0200
Message-ID: <20240619125616.066415559@linuxfoundation.org>
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
@@ -48,6 +48,7 @@ cleanup_ns()
 	fi
 
 	for ns in "$@"; do
+		[ -z "${ns}" ] && continue
 		ip netns delete "${ns}" &> /dev/null
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
@@ -61,7 +62,7 @@ cleanup_ns()
 
 cleanup_all_ns()
 {
-	cleanup_ns $NS_LIST
+	cleanup_ns "${NS_LIST[@]}"
 }
 
 # setup netns with given names as prefix. e.g
@@ -70,7 +71,7 @@ setup_ns()
 {
 	local ns=""
 	local ns_name=""
-	local ns_list=""
+	local ns_list=()
 	local ns_exist=
 	for ns_name in "$@"; do
 		# Some test may setup/remove same netns multi times
@@ -86,11 +87,11 @@ setup_ns()
 
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


