Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7D913FE8
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A716C433C8;
	Thu, 24 Aug 2023 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897565;
	bh=B1vfCA72aIVK/fgKpRM9Kjb+pURmZHNJTaqcz9Gn9+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdvihBQvhphqE/Arg4eG9QsUSnbgLIRWjJgaqnm/wb9+GfRpszSDgeGKfPPcf2vOL
	 TYkJAj33vtDKonXBS58PzGoSWJfdUxbOoosCNmMb0a11gm6ai587Id5gmTyRTjqspw
	 fg49MV5y2s119nmqP72KB6LJOjuMzIOZ93oE/36E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/135] selftests: mirror_gre_changes: Tighten up the TTL test match
Date: Thu, 24 Aug 2023 19:09:16 +0200
Message-ID: <20230824170620.881402190@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 855067defa36b1f9effad8c219d9a85b655cf500 ]

This test verifies whether the encapsulated packets have the correct
configured TTL. It does so by sending ICMP packets through the test
topology and mirroring them to a gretap netdevice. On a busy host
however, more than just the test ICMP packets may end up flowing
through the topology, get mirrored, and counted. This leads to
potential spurious failures as the test observes much more mirrored
packets than the sent test packets, and assumes a bug.

Fix this by tightening up the mirror action match. Change it from
matchall to a flower classifier matching on ICMP packets specifically.

Fixes: 45315673e0c5 ("selftests: forwarding: Test changes in mirror-to-gretap")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/mirror_gre_changes.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
index 472bd023e2a5f..b501b366367f7 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
@@ -72,7 +72,8 @@ test_span_gre_ttl()
 
 	RET=0
 
-	mirror_install $swp1 ingress $tundev "matchall $tcflags"
+	mirror_install $swp1 ingress $tundev \
+		"prot ip flower $tcflags ip_prot icmp"
 	tc filter add dev $h3 ingress pref 77 prot $prot \
 		flower ip_ttl 50 action pass
 
-- 
2.40.1



