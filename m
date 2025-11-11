Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1667333443;
	Tue, 11 Nov 2025 01:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824561; cv=none; b=PdL6nvB2kNCv2XTzQyiC8bm8j7Bvfo2nvQNelFwmFG5KeTpW77NF1RrLs2ZsuqzMH8b/hSdmLDKNHhcyo/UsZDfvXpekjfp2c1DHVGwRVU6u9KW+pOybO5rYKjAtDh9fASc10sN/3hvAxGHr5n6roWkbKXUpuL0/QSZTj+vbn40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824561; c=relaxed/simple;
	bh=BOGO2vNtNgVybIhjzuljFkiuiIpM9hKyALPefvffkS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq5Fk0dJJfkVGGvqRNduNLTgJqcyv9OUmLdByTQN/mCQ6XTnP4Hnz427T/RzmmSjqNE7lryTW1X5utcbrgKsZNdMMDbb4JNq37lyh3BaynjrrNzP/LTD4s0sx4SKFwzltKQ2YWlpEQqgMbGSJgsHOOLGqKDA+OSJXolGJqJJqFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izcdrsqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izcdrsqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FA9C4CEFB;
	Tue, 11 Nov 2025 01:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824560;
	bh=BOGO2vNtNgVybIhjzuljFkiuiIpM9hKyALPefvffkS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izcdrsqBtKq6CcKSxhTuO/OHUnX9dCxoUHLUJYnzjwsSXwJeq5eGs16x3BiJST0Ko
	 KSxioPgVkDRGVt8wUFqY3qyyCSNgN1q4wFm5pggKGZ+ut1o+CgBvHMXCxePQ8uUYGa
	 UZ9TYbguvRxbstRzzaWvyTrz91EtQLF1A+4jTQmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 524/849] selftests: net: lib.sh: Dont defer failed commands
Date: Tue, 11 Nov 2025 09:41:34 +0900
Message-ID: <20251111004549.089946665@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit fa57032941d4b451c7264ebf3ad595bc98e3a9a9 ]

Usually the autodefer helpers in lib.sh are expected to be run in context
where success is the expected outcome. However when using them for feature
detection, failure can legitimately occur. But the failed command still
schedules a cleanup, which will likely fail again.

Instead, only schedule deferred cleanup when the positive command succeeds.

This way of organizing the cleanup has the added benefit that now the
return code from these functions reflects whether the command passed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/af10a5bb82ea11ead978cf903550089e006d7e70.1757004393.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 32 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index c7add0dc4c605..80cf1a75136cf 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -547,8 +547,8 @@ ip_link_add()
 {
 	local name=$1; shift
 
-	ip link add name "$name" "$@"
-	defer ip link del dev "$name"
+	ip link add name "$name" "$@" && \
+		defer ip link del dev "$name"
 }
 
 ip_link_set_master()
@@ -556,8 +556,8 @@ ip_link_set_master()
 	local member=$1; shift
 	local master=$1; shift
 
-	ip link set dev "$member" master "$master"
-	defer ip link set dev "$member" nomaster
+	ip link set dev "$member" master "$master" && \
+		defer ip link set dev "$member" nomaster
 }
 
 ip_link_set_addr()
@@ -566,8 +566,8 @@ ip_link_set_addr()
 	local addr=$1; shift
 
 	local old_addr=$(mac_get "$name")
-	ip link set dev "$name" address "$addr"
-	defer ip link set dev "$name" address "$old_addr"
+	ip link set dev "$name" address "$addr" && \
+		defer ip link set dev "$name" address "$old_addr"
 }
 
 ip_link_has_flag()
@@ -590,8 +590,8 @@ ip_link_set_up()
 	local name=$1; shift
 
 	if ! ip_link_is_up "$name"; then
-		ip link set dev "$name" up
-		defer ip link set dev "$name" down
+		ip link set dev "$name" up && \
+			defer ip link set dev "$name" down
 	fi
 }
 
@@ -600,8 +600,8 @@ ip_link_set_down()
 	local name=$1; shift
 
 	if ip_link_is_up "$name"; then
-		ip link set dev "$name" down
-		defer ip link set dev "$name" up
+		ip link set dev "$name" down && \
+			defer ip link set dev "$name" up
 	fi
 }
 
@@ -609,20 +609,20 @@ ip_addr_add()
 {
 	local name=$1; shift
 
-	ip addr add dev "$name" "$@"
-	defer ip addr del dev "$name" "$@"
+	ip addr add dev "$name" "$@" && \
+		defer ip addr del dev "$name" "$@"
 }
 
 ip_route_add()
 {
-	ip route add "$@"
-	defer ip route del "$@"
+	ip route add "$@" && \
+		defer ip route del "$@"
 }
 
 bridge_vlan_add()
 {
-	bridge vlan add "$@"
-	defer bridge vlan del "$@"
+	bridge vlan add "$@" && \
+		defer bridge vlan del "$@"
 }
 
 wait_local_port_listen()
-- 
2.51.0



