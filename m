Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6B9377A9A;
	Sat, 12 Sep 2026 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203724; cv=none; b=mCVY5I4a63ik/NLYTSfpRVD00mS4rbt1Mj+hW2sOXU7k9g64avsuEIfdXJPDQ1qPA9NZ2cJ36uSNfUn64kHjNiuRPFMdR+D7o/Jqta1mEvEgrlr+ooHhUhe/cL2NSPCLDB92xhPTJq0CKqqzsZD0rKP9UZb6WyLSCDwrkpG0lWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203724; c=relaxed/simple;
	bh=bNRWYe+zAAKIaoyTJ7xdoGIlnns+EXtZhLchS6Hci6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wf8h22hzh47pYnAifC+T2xkjkzaGuv7r5X1L2tzjL3SlrMbrZzbyadLtv1OLJ+S919fDrOBm3GDTuzlpiOAkah4uqFt6LWQf1Y6fkWO2IxWVcHesmUokhXwBYLtq4WiJLW00Pyv3CcD/vXwL0jaJvLBgGZI/pJ+xk2vbUEpz8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmOHnxuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmOHnxuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7731F000FF;
	Sat, 12 Sep 2026 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203723;
	bh=bjvUSWST9eGDJeSYiIwQSb4n4xiON5GmI0JpU7RR1oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmOHnxucNC7KZR99AZzw9fX7Kmpv55CFJBXAOl8F+KsKvsMAk7Pi5UDKtI1Q3Nsi2
	 3K/WPhiv/w3yy/JCYJIMQRG9Ke7mnlkV3Ov/FK0Iu1tePaTHu6HYcfSFu3i6IiUXVU
	 twMuI5cZ1f2/46Pi5E9y9EwsDLRF1zQvGoL+TtY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1423/1815] selftests: drv-net: so_txtime: fix qdisc replace with handle
Date: Sat, 12 Sep 2026 08:52:53 +0200
Message-ID: <20260912065722.424753266@linuxfoundation.org>
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

[ Upstream commit dbf34acdfb29781dd4a8a86f7111d99c016fc7e8 ]

The blamed commit updated a tc replace command by adding a handle.

  -    tc(f"qdisc replace dev {ifname} root {qdisc} {optargs}")
  +    tc(f"qdisc replace dev {ifname} root handle 1: {qdisc} {optargs}")

This breaks the test if the root qdisc already has that handle and is of
different kind, with

  "Invalid qdisc name: must match existing qdisc."

If no handle is asked, or the kind differs, tc replace removes the old
qdisc and grafts a new one.

If a handle is asked and exists, tc replace tries to change the qdisc
in place, for which the kind must be the same.

It does not trigger in all setups, like netdevsim or debian 13, which
do not have root handle 1:. But it is a common root handle.

Solve the bug by first deleting the existing root qdisc if one exists.

Wrap that command in a try block, because it will fail for default
qdiscs with handle 0: with

  "Error: Cannot delete qdisc with handle of zero."

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260810183118.32d5c06a@kernel.org/
Fixes: ef3d6cca02c8 ("selftests: drv-net: so_txtime: only send test traffic to sch_etf")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260811182856.2702163-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/so_txtime.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/so_txtime.py b/tools/testing/selftests/drivers/net/so_txtime.py
index 9fbc0278d28bc..a097fae0b335a 100755
--- a/tools/testing/selftests/drivers/net/so_txtime.py
+++ b/tools/testing/selftests/drivers/net/so_txtime.py
@@ -12,6 +12,7 @@ import time
 from lib.py import ksft_exit, ksft_run, ksft_variants
 from lib.py import KsftNamedVariant, KsftSkipEx
 from lib.py import NetDrvEpEnv, bkg, cmd, defer, tc
+from lib.py import CmdExitFailure
 
 
 def test_so_txtime(cfg, clockid, ipver, args_tx, args_rx, expect_success):
@@ -45,6 +46,10 @@ def _qdisc_setup(ifname, qdisc, optargs=""):
     """
     orig = tc(f"qdisc show dev {ifname} root", json=True)[0].get("kind", None)
     defer(tc, f"qdisc replace dev {ifname} root {orig}")
+    try:
+        tc(f"qdisc del dev {ifname} root")
+    except CmdExitFailure:
+        pass
     tc(f"qdisc replace dev {ifname} root handle 1: {qdisc} {optargs}")
 
 
-- 
2.53.0



