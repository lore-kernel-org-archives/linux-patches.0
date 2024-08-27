Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197F71C3F19;
	Tue, 27 Aug 2024 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771352; cv=none; b=fgSwdf9icnHfL8KnwxRf4/y3rDpONJIjHlc/7shcoNuD/FXdbXV3zM21dRc5rx+isNY06/HpORIKZ1LE2pRj24cRoS1l3LOQ9RzAfSBCizpuZF2uCLsycDNXKXaZOgucGGysyZUtsEzvRjgd2AOva31J32037ovvEM/47YncphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771352; c=relaxed/simple;
	bh=3dsUEz3Pr7fd3giI9nf0Rhq7H8st9sTxUMkyQlUvC+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8T8LM26p1vGokL6gJwErvjcY5bPRZ3IqRlojkYRAhqhk7vWwZo0nDN/DVADfCIV2O0qWJGyfxhYAhZlOloXs06qWnI6vgbAMQq02GRxWP9r5xTRxmjMWvulsqKfb2ZPrx9nVaKsLYZeF/lLjUweLHMVVJ2Ql7vj+gd9ZL6Atvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp4be8/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp4be8/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A34C4AF1D;
	Tue, 27 Aug 2024 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771352;
	bh=3dsUEz3Pr7fd3giI9nf0Rhq7H8st9sTxUMkyQlUvC+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp4be8/wba1z3wudZLX0QzyOCJE2Yw61gg+E1lgHBzQ1vBVpk3t36RRDNT3WYFcpN
	 /bfjPBC7+sYg5wpz18OaU5+xkY4RdfO+Zmc9lWUKtow4CYaJvZO3q6nvix/A5C/J45
	 bbEmf6z9RsLeW/IYYgGTqc2TUVdtxodeaSvy4DtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Chen <yiche@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 161/273] selftests: udpgro: no need to load xdp for gro
Date: Tue, 27 Aug 2024 16:38:05 +0200
Message-ID: <20240827143839.532313202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit d7818402b1d80347c764001583f6d63fa68c2e1a ]

After commit d7db7775ea2e ("net: veth: do not manipulate GRO when using
XDP"), there is no need to load XDP program to enable GRO. On the other
hand, the current test is failed due to loading the XDP program. e.g.

 # selftests: net: udpgro.sh
 # ipv4
 #  no GRO              ok
 #  no GRO chk cmsg     ok
 #  GRO                 ./udpgso_bench_rx: recv: bad packet len, got 1472, expected 14720
 #
 # failed

 [...]

 #  bad GRO lookup      ok
 #  multiple GRO socks  ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520
 #
 # ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520
 #
 # failed
 ok 1 selftests: net: udpgro.sh

After fix, all the test passed.

 # ./udpgro.sh
 ipv4
  no GRO                                  ok
  [...]
  multiple GRO socks                      ok

Fixes: d7db7775ea2e ("net: veth: do not manipulate GRO when using XDP")
Reported-by: Yi Chen <yiche@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-53858
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 4659cf01e4384..d5ffd8c9172e1 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -7,8 +7,6 @@ source net_helper.sh
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
-BPF_FILE="xdp_dummy.bpf.o"
-
 # set global exit status, but never reset nonzero one.
 check_err()
 {
@@ -38,7 +36,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
+	ip netns exec "${PEER_NS}" ethtool -K veth1 gro on
 }
 
 run_one() {
@@ -206,11 +204,6 @@ run_all() {
 	return $ret
 }
 
-if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing ${BPF_FILE}. Run 'make' first"
-	exit -1
-fi
-
 if [[ $# -eq 0 ]]; then
 	run_all
 elif [[ $1 == "__subprocess" ]]; then
-- 
2.43.0



