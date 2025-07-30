Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53A29344F;
	Wed, 30 Jul 2025 09:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868750; cv=none; b=gotcDr0P2hYA+u2eVomTiqzTRredChTmoPJEAr6anIBBzJExGJ6zHy/nyRocDY89ZwHGJzzpCXYGgv/Ri3dDE1n/JK3J/HOoqCbLr3eWg5dQMPCu2Wcu0NuRkpuyJPMIksy9IHSpVu2oOW+3QNGix7Wago8dHJqHL1bC4hbJhyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868750; c=relaxed/simple;
	bh=f4OuXCv6qC6D/hZSrDO3775/h7/rQ9hPY34FP/nxw1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqMkMOa0BM9Gi2RV4N3Y2J07sOwQMPUx8KgeC9l9QeT5lAA/adnbmT7Ugo843KoDXP9mIYo92UBAJHp1n1uwrOV6Qo+tTq6YA1cCld/CSTmoMBRYJ6L3AHMhESS0v5Ihh5KJJeQ6UC0euvtO9OI/Px436kaK7f2auTO6q/hLg40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPlLIj8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPlLIj8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB8C4CEF5;
	Wed, 30 Jul 2025 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868749;
	bh=f4OuXCv6qC6D/hZSrDO3775/h7/rQ9hPY34FP/nxw1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPlLIj8sQwIgnpM2pTtstnsQDeR2vNRMS1GMSnKUTgSeklfWQIL2ch3BKtAtCHVTm
	 4KbaLM6APt2ODB8RIAxEIJuXHruzZeC42Frrd+w0WzB5wNhhAM6IlLV+1QJPjY2DF/
	 goUOQv01EDo7fJvH4P3L8ZvvAFUAAulzEGz+jPL0=
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
Subject: [PATCH 6.12 033/117] selftests: drv-net: wait for iperf client to stop sending
Date: Wed, 30 Jul 2025 11:35:02 +0200
Message-ID: <20250730093234.845952272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d9c10613ae67b..44151b7b1a24b 100644
--- a/tools/testing/selftests/drivers/net/lib/py/load.py
+++ b/tools/testing/selftests/drivers/net/lib/py/load.py
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
+import re
 import time
 
 from lib.py import ksft_pr, cmd, ip, rand_port, wait_port_listen
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
@@ -56,3 +56,16 @@ class GenerateTraffic:
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



