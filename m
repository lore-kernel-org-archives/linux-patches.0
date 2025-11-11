Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B533C534;
	Tue, 11 Nov 2025 01:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823445; cv=none; b=j0TgA7rqI9BMJpOvhgZTkFk44z7tMqQC9PgvDHfKn75Ti2iUH7agQAtVPYIjiwTB+YCkCilamI25SXjaJtx8kF3cP8g3b15BO4vJ50Jh0PuCTrFjv0sHzv6veTiYZe/ggj3OWU4fCGAQNzFPIqHC48OAYujvcINuytXfKdupzk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823445; c=relaxed/simple;
	bh=a91f+aArc4U9DM2pp+Pu/HkBf5yF56upsSx5u0nT7GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf4SRMT0uujTzvYJssmI+ANMTJ1uJDITn3s77Sfu4O7qR6ZkD/zakzalMqeTIZg3n5AYulldcJumTUvtpHWKcabGenPE6MX6RXIKK9c61vx2/1ehzEGafJO/GvCN0vy768ta/GQvfCp8I7UE3w3ogumlVpyjzf3wil8Jrby2avo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfhPJQ36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfhPJQ36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB83C116B1;
	Tue, 11 Nov 2025 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823444;
	bh=a91f+aArc4U9DM2pp+Pu/HkBf5yF56upsSx5u0nT7GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfhPJQ366otiGijETxhu+6PmCbqu0By8P0jzV2uiS4nTmWNhr9zYCREvqOjmcoFRX
	 zJ8i1wBPLcLKFE+tXxKmzXPdp557KGjCHtTQecSAfGYlto9LuwPyibApcToOAyRl8R
	 UWoUQTl3bQ7xib+DCNOHhR/1ADqRCtruG5RY/JUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 301/849] selftests: drv-net: wait for carrier
Date: Tue, 11 Nov 2025 09:37:51 +0900
Message-ID: <20251111004543.686694523@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f09fc24dd9a5ec989dfdde7090624924ede6ddc7 ]

On fast machines the tests run in quick succession so even
when tests clean up after themselves the carrier may need
some time to come back.

Specifically in NIPA when ping.py runs right after netpoll_basic.py
the first ping command fails.

Since the context manager callbacks are now common NetDrvEpEnv
gets an ip link up call as well.

Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20250812142054.750282-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/lib/py/__init__.py  |  2 +-
 .../selftests/drivers/net/lib/py/env.py       | 41 +++++++++----------
 tools/testing/selftests/net/lib/py/utils.py   | 18 ++++++++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/lib/py/__init__.py b/tools/testing/selftests/drivers/net/lib/py/__init__.py
index 8711c67ad658a..a07b56a75c8a6 100644
--- a/tools/testing/selftests/drivers/net/lib/py/__init__.py
+++ b/tools/testing/selftests/drivers/net/lib/py/__init__.py
@@ -15,7 +15,7 @@ try:
         NlError, RtnlFamily, DevlinkFamily
     from net.lib.py import CmdExitFailure
     from net.lib.py import bkg, cmd, bpftool, bpftrace, defer, ethtool, \
-        fd_read_timeout, ip, rand_port, tool, wait_port_listen
+        fd_read_timeout, ip, rand_port, tool, wait_port_listen, wait_file
     from net.lib.py import fd_read_timeout
     from net.lib.py import KsftSkipEx, KsftFailEx, KsftXfailEx
     from net.lib.py import ksft_disruptive, ksft_exit, ksft_pr, ksft_run, \
diff --git a/tools/testing/selftests/drivers/net/lib/py/env.py b/tools/testing/selftests/drivers/net/lib/py/env.py
index 1b8bd648048f7..c1f3b608c6d8f 100644
--- a/tools/testing/selftests/drivers/net/lib/py/env.py
+++ b/tools/testing/selftests/drivers/net/lib/py/env.py
@@ -4,7 +4,7 @@ import os
 import time
 from pathlib import Path
 from lib.py import KsftSkipEx, KsftXfailEx
-from lib.py import ksft_setup
+from lib.py import ksft_setup, wait_file
 from lib.py import cmd, ethtool, ip, CmdExitFailure
 from lib.py import NetNS, NetdevSimDev
 from .remote import Remote
@@ -25,6 +25,9 @@ class NetDrvEnvBase:
 
         self.env = self._load_env_file()
 
+        # Following attrs must be set be inheriting classes
+        self.dev = None
+
     def _load_env_file(self):
         env = os.environ.copy()
 
@@ -48,6 +51,22 @@ class NetDrvEnvBase:
                 env[pair[0]] = pair[1]
         return ksft_setup(env)
 
+    def __del__(self):
+        pass
+
+    def __enter__(self):
+        ip(f"link set dev {self.dev['ifname']} up")
+        wait_file(f"/sys/class/net/{self.dev['ifname']}/carrier",
+                  lambda x: x.strip() == "1")
+
+        return self
+
+    def __exit__(self, ex_type, ex_value, ex_tb):
+        """
+        __exit__ gets called at the end of a "with" block.
+        """
+        self.__del__()
+
 
 class NetDrvEnv(NetDrvEnvBase):
     """
@@ -72,17 +91,6 @@ class NetDrvEnv(NetDrvEnvBase):
         self.ifname = self.dev['ifname']
         self.ifindex = self.dev['ifindex']
 
-    def __enter__(self):
-        ip(f"link set dev {self.dev['ifname']} up")
-
-        return self
-
-    def __exit__(self, ex_type, ex_value, ex_tb):
-        """
-        __exit__ gets called at the end of a "with" block.
-        """
-        self.__del__()
-
     def __del__(self):
         if self._ns:
             self._ns.remove()
@@ -219,15 +227,6 @@ class NetDrvEpEnv(NetDrvEnvBase):
             raise Exception("Can't resolve remote interface name, multiple interfaces match")
         return v6[0]["ifname"] if v6 else v4[0]["ifname"]
 
-    def __enter__(self):
-        return self
-
-    def __exit__(self, ex_type, ex_value, ex_tb):
-        """
-        __exit__ gets called at the end of a "with" block.
-        """
-        self.__del__()
-
     def __del__(self):
         if self._ns:
             self._ns.remove()
diff --git a/tools/testing/selftests/net/lib/py/utils.py b/tools/testing/selftests/net/lib/py/utils.py
index f395c90fb0f19..c42bffea0d879 100644
--- a/tools/testing/selftests/net/lib/py/utils.py
+++ b/tools/testing/selftests/net/lib/py/utils.py
@@ -249,3 +249,21 @@ def wait_port_listen(port, proto="tcp", ns=None, host=None, sleep=0.005, deadlin
         if time.monotonic() > end:
             raise Exception("Waiting for port listen timed out")
         time.sleep(sleep)
+
+
+def wait_file(fname, test_fn, sleep=0.005, deadline=5, encoding='utf-8'):
+    """
+    Wait for file contents on the local system to satisfy a condition.
+    test_fn() should take one argument (file contents) and return whether
+    condition is met.
+    """
+    end = time.monotonic() + deadline
+
+    with open(fname, "r", encoding=encoding) as fp:
+        while True:
+            if test_fn(fp.read()):
+                break
+            fp.seek(0)
+            if time.monotonic() > end:
+                raise TimeoutError("Wait for file contents failed", fname)
+            time.sleep(sleep)
-- 
2.51.0



