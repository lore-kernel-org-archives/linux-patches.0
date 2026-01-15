Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812A14C81;
	Thu, 15 Jan 2026 17:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498628; cv=none; b=oUi/jc/V2+Aq7HmX5h6fg6ee+QbxUfqZ1BqCML8VPMAvkluWIsSvqubF27Zak6wnHosKxns+/iyvJ273e1KM0FK84mrMNdUpVmO25hL2eOIMHq/H3CkqjiLaF1qkZo89YJRPesAE62+yHCZECjHzZIh29NUGUznC0VB0FpMeQ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498628; c=relaxed/simple;
	bh=udkqfgxTfj5TWr2TSjY7HzjPWnsCaeX8qAvohlGKdzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4thlu7EaoexpiV+gFvoCFOGb/yCIm/WIEY9NTc/kWAOAxK4qCUOt9QnYVIJe2M0YM1bl9pRtjHl/lDrjn6A0A/BwLua9zvsBIpxGKzVTlUyEvJnS+ObHodXa3vKVQiJ15TvypJ4lghF7n4/bCRvYXfZXBOd4vo7oN9+0JTB4+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG5fJTT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG5fJTT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100CDC116D0;
	Thu, 15 Jan 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498628;
	bh=udkqfgxTfj5TWr2TSjY7HzjPWnsCaeX8qAvohlGKdzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG5fJTT5pZaUrZpfCn6//4f7zDKuFfR+5r3RXybFuL3NUruB8U+jNIrthhlMfPUJ+
	 gXQwdy8KGfAbmhWkP/2jX8HgSIvjEuDGrz18/tUGVPzHGSrHbhc7Tax/ypD2TNrlG0
	 QDPEH5WVMXRCUAd9ji4soQswDWbHtQnRPkChsAkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Cao Jiaqiang <caojiaqiang@huawei.com>
Subject: [PATCH 5.15 491/554] selftests: net: test_vxlan_under_vrf: fix HV connectivity test
Date: Thu, 15 Jan 2026 17:49:17 +0100
Message-ID: <20260115164304.089353286@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit e7e4785fa30f9b5d1b60ed2d8e221891325dfc5f ]

It looks like test_vxlan_under_vrf.sh is always failing to verify the
connectivity test during the ping between the two simulated VMs.

This is due to the fact that veth-hv in each VM should have a distinct
MAC address.

Fix by setting a unique MAC address on each simulated VM interface.

Without this fix:

 $ sudo ./tools/testing/selftests/net/test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [FAIL]

With this fix applied:

 $ sudo ./tools/testing/selftests/net/test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
 Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]

NOTE: the connectivity test with the underlay VRF is still failing; it
seems that ARP requests are blocked at the simulated hypervisor level,
probably due to some missing ARP forwarding rules. This requires more
investigation (in the meantime we may consider to set that test as
expected failure - XFAIL).

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Cao Jiaqiang <caojiaqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/test_vxlan_under_vrf.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/test_vxlan_under_vrf.sh
+++ b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
@@ -101,6 +101,8 @@ setup-vm() {
     ip -netns hv-$id link set veth-tap master br0
     ip -netns hv-$id link set veth-tap up
 
+    ip link set veth-hv address 02:1d:8d:dd:0c:6$id
+
     ip link set veth-hv netns vm-$id
     ip -netns vm-$id addr add 10.0.0.$id/24 dev veth-hv
     ip -netns vm-$id link set veth-hv up


