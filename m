Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A685FF03;
	Tue, 13 Feb 2024 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845715; cv=none; b=K7UGOh6q0o3o1MF3gpvyZrdJPXCI54WZQKoJcMPkM7G/MsmpDljHF6W/zRKGiy6mC84FmeGxRRKIq11+pPvQg3WYaIJPP/f9qdEVm/g/Gf/P7uUI9KMvb6ePQfRrb8v+cqUgz2hKDZIlVIpc1tUww4dPdwP1ZnCEIQ1xQQFlcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845715; c=relaxed/simple;
	bh=3mzD82XRSJOdRWf2jO8pxLfERGhJRXBQbA+CaUCQyvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmmo9nPG7Gjr5AbPchvVd1HWAQ1vdsx5v6vsA5VH14k2DytAZe3my19jL8TMhe3wl9ulZjTCjxCPrKDRk7sG+HJs3NcfQIl9YWFs6si3LNUr7k3kvCJyja9EpSgknHDPy8EuA0SPeZu8rGZu08JoS0F8l7Zf3mPiMh2kf3w31O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwueLHD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwueLHD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4011C433C7;
	Tue, 13 Feb 2024 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845715;
	bh=3mzD82XRSJOdRWf2jO8pxLfERGhJRXBQbA+CaUCQyvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwueLHD3wMqu1pu9jRKPFwgvwiQ5kpqRihsLiiwgIwMz79+LiJbhpGXDaXM4ispHA
	 r8Q2WbPrI/vdFDTrHggSBNIO+pD7N0iod+gMKGe+yHUtNoXpOcS8kkuMCj2nisJDgK
	 RE/UTX7znCwUnK4+KCrxjWzlOy4FJYm9jL6OM77o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 038/124] selftests: net: avoid just another constant wait
Date: Tue, 13 Feb 2024 18:21:00 +0100
Message-ID: <20240213171854.844738814@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 691bb4e49c98a47bc643dd808453136ce78b15b4 ]

Using hard-coded constant timeout to wait for some expected
event is deemed to fail sooner or later, especially in slow
env.

Our CI has spotted another of such race:
   # TEST: ipv6: cleanup of cached exceptions - nexthop objects          [FAIL]
   #   can't delete veth device in a timely manner, PMTU dst likely leaked

Replace the crude sleep with a loop looking for the expected condition
at low interval for a much longer range.

Fixes: b3cc4f8a8a41 ("selftests: pmtu: add explicit tests for PMTU exceptions cleanup")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/fd5c745e9bb665b724473af6a9373a8c2a62b247.1706812005.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index f0febc19baae..d65fdd407d73 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1957,6 +1957,13 @@ check_command() {
 	return 0
 }
 
+check_running() {
+	pid=${1}
+	cmd=${2}
+
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+}
+
 test_cleanup_vxlanX_exception() {
 	outer="${1}"
 	encap="vxlan"
@@ -1987,11 +1994,12 @@ test_cleanup_vxlanX_exception() {
 
 	${ns_a} ip link del dev veth_A-R1 &
 	iplink_pid=$!
-	sleep 1
-	if [ "$(cat /proc/${iplink_pid}/cmdline 2>/dev/null | tr -d '\0')" = "iplinkdeldevveth_A-R1" ]; then
-		err "  can't delete veth device in a timely manner, PMTU dst likely leaked"
-		return 1
-	fi
+	for i in $(seq 1 20); do
+		check_running ${iplink_pid} "iplinkdeldevveth_A-R1" || return 0
+		sleep 0.1
+	done
+	err "  can't delete veth device in a timely manner, PMTU dst likely leaked"
+	return 1
 }
 
 test_cleanup_ipv6_exception() {
-- 
2.43.0



