Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEFD2576E;
	Sat, 12 Sep 2026 09:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203680; cv=none; b=ZutHMTZd0+ulk7Tjz8psA4VPHu48A2JjOPTiZB8fVsg7pI5Gr4hDPsNybpk4iDj2qkjhR5DMOXgYWXmBkr4qAE03HB6Imi4vN+P5dk/ylDimhI9RbKbgiaf49Hbr80XN2hCiIuXXMuELVCvGMYlyP+rX9zn8kledqx5kjXOKR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203680; c=relaxed/simple;
	bh=5EIcKBhFgU8TZdoYyTgMiNSdxrfO8MrrIAfS1sREFqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ7KlGkvVE4/E7C36Yf7K/pwCIsFFkieeoHNvNQ3KGTZfrTqwu+Y4wuzzGyLsV9CksDNT4T8t12t8Tbi0yTsIOGLWXg910sJCyFr9Y10ucSVzTnDVnJ2qWWDLKZVH7py5WlXRNl+u1vuNTuc8aOleVPIbzEXLsFNWasRfKorMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xji+Tp5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xji+Tp5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015C41F000FF;
	Sat, 12 Sep 2026 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203679;
	bh=geUzBsZzCtfaEqbyqWC2mlyPQeQe2E/SOY7dx6MwfJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xji+Tp5Z7TIw2Rq4j0FVgLy+mZTPlj5L88E373NZOGfaE59kB5sNPh02A1aqGKs93
	 pyRd+e63qguqj3y0PoEZeoXAa/aU6fvnu5zwG//EdkWaYkmci6lqwX1yz0fygz6CaN
	 wJhji6UzK91L5RAE6b2kUJCVBfjpbmNnSgZZqW98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1455/1815] selftests/bpf: Use ping_command() for IPv6 pings in lwt_ip_encap
Date: Sat, 12 Sep 2026 08:53:25 +0200
Message-ID: <20260912065723.171447495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 073574da7a8e6055b1687c256bea070ab4b4ebea ]

lwt_ip_encap hardcodes the ping6 binary for its IPv6 pings. iputils
merged ping6 into ping long ago and distros have started dropping the
compat symlink -- Arch's iputils 20250605 ships only arping, clockdiff,
ping and tracepath. There, every lwt_ip_encap subtest fails:

  check_ping_ok:FAIL:ip netns exec ns-lwt-ip-encap-1-0101330 ping6 -c 1 \
    -W1 -I veth1 fb04::1 > /dev/null unexpected error: 256 (errno 2)
  #217/1   lwt_ip_encap_ipv4/egress:FAIL

The IPv4 subtests fail too, because check_ping_ok() pings both families.
SYS() runs the command through system(), so a missing binary is
indistinguishable from an unreachable peer.

network_helpers.c has had ping_command() for exactly this since commit
372642ea83ff ("selftests/bpf: Move netcnt test under test_progs"): it
falls back to "ping -6" when ping6 is not present. lwt_ip_encap.c is the
last hardcoded ping6 user. Fix that.

Fixes: f5e288943e2c ("selftests/bpf: Move test_lwt_ip_encap to test_progs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20260813213558.3103179-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
index 6606f0ed9a9a9..39e8a3b8b6afb 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
@@ -410,7 +410,8 @@ static int test_gso_fix(const char *ns1, const char *ns3, int family)
 static int check_ping_ok(const char *ns1)
 {
 	SYS(fail, "ip netns exec %s ping -c 1 -W1 -I veth1 %s > /dev/null", ns1, IP4_ADDR_DST);
-	SYS(fail, "ip netns exec %s ping6 -c 1 -W1 -I veth1 %s > /dev/null", ns1, IP6_ADDR_DST);
+	SYS(fail, "ip netns exec %s %s -c 1 -W1 -I veth1 %s > /dev/null", ns1,
+	    ping_command(AF_INET6), IP6_ADDR_DST);
 	return 0;
 fail:
 	return -1;
@@ -424,7 +425,8 @@ static int check_ping_fails(const char *ns1)
 	if (!ret)
 		return -1;
 
-	ret = SYS_NOFAIL("ip netns exec %s ping6 -c 1 -W1 -I veth1 %s", ns1, IP6_ADDR_DST);
+	ret = SYS_NOFAIL("ip netns exec %s %s -c 1 -W1 -I veth1 %s", ns1,
+			 ping_command(AF_INET6), IP6_ADDR_DST);
 	if (!ret)
 		return -1;
 
@@ -657,9 +659,10 @@ static void lwt_ip_encap_vxlan(bool ipv4_encap)
 	skel->bss->fexit_triggered = false;
 
 	if (ipv4_encap)
-		SYS(out, "ip netns exec %s ping  -c 1 -W1 %s", ns1, IP4_ADDR_DST);
+		SYS(out, "ip netns exec %s ping -c 1 -W1 %s", ns1, IP4_ADDR_DST);
 	else
-		SYS(out, "ip netns exec %s ping6 -c 1 -W1 %s", ns1, IP6_ADDR_DST);
+		SYS(out, "ip netns exec %s %s -c 1 -W1 %s", ns1,
+		    ping_command(AF_INET6), IP6_ADDR_DST);
 
 	if (!ASSERT_TRUE(skel->bss->fexit_triggered, "fexit_triggered"))
 		goto out;
-- 
2.53.0



