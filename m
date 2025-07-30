Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D3F2641F9;
	Wed, 30 Jul 2025 09:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869235; cv=none; b=VoAgEiwSHlvtYFMYxCHZeiTzWIhx/AtPGwDyqflVOF67aRU3xcWcoNHENmPIQ83R96ccCnOCXC5j6C4RYRS4BQfwX9Ynezu3ubsP8EJACVQ7GmGmSG4ssll67IQZ4PlNvXBJqZj/8u+1YNvHzHCTDJVSkLYxWsF/48b/mWCqyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869235; c=relaxed/simple;
	bh=ptamTgDw4GP4dVo4bDC1yxpuVRIl67Gd07Ez7yJhhGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKU/TCg8mSSxXTsu5tFBwU/jnf4oTPsa44ZkTSSHYezMv4BpL8gxW53h7CbY06HEpcPXCtPv4vDhQVyPXF9ZWauraLNv+SIgly8T9F5oNlkApod7gLX+wmRaKiDit/PsmxX8TKsorZz5WXrjCDVIkIxzhtb756Zfap+1hjTsM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOUhTc5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOUhTc5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D96C4CEF5;
	Wed, 30 Jul 2025 09:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869235;
	bh=ptamTgDw4GP4dVo4bDC1yxpuVRIl67Gd07Ez7yJhhGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOUhTc5cd9CX1+Zl78Wlu63VYgnFwXHC4cZQfobDEXkjmVgMJrpM3wL5tIvjKpgbu
	 r7HpOOCHMeNMO6WsOQoqS+n73ZiDlELf825M2gV5bpj0GgyZwUa0oPKYE0sbH/bTol
	 Sckr7DpRMhZLyhWvEuJ5ARxPmuNg0PqsH1nyRUlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 37/92] selftests: drv-net: wait for iperf client to stop sending
Date: Wed, 30 Jul 2025 11:35:45 +0200
Message-ID: <20250730093232.187380646@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nimrod Oren <noren@nvidia.com>

[ Upstream commit 86941382508850d58c11bdafe0fec646dfd31b09 ]

A few packets may still be sent out during the termination of iperf
processes. These late packets cause failures in rss_ctx.py when they
arrive on queues expected to be empty.

Example failure observed:

  Check failed 2 != 0 traffic on inactive queues (context 1):
    [0, 0, 1, 1, 386385, 397196, 0, 0, 0, 0, ...]

  Check failed 4 != 0 traffic on inactive queues (context 2):
    [0, 0, 0, 0, 2, 2, 247152, 253013, 0, 0, ...]

  Check failed 2 != 0 traffic on inactive queues (context 3):
    [0, 0, 0, 0, 0, 0, 1, 1, 282434, 283070, ...]

To avoid such failures, wait until all client sockets for the requested
port are either closed or in the TIME_WAIT state.

Fixes: 847aa551fa78 ("selftests: drv-net: rss_ctx: factor out send traffic and check")
Signed-off-by: Nimrod Oren <noren@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722122655.3194442-1-noren@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/lib/py/load.py      | 23 +++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/lib/py/load.py b/tools/testing/selftests/drivers/net/lib/py/load.py
index da5af2c680faa..1a9d57c3efa3c 100644
--- a/tools/testing/selftests/drivers/net/lib/py/load.py
+++ b/tools/testing/selftests/drivers/net/lib/py/load.py
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
+import re
 import time
 
 from lib.py import ksft_pr, cmd, ip, rand_port, wait_port_listen, bkg
@@ -10,12 +11,11 @@ class GenerateTraffic:
 
         self.env = env
 
-        if port is None:
-            port = rand_port()
-        self._iperf_server = cmd(f"iperf3 -s -1 -p {port}", background=True)
-        wait_port_listen(port)
+        self.port = rand_port() if port is None else port
+        self._iperf_server = cmd(f"iperf3 -s -1 -p {self.port}", background=True)
+        wait_port_listen(self.port)
         time.sleep(0.1)
-        self._iperf_client = cmd(f"iperf3 -c {env.addr} -P 16 -p {port} -t 86400",
+        self._iperf_client = cmd(f"iperf3 -c {env.addr} -P 16 -p {self.port} -t 86400",
                                  background=True, host=env.remote)
 
         # Wait for traffic to ramp up
@@ -74,3 +74,16 @@ class GenerateTraffic:
             ksft_pr(">> Server:")
             ksft_pr(self._iperf_server.stdout)
             ksft_pr(self._iperf_server.stderr)
+        self._wait_client_stopped()
+
+    def _wait_client_stopped(self, sleep=0.005, timeout=5):
+        end = time.monotonic() + timeout
+
+        live_port_pattern = re.compile(fr":{self.port:04X} 0[^6] ")
+
+        while time.monotonic() < end:
+            data = cmd("cat /proc/net/tcp*", host=self.env.remote).stdout
+            if not live_port_pattern.search(data):
+                return
+            time.sleep(sleep)
+        raise Exception(f"Waiting for client to stop timed out after {timeout}s")
-- 
2.39.5



