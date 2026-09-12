Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DFF356744;
	Sat, 12 Sep 2026 11:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211341; cv=none; b=DV87aLTLWn5muuh2IUgODL01F10Val5l4baWpHg/2iGUxqqMxjT8ie9fD4mkvxFmdREKPTwsOL8Imz4Ktp+tHN/iSiOAgi5ETZkDuRcKlAR8CT5RSGMN7PegdRek5M39doq6WGQcdrt6bSaR34gupHAnqXeACxe6aUME+MYaE9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211341; c=relaxed/simple;
	bh=tH/fTQPG9DmkxKVbDJ1LHNrJTynWGvkBz1cIigLFd5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrDiZGPPWg296ZycJhVZZIotGfEnnDsB+knX0MsTF5b7p8yJTSESgcmK9q7+OeiZAaMM1ZlK9ixHuOgQ7gEJZw6sY/IlE4pzn5iqpm8sPM4pdAGsYHzZK56IHHipd7GfObHantFOFePqsGp02nRu9iDHlfX0eniw3tjM5pX8f0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvtyRkUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvtyRkUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977E71F000FF;
	Sat, 12 Sep 2026 11:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211340;
	bh=9TPdraz1+i2CfLn6ORjocxBFUYyTHa0SuCSby1XdBVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvtyRkUqfAM+Oeg7LIsQY/9V/74mZFcFOKJi14M7IiDB7EAEWPSVgViGGVJbJfzds
	 RxVAn1ZBdsc91j55QjU070Ct0C6SYs9XKExS9/lXHRcTcH9w2T6hTQw6tDg29j15wh
	 kslhZCyZ7Gf1+wb9hPV/9B4g+QzvJsaJkmbHh/3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1194/1518] selftests/bpf: Use ping_command() for IPv6 pings in lwt_ip_encap
Date: Sat, 12 Sep 2026 08:56:03 +0200
Message-ID: <20260912065650.490151621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



