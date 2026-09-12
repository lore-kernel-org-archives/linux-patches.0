Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8740344DB5;
	Sat, 12 Sep 2026 08:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203226; cv=none; b=lrHMp+iLMLjDZOvVbrehVpMztIoCF9bcRj5zrbAvCnIyvwG9OzT1cFVxnURGRhHFGNSkF7jPdiiG00gVyAPbbkjkV8T80vYzCHY3yguCI0b054MJ8FXSl4/ywO8iKc4SaEN2FZf3LLvM9HFzyN/1Hj8LaGZgHi54Dh7Ck9R4Doc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203226; c=relaxed/simple;
	bh=H7CWkHhXD2nVcrJ/G4ncDN90snrUcs9t7k4kDvmbLoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq/TFI/K5PlkRjxr+u5TWA0s/V38vOPrUDqyEfPaKSFViCwbo4XSJG6SenFG+TRWQ2R0g2Fuh4AbnVPttg2qaS28bDAEM3T+evEEI8kmPBp4HBMvvrIikPmtpfdiFkpREgK8WAFE681Vl8KodKanl7Lmc3farLFzr1VO1ZSfJLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPf62TEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPf62TEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFDA1F000FF;
	Sat, 12 Sep 2026 08:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203225;
	bh=pxC2c+t7Z4j1jzGr7eLlkGCgSAkh7SEgs5RLkRDn0/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPf62TELXoIEdT13KSNmx1wOFDb6WRIB6pQkoqtavtENdiV7ntwHV0Svxe759vRWx
	 aqblwxFxVTcA1ZaRqJUtpUbCHTjTXkiOZDwBiCeBvK4vP/32U2qL7yy+XoNktdlTyC
	 LXmpt6KXcMpJfufz1INkLxFO7KDVcqqN81df43ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1328/1815] selftests: drv-net: so_txtime: only send test traffic to sch_etf
Date: Sat, 12 Sep 2026 08:51:18 +0200
Message-ID: <20260912065720.200412964@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit ef3d6cca02c8a7b6465fb1691823524b86d1cb99 ]

The ETF qdiscs drops traffic without a socket or txtime. Even with
parameter skip_sock_check regular traffic is affected by ETF.

This test ran fine when run manually in a pure software environment.
But with drv-net across two hosts tests fail as early as when calling
cfg.remote.deploy due to effectively losing connectivity.

Isolate the intended test traffic:
- mark that with SO_MARK 100
- install a regular permissive root prio qdisc for background traffic
- install the ETF qdisc as leaf
- install a filter that only directs SO_MARK 100 traffic to this leaf

Technically other high prio traffic will map onto this leaf based on
ToS band mapping too. But that is immaterial in practice.

Fixes: 5c6baef3885c ("selftests: drv-net: convert so_txtime to drv-net")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260808160129.890119-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/config       |  2 ++
 tools/testing/selftests/drivers/net/so_txtime.py | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/config b/tools/testing/selftests/drivers/net/config
index f3933cf3e6be6..b6989c7d3d9d1 100644
--- a/tools/testing/selftests/drivers/net/config
+++ b/tools/testing/selftests/drivers/net/config
@@ -8,6 +8,7 @@ CONFIG_NET_ACT_SKBEDIT=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_CLS_BPF=y
 CONFIG_NET_CLS_FLOWER=m
+CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_MATCHALL=m
 CONFIG_NETCONSOLE=m
 CONFIG_NETCONSOLE_DYNAMIC=y
@@ -17,6 +18,7 @@ CONFIG_NETKIT=y
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_INGRESS=y
+CONFIG_NET_SCH_PRIO=m
 CONFIG_PPP=y
 CONFIG_PPPOE=y
 CONFIG_VLAN_8021Q=m
diff --git a/tools/testing/selftests/drivers/net/so_txtime.py b/tools/testing/selftests/drivers/net/so_txtime.py
index adf6c848d6d80..9fbc0278d28bc 100755
--- a/tools/testing/selftests/drivers/net/so_txtime.py
+++ b/tools/testing/selftests/drivers/net/so_txtime.py
@@ -27,7 +27,7 @@ def test_so_txtime(cfg, clockid, ipver, args_tx, args_rx, expect_success):
     cmd_addr = f"-S {cfg.addr_v[ipver]} -D {cfg.remote_addr_v[ipver]}"
     cmd_args = f"-{ipver} -c {clockid} -t {tstart} {cmd_addr}"
     cmd_rx = f"{cfg.bin_remote} {cmd_args} {args_rx} -r"
-    cmd_tx = f"{cfg.bin_local} {cmd_args} {args_tx}"
+    cmd_tx = f"{cfg.bin_local} -m 100 {cmd_args} {args_tx}"
 
     expect_fail = not expect_success
     if slow_machine:
@@ -45,7 +45,7 @@ def _qdisc_setup(ifname, qdisc, optargs=""):
     """
     orig = tc(f"qdisc show dev {ifname} root", json=True)[0].get("kind", None)
     defer(tc, f"qdisc replace dev {ifname} root {orig}")
-    tc(f"qdisc replace dev {ifname} root {qdisc} {optargs}")
+    tc(f"qdisc replace dev {ifname} root handle 1: {qdisc} {optargs}")
 
 
 def _test_variants_fq():
@@ -96,11 +96,21 @@ def _test_variants_etf():
 def test_so_txtime_etf(cfg, ipver, args_tx, args_rx, expect_fail):
     """Run all variants of etf tests."""
     cfg.require_ipver(ipver)
+
+    # root qdisc for background traffic (e.g., bkg())
+    _qdisc_setup(cfg.ifname, "prio")
+
+    # leaf ETF qdisc only for intended packets
     try:
-        _qdisc_setup(cfg.ifname, "etf", "clockid CLOCK_TAI delta 400000")
+        etf_args = "clockid CLOCK_TAI delta 400000"
+        tc(f"qdisc add dev {cfg.ifname} parent 1:1 handle 10: etf {etf_args}")
     except Exception as e:
         raise KsftSkipEx("tc does not support qdisc etf. skipping") from e
 
+    # redirect mark 100 to leaf
+    filter_args = "protocol all handle 100 fw flowid 1:1"
+    tc(f"filter add dev {cfg.ifname} parent 1: {filter_args}")
+
     test_so_txtime(cfg, "tai", ipver, args_tx, args_rx, expect_fail)
 
 
-- 
2.53.0



