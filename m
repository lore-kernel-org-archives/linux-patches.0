Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DCA76905;
	Wed, 21 Feb 2024 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522904; cv=none; b=qL5fPdbrVcwa7gALMB1R3HwrYiL/lhd0FmrtDUlX8+FRKZY5TDe8B3tWqCJSK3FmwOcOFDMijdvUpTYqcVM81aD+L56ovMHgxeiyhcE9I52hLR99XeQImqGpYixcF5KC0PxOv9/6Hi7fGsTfP+vFTEpKoONTUOZsPfs8PA/tzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522904; c=relaxed/simple;
	bh=p4WRvP1/wDadlmEyZG2JAzG1AYUNBdUmfBihmEiJRC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+yq3VpFh/QSVqlhrsfWDA04uzamMX1EXMFKK7GK1SbHXtwzgYxp5RtIuTSGjPwgyrCMTuYTs/f4AZcFrNzRHLwXy/aV/UujVGFiWwTmKdsIWC8lu6d+QB54xQzOueERs8a7eAch9V+5COrNVvfLURc1AJ6xxinOD/RZB1eTzgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hisamrqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hisamrqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A304C43390;
	Wed, 21 Feb 2024 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522903;
	bh=p4WRvP1/wDadlmEyZG2JAzG1AYUNBdUmfBihmEiJRC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hisamrqNBWtlVAD4C7LqgOQsGoigLAIvk4QjJq9PDkgCEOkK7Ak9xzongWOOkoqJv
	 B5Y3mfKf7MaXizlqF1+TIuGJgjsP3j09NsAZRUxrQP7ZMSNUZpKtag4hh5MIEeQKqo
	 KAQioDqogtuzpMZcsJuOdxRvKPOaqRFvDJH2rCvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/476] selftests: net: fix available tunnels detection
Date: Wed, 21 Feb 2024 14:05:39 +0100
Message-ID: <20240221130018.644771742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a9d482c5058..8797f7b5fb83 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -698,23 +698,23 @@ setup_xfrm6() {
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



