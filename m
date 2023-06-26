Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AD134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E918C433C8;
	Mon, 26 Jun 2023 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803682;
	bh=Y3dU+evQdbvEAfFTbXaCTSTe3vJeJZBHTQG3j2EQOtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZbtPfr4muyYP0FtSDYOw+PSlDiTKQoT/xL18R8dHTy+nuqVjaWvIAJmwu1z4OT4B
	 H4E6Gb4BJ6/GOOHx+MfdRzSshr61oQ6yDvFUht0xzzjjumhVj2uvBl6pj/GfI+8AIQ
	 VNVMVjtUVIro1Ma5pvc8zMe9AbVyk370K/y+i0S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 141/199] selftests: forwarding: Fix race condition in mirror installation
Date: Mon, 26 Jun 2023 20:10:47 +0200
Message-ID: <20230626180811.788715170@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit c7c059fba6fb19c3bc924925c984772e733cb594 ]

When mirroring to a gretap in hardware the device expects to be
programmed with the egress port and all the encapsulating headers. This
requires the driver to resolve the path the packet will take in the
software data path and program the device accordingly.

If the path cannot be resolved (in this case because of an unresolved
neighbor), then mirror installation fails until the path is resolved.
This results in a race that causes the test to sometimes fail.

Fix this by setting the neighbor's state to permanent in a couple of
tests, so that it is always valid.

Fixes: 35c31d5c323f ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1d")
Fixes: 239e754af854 ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1q")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/268816ac729cb6028c7a34d4dda6f4ec7af55333.1687264607.git.petrm@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh  | 4 ++++
 .../testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
index c5095da7f6bf8..aec752a22e9ec 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
@@ -93,12 +93,16 @@ cleanup()
 
 test_gretap()
 {
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		 nud permanent dev br2
 	full_test_span_gre_dir gt4 ingress 8 0 "mirror to gretap"
 	full_test_span_gre_dir gt4 egress 0 8 "mirror to gretap"
 }
 
 test_ip6gretap()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_dir gt6 ingress 8 0 "mirror to ip6gretap"
 	full_test_span_gre_dir gt6 egress 0 8 "mirror to ip6gretap"
 }
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
index 9ff22f28032dd..0cf4c47a46f9b 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
@@ -90,12 +90,16 @@ cleanup()
 
 test_gretap()
 {
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		 nud permanent dev br1
 	full_test_span_gre_dir gt4 ingress 8 0 "mirror to gretap"
 	full_test_span_gre_dir gt4 egress 0 8 "mirror to gretap"
 }
 
 test_ip6gretap()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br1
 	full_test_span_gre_dir gt6 ingress 8 0 "mirror to ip6gretap"
 	full_test_span_gre_dir gt6 egress 0 8 "mirror to ip6gretap"
 }
-- 
2.39.2



