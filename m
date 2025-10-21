Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF80925A355;
	Tue, 21 Oct 2025 20:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077367; cv=none; b=CEEUqAIps9raJzSBevo8qhUwKAjWuRbg34Lu2IMnq3iOmIn3eWsjWuVWrtgczeo5k3LdkHycQqj4Z/dC7Awggs9Fubr3XYivVxYgTPDIzhSMLL6XPkUvsIQ2x1dXi7I8aKBvYWVQjBhnSWOhhyZDGpPo+WDF5iOlR+F9yvJYCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077367; c=relaxed/simple;
	bh=Bu9SRkgzDP0RaQTOtzJfO2q56qRzEjJZwogK+WTvZAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpAeTJ4+X+17NPzQQmF+7Lj42UxXeadzTsyGvEcyK1w60Dm/aH+hp3kn8OZmsBBXJyuMdq/QhzIuAT2mB67Aq2CURa2rPx8i1Y/DsMzeZ8iZ7Z6ktH9eVHLqQcO8FHKd0FgFsaIE0UBt/KR3Sr56pK3GyySexMxH3Dn55yGzLqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+gNFij2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+gNFij2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FA3C4CEF1;
	Tue, 21 Oct 2025 20:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077367;
	bh=Bu9SRkgzDP0RaQTOtzJfO2q56qRzEjJZwogK+WTvZAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+gNFij2VNS4MuQ1MbJ4uPB/5oK4sgKk0Eds3bYEji1I1NQu/U6w9OvtWCyCfMxGS
	 T2SFsLotZqoZjfBclIfFHKaAUFUCbrLDQg2FdQbYy3E9miPqRvujdMQ40XRL72sacu
	 Syg1OnP4g/D8zEzSTpINzKbNGiv3EjNHZO81Zgyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 081/159] selftests: net: check jq command is supported
Date: Tue, 21 Oct 2025 21:50:58 +0200
Message-ID: <20251021195045.144830414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 4f86eb0a38bc719ba966f155071a6f0594327f34 ]

The jq command is used in vlan_bridge_binding.sh, if it is not supported,
the test will spam the following log.

  # ./vlan_bridge_binding.sh: line 51: jq: command not found
  # ./vlan_bridge_binding.sh: line 51: jq: command not found
  # ./vlan_bridge_binding.sh: line 51: jq: command not found
  # ./vlan_bridge_binding.sh: line 51: jq: command not found
  # ./vlan_bridge_binding.sh: line 51: jq: command not found
  # TEST: Test bridge_binding on->off when lower down                   [FAIL]
  #       Got operstate of , expected 0

The rtnetlink.sh has the same problem. It makes sense to check if jq is
installed before running these tests. After this patch, the
vlan_bridge_binding.sh skipped if jq is not supported:

  # timeout set to 3600
  # selftests: net: vlan_bridge_binding.sh
  # TEST: jq not installed                                              [SKIP]

Fixes: dca12e9ab760 ("selftests: net: Add a VLAN bridge binding selftest")
Fixes: 6a414fd77f61 ("selftests: rtnetlink: Add an address proto test")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251013080039.3035898-1-wangliang74@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh           | 2 ++
 tools/testing/selftests/net/vlan_bridge_binding.sh | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index d6c00efeb6642..281758e407888 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1453,6 +1453,8 @@ usage: ${0##*/} OPTS
 EOF
 }
 
+require_command jq
+
 #check for needed privileges
 if [ "$(id -u)" -ne 0 ];then
 	end_test "SKIP: Need root privileges"
diff --git a/tools/testing/selftests/net/vlan_bridge_binding.sh b/tools/testing/selftests/net/vlan_bridge_binding.sh
index e7cb8c678bdee..fe5472d844243 100755
--- a/tools/testing/selftests/net/vlan_bridge_binding.sh
+++ b/tools/testing/selftests/net/vlan_bridge_binding.sh
@@ -249,6 +249,8 @@ test_binding_toggle_off_when_upper_down()
 	do_test_binding_off : "on->off when upper down"
 }
 
+require_command jq
+
 trap defer_scopes_cleanup EXIT
 setup_prepare
 tests_run
-- 
2.51.0



