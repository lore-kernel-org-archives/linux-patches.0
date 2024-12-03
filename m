Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B801362;
	Tue,  3 Dec 2024 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241202; cv=none; b=LBXupTlYoiHvjRq1zedi3BVFmxnsYqR55d0JhG9mbwKsWMlwZcd7g12BaQahPdI9n5QB32ksiVPXsGbuDjPTOxDW65/lJFtOGZ5g+YuFCqQqj5+VZTMEF6tM+1xiZylDcNk7XTWMWgUCiMm86Cg6Xmz/ksbnWdpn867mhZ2/BT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241202; c=relaxed/simple;
	bh=nmkRZY21Ni+3miFmnql1q8z4+eZpLH2L4bw2jBWBlN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seO7Q05wLeAqxOEflqkFQWB3MH3gVz41+3db8SWz6q57qnuOcKlvBIpPRXkh6FYsVsbwJRMmO3HoAuL6NKKpfVaF7y1U9LUveqmrmHAxSVmPV4jNO42Hx6btLtyNcgy97etVrH3/Q/LpkCdT9huxbPdSNa5B59IXc0Nluaws1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4Wg3jVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4Wg3jVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6592C4CECF;
	Tue,  3 Dec 2024 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241202;
	bh=nmkRZY21Ni+3miFmnql1q8z4+eZpLH2L4bw2jBWBlN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4Wg3jVCIhaR8KTRV1pk8w3112sebpfZu3OhlLuvgYSMvCuaUVaX+eeSA75odKasZ
	 PKV4Eg5lU5hIsGAeg8nCIKzhzOddn0DI6ndKZHGnj3DnHI5Dt1OkYHc59SgrnjZyG8
	 XRFqFMYmRdhaiqRkaT1f/HchzAoHFpnkojq0w8MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/826] wireguard: selftests: load nf_conntrack if not present
Date: Tue,  3 Dec 2024 15:41:22 +0100
Message-ID: <20241203144757.609278010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0290abc9860917f1ee8b58309c2bbd740a39ee8e ]

Some distros may not load nf_conntrack by default, which will cause
subsequent nf_conntrack sets to fail. Load this module if it is not
already loaded.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
[ Jason: add [[ -e ... ]] check so this works in the qemu harness. ]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20241117212030.629159-4-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/netns.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 405ff262ca93d..55500f901fbc3 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -332,6 +332,7 @@ waitiface $netns1 vethc
 waitiface $netns2 veths
 
 n0 bash -c 'printf 1 > /proc/sys/net/ipv4/ip_forward'
+[[ -e /proc/sys/net/netfilter/nf_conntrack_udp_timeout ]] || modprobe nf_conntrack
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout'
 n0 bash -c 'printf 2 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream'
 n0 iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -d 10.0.0.0/24 -j SNAT --to 10.0.0.1
-- 
2.43.0



