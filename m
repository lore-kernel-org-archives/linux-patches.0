Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6B8248881;
	Wed, 25 Feb 2026 01:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983561; cv=none; b=UrP71XYlVKjWcSZvNUoliSKxffsuKaqr1jZiJ5NJ30anUBnYIwibrAE1XL2l2SlRlthkMnK9uTpZVF9bRLeNvNoNnDxt3irHaS5z/CrcoTNPHgKAgDMBHQpRM5B1jR9PdNJNtsXHX+QPwH5kGeVdTaMQHabwgFfyASvyTD7E1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983561; c=relaxed/simple;
	bh=yYE1GBjqm3Xc9trLzLK0U/lUANM9Sqdm0O91oPNGKuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmwPNijaUtByXXU1wK78bm1zhJjEb0At5k7Ab8GxA9yqP7d1eza1uYEq0ont5KjUPL2BVz3ra4mcj5LQKCX3EAmB/oC97K+4lrljSx8gBL1wJT1nkj0oVkkacmy5fwfVnD/tc0KYUUaqS7sTO50jKIkf4SpRKy3FIUzGVuznnH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ10iv/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ10iv/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1926AC19423;
	Wed, 25 Feb 2026 01:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983561;
	bh=yYE1GBjqm3Xc9trLzLK0U/lUANM9Sqdm0O91oPNGKuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ10iv/vDLy+LpEGj9I3RuPpgcqLiRCTkrtl64z0zcZGuqjWWivAOCLdVkppHnrxG
	 4q4QLu8uuxDpy0izw1O+tCzv0ssrOKQ2ypNykcPZzfkTZd5Wwghhu7wxV2oZ3PV87J
	 i7muH0bvOcQdx5kb4Avt8W8jpIBfd68vSv4sbMjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Oladko <aleksey.oladko@virtuozzo.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 660/781] selftests: forwarding: fix pedit tests failure with br_netfilter enabled
Date: Tue, 24 Feb 2026 17:22:49 -0800
Message-ID: <20260225012415.975168675@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>

[ Upstream commit a8c198d16c64cdf57f481a4cd3e769502802369e ]

The tests use the tc pedit action to modify the IPv4 source address
("pedit ex munge ip src set"), but the IP header checksum is not
recalculated after the modification. As a result, the modified packet
fails sanity checks in br_netfilter after bridging and is dropped,
which causes the test to fail.

Fix this by ensuring net.bridge.bridge-nf-call-iptables is set to 0
during the test execution. This prevents the bridge from passing
L2 traffic to netfilter, bypassing the checksum validation that
causes the test failure.

Fixes: 92ad3828944e ("selftests: forwarding: Add a test for pedit munge SIP and DIP")
Fixes: 226657ba2389 ("selftests: forwarding: Add a forwarding test for pedit munge dsfield")
Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260213131907.43351-4-aleksey.oladko@virtuozzo.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh | 8 ++++++++
 tools/testing/selftests/net/forwarding/pedit_ip.sh      | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index af008fbf2725e..eb2d8034de9c7 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -98,12 +98,20 @@ setup_prepare()
 	h1_create
 	h2_create
 	switch_create
+
+	if [ -f /proc/sys/net/bridge/bridge-nf-call-iptables ]; then
+		sysctl_set net.bridge.bridge-nf-call-iptables 0
+	fi
 }
 
 cleanup()
 {
 	pre_cleanup
 
+	if [ -f /proc/sys/net/bridge/bridge-nf-call-iptables ]; then
+		sysctl_restore net.bridge.bridge-nf-call-iptables
+	fi
+
 	switch_destroy
 	h2_destroy
 	h1_destroy
diff --git a/tools/testing/selftests/net/forwarding/pedit_ip.sh b/tools/testing/selftests/net/forwarding/pedit_ip.sh
index d14efb2d23b2e..9235674627abd 100755
--- a/tools/testing/selftests/net/forwarding/pedit_ip.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_ip.sh
@@ -91,12 +91,20 @@ setup_prepare()
 	h1_create
 	h2_create
 	switch_create
+
+	if [ -f /proc/sys/net/bridge/bridge-nf-call-iptables ]; then
+		sysctl_set net.bridge.bridge-nf-call-iptables 0
+	fi
 }
 
 cleanup()
 {
 	pre_cleanup
 
+	if [ -f /proc/sys/net/bridge/bridge-nf-call-iptables ]; then
+		sysctl_restore net.bridge.bridge-nf-call-iptables
+	fi
+
 	switch_destroy
 	h2_destroy
 	h1_destroy
-- 
2.51.0



