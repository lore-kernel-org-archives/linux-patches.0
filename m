Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333817588;
	Sat,  3 Feb 2024 04:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933982; cv=none; b=N08A94XAn27bz7W7+o0xPiKnL/W7sH7UI8qecIP5MvnGypeIjovO6ObkWGHSbb2PYXXjYKp+8eZD3wgx2GAS7caRLQhoV9GbV8m1XuCTichUZFZ/RM3oUZZWYUP+QU/Ypky7o8ddAIl6uidD+uCSiXKjZOL3yjudWfGIzOn0Z/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933982; c=relaxed/simple;
	bh=fLG2vuCegacu0jUNxFqCuBGOlSrGtHFsnhG0TgmQ0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZHbn3a3uym2RaWh6eaxxF2lJSM7NZxfSdQsEatvW/WHIiS/W1xgft+lEP6mzbO/eMson4I4VLp3PN3/3mPiJjWUPu22groM0P9bq4XPhnE5Qellm6/65L3esWy3KDCx4cIDcofDKP9GSNZONgZs6thquGRJNd0hxWoxSn+5tqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxxPFDAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxxPFDAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FAFC43390;
	Sat,  3 Feb 2024 04:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933981;
	bh=fLG2vuCegacu0jUNxFqCuBGOlSrGtHFsnhG0TgmQ0yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxxPFDAl5Y3Ou/kbeLmDebl1WaD267cbyp9B/OC6dA3LqasSJdZFCKat5/G0EbHwj
	 YLL3/3goWsa5ChYWNBdMSjtmY60w62UiIU6wFZhi6nGETyUiR2hpWVVNa9iwar+VEH
	 uFGvw+wUylLMY6Fg1WzYPg/PSdNWLX5jwZK/2c6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 339/353] selftests: net: fix available tunnels detection
Date: Fri,  2 Feb 2024 20:07:37 -0800
Message-ID: <20240203035414.500279988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

[ Upstream commit e4e4b6d568d2549583cbda3f8ce567e586cb05da ]

The pmtu.sh test tries to detect the tunnel protocols available
in the running kernel and properly skip the unsupported cases.

In a few more complex setup, such detection is unsuccessful, as
the script currently ignores some intermediate error code at
setup time.

Before:
  # which: no nettest in (/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin)
  # TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [FAIL]
  #   PMTU exception wasn't created after creating tunnel exceeding link layer MTU
  # ./pmtu.sh: line 931: kill: (7543) - No such process
  # ./pmtu.sh: line 931: kill: (7544) - No such process

After:
  #   xfrm4 not supported
  # TEST: vti4: PMTU exceptions                                         [SKIP]

Fixes: ece1278a9b81 ("selftests: net: add ESP-in-UDP PMTU test")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/cab10e75fda618e6fff8c595b632f47db58b9309.1706635101.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index b3b2dc5a630c..1f1e9a49f59a 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -714,23 +714,23 @@ setup_xfrm6() {
 }
 
 setup_xfrm4udp() {
-	setup_xfrm 4 ${veth4_a_addr} ${veth4_b_addr} "encap espinudp 4500 4500 0.0.0.0"
-	setup_nettest_xfrm 4 4500
+	setup_xfrm 4 ${veth4_a_addr} ${veth4_b_addr} "encap espinudp 4500 4500 0.0.0.0" && \
+		setup_nettest_xfrm 4 4500
 }
 
 setup_xfrm6udp() {
-	setup_xfrm 6 ${veth6_a_addr} ${veth6_b_addr} "encap espinudp 4500 4500 0.0.0.0"
-	setup_nettest_xfrm 6 4500
+	setup_xfrm 6 ${veth6_a_addr} ${veth6_b_addr} "encap espinudp 4500 4500 0.0.0.0" && \
+		setup_nettest_xfrm 6 4500
 }
 
 setup_xfrm4udprouted() {
-	setup_xfrm 4 ${prefix4}.${a_r1}.1 ${prefix4}.${b_r1}.1 "encap espinudp 4500 4500 0.0.0.0"
-	setup_nettest_xfrm 4 4500
+	setup_xfrm 4 ${prefix4}.${a_r1}.1 ${prefix4}.${b_r1}.1 "encap espinudp 4500 4500 0.0.0.0" && \
+		setup_nettest_xfrm 4 4500
 }
 
 setup_xfrm6udprouted() {
-	setup_xfrm 6 ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 "encap espinudp 4500 4500 0.0.0.0"
-	setup_nettest_xfrm 6 4500
+	setup_xfrm 6 ${prefix6}:${a_r1}::1 ${prefix6}:${b_r1}::1 "encap espinudp 4500 4500 0.0.0.0" && \
+		setup_nettest_xfrm 6 4500
 }
 
 setup_routing_old() {
-- 
2.43.0



