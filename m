Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397295F54E;
	Tue, 13 Feb 2024 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845354; cv=none; b=HSFmee4tbK0D2dZvD8M4DeaWZY4aWibX0DUouY2XhpShrHDzQSNMstUx+mXehN3wvtfQfZlGNT3HAgnlGi1iHqdbZSwRYZaN1I/kh45wT1Tm7HNeEMthjxJ9+0O0EwyvS+f926oG48903CKJO7JN/T+PdtkA2gwXr53R1HY4r3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845354; c=relaxed/simple;
	bh=J4pdbmSADvFO7GVwsPmZoj7P+sgE7PcRBWLWYcL9D44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDjdaG9pb5Ry3s2TfXtNFNKIcEPKnnVLISu6pk8XAiarj1wF2wZjG5/9GJed/RdqQbahogmXpKWZgvljGkgI37MRUFyhJAUrERhojUIfQtRPU7kbcwJ1/U9ySfViLN0qJmyi1b5OsXWXcWdOiv0MbyPE7ZYJIJheby5yFNhj85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZFxKYJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZFxKYJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93139C433F1;
	Tue, 13 Feb 2024 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845354;
	bh=J4pdbmSADvFO7GVwsPmZoj7P+sgE7PcRBWLWYcL9D44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZFxKYJEK+B652DNDeSBfhpIZHtV3mLmMcpeh8/5gx1AJeV9D2ocNFGBPhIMuZTdw
	 4Pbg8Lodj4UmXDjnM5oE53m+tcjpM2ZII3GdHnQjqbEkUbLgwkUxm10dAEhEw0lrHx
	 JCZ5LYEi4WiV6rpmGTkPe6rIkykXRlpidNlJKwko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/121] selftests: net: avoid just another constant wait
Date: Tue, 13 Feb 2024 18:21:04 +0100
Message-ID: <20240213171854.602620364@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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



