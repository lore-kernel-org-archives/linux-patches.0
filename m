Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6918A6A5;
	Mon, 27 Oct 2025 19:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592599; cv=none; b=iaq/m348hBmW9qoExJLUmyMx6b00o14bapjhrZzFJARBH7FCbK31qJ5mRTWrOkvduda2FsXr6rTBGL6zdDIpc04nkoPgmcBiWhy7gBmYrvEOOVEDMy85dL0Dq/TsPctZj0JamRL0Q/hXue4YJ/GI6uEfAo3jYmI7Yv4CYd0lerA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592599; c=relaxed/simple;
	bh=g3PeYtwzhIMzo5vKLKmhPK3dEM7jiX17HUlOWkJM7Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRaiOMbRpNkaRcLPNKSwxkkdMtq9QKOpqG5VWgOe+oCng6cZUYuY/WP93Vt0+sF0yABWwq3Gm5oefdjxSEVFphYzQnltCA7R+oZvohSAs6+GHHKX+x3QKIfUx21AfTTg7W+F2/REsHjwAbU8F41ZyvzQu3YsFS6UdIXbbuES52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/jCTcJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/jCTcJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95262C4CEF1;
	Mon, 27 Oct 2025 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592598;
	bh=g3PeYtwzhIMzo5vKLKmhPK3dEM7jiX17HUlOWkJM7Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/jCTcJG3dvquu5o4ZNq/+lhNqlUb0eej15drT48xNGrmGknQrb0AEFuHsGFZ3EeV
	 O+4etwl58VCwynMXNM4NyDml2bTpJlX/tbaLfGP0LDVe+h6QxgfcXJClt5hVCFlCwH
	 NGey2GQ7Fj8H+gaDWfm6pIhY1iJxo7DtaLAys1UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/84] selftests/net: convert sctp_vrf.sh to run it in unique namespace
Date: Mon, 27 Oct 2025 19:36:13 +0100
Message-ID: <20251027183439.463974076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 90e271f65ee428ae5a75e783f5ba50a10dece09d ]

Here is the test result after conversion.

]# ./sctp_vrf.sh
Testing For SCTP VRF:
TEST 01: nobind, connect from client 1, l3mdev_accept=1, Y [PASS]
...
TEST 12: bind vrf-2 & 1 in server, connect from client 1 & 2, N [PASS]
***v6 Tests Done***

Acked-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: a73ca0449bcb ("selftests: net: fix server bind failure in sctp_vrf.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/sctp_vrf.sh | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/sctp_vrf.sh b/tools/testing/selftests/net/sctp_vrf.sh
index c721e952e5f30..c854034b6aa16 100755
--- a/tools/testing/selftests/net/sctp_vrf.sh
+++ b/tools/testing/selftests/net/sctp_vrf.sh
@@ -6,13 +6,11 @@
 #                                                  SERVER_NS
 #       CLIENT_NS2 (veth1) <---> (veth2) -> vrf_s2
 
-CLIENT_NS1="client-ns1"
-CLIENT_NS2="client-ns2"
+source lib.sh
 CLIENT_IP4="10.0.0.1"
 CLIENT_IP6="2000::1"
 CLIENT_PORT=1234
 
-SERVER_NS="server-ns"
 SERVER_IP4="10.0.0.2"
 SERVER_IP6="2000::2"
 SERVER_PORT=1234
@@ -20,9 +18,7 @@ SERVER_PORT=1234
 setup() {
 	modprobe sctp
 	modprobe sctp_diag
-	ip netns add $CLIENT_NS1
-	ip netns add $CLIENT_NS2
-	ip netns add $SERVER_NS
+	setup_ns CLIENT_NS1 CLIENT_NS2 SERVER_NS
 
 	ip net exec $CLIENT_NS1 sysctl -w net.ipv6.conf.default.accept_dad=0 2>&1 >/dev/null
 	ip net exec $CLIENT_NS2 sysctl -w net.ipv6.conf.default.accept_dad=0 2>&1 >/dev/null
@@ -67,9 +63,7 @@ setup() {
 
 cleanup() {
 	ip netns exec $SERVER_NS pkill sctp_hello 2>&1 >/dev/null
-	ip netns del "$CLIENT_NS1"
-	ip netns del "$CLIENT_NS2"
-	ip netns del "$SERVER_NS"
+	cleanup_ns $CLIENT_NS1 $CLIENT_NS2 $SERVER_NS
 }
 
 wait_server() {
-- 
2.51.0



