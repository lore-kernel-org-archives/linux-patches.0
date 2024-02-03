Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D912E6C;
	Sat,  3 Feb 2024 04:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933707; cv=none; b=u6Z4YWaOSPtkEPSV3EXk25yi8MkF0tCD/LIqS3T9wVNvXNlWvodA2GAhmv/LVMJe4V4DMgOW5XMOt7tkXAHeEJBBJgqwqOxKzKvs5FS9QnAPQRjJBrMGkEvcvGWaNSr3xA6FXGVIQWuwdOXS4FH/iRznw3aG+XQVPJcTLDnpROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933707; c=relaxed/simple;
	bh=FLSAz5FRDiYMmyb4nxsD3xLoM9koimdVSWdcBdG38JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US+7fk3mGX6F0dwCo8uMWn8dpR5yUQCV60Dr2w4d0o+e9esU7j7QR/XEqUX3hpz4TS5WwaSVMCwVWD8OYFT8DO4pIhye7QRJQPx3jUGMLPQ0WIkrPfb9um6cxWM6sncUu4K5oBy2Ab49pAyfWCdxiNo36IaMZEkxJY+6/TSbhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrSnFFu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrSnFFu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F5C433F1;
	Sat,  3 Feb 2024 04:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933706;
	bh=FLSAz5FRDiYMmyb4nxsD3xLoM9koimdVSWdcBdG38JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrSnFFu+AKZwTWNoA3/he6F388/EENjM+dBHcRWxXIewHeQLxVDVoFOqLD+TDLj+X
	 nJ+YAdEo9fIay9+q3wibX+YteOFRFOUZwhoeSS1fytMGpAex8P6Oo16C9GaVFRPbkX
	 DxwnJEYwZv1/M+wZI3VLA9VuGWfVYn6lQjD8RI/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/322] selftests: net: fix available tunnels detection
Date: Fri,  2 Feb 2024 20:06:45 -0800
Message-ID: <20240203035408.988465914@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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



