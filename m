Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3012C43D502;
	Thu, 30 Jul 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423337; cv=none; b=okLX4es9t36BcGtYxplLM1MdbZ64UFDFxP/+0nOku11FhH1hXzbnNna8nwDZpTciu+H9Z7oWysA5aUhDl4fI/HOGH0op37yoq6ac3OSSJFP+iwr6itq6/7881DCp9IxIVw/axacPmWF7M+Kz5MvuIDHTbqQP4potmgs0kqecMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423337; c=relaxed/simple;
	bh=yXZx9ch3MaGoFzRQjuljnJB6UfvEtPprUdIl++kUuN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFdZoIwqEBLJ5c55ItjKJd0vGNc5ajTR+D9c46L65as8c+lFohxjHNuucy+ZTZwy5UvcbIgiZ4FvBVcp4L6tO3tcTqiWT20YYg0f8+vWASE7jX0BXxayft19zYFgVCSwgXQIMnKYYATMroYILDnMGxZQOv7PKAE0Yl2ULEIz/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTbHABFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTbHABFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FEF1F000E9;
	Thu, 30 Jul 2026 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423336;
	bh=JMX1Pn5D2n2TQlrgPCZE+3whXO8/rRJF5wgS4SeAw+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTbHABFeG5uHd/HsBTmbXpxS5aR1fvYqWyzQX/yitNN9wP7ZcXi6JCX9b9jA7VTny
	 WB59689wUsR1n+A6bPfDPimgeMP1Hnk0B7/TFujQ7iUqX5LIjCkUXEX3EAFT7Bw5fu
	 uq5vGLVkrww8bxSiIixQ1oI0tmkEs6k6gpKWByAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: [PATCH 7.1 742/744] selftests: drv-net: cope with slow env in so_txtime.py test
Date: Thu, 30 Jul 2026 16:16:55 +0200
Message-ID: <20260730141500.086073265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 543bdc1578cd380631558a884318551a0e9fdab2 upstream.

This test was converted from shell script to drv-net test.

The new version is flaky in dbg builds on the netdev.bots dashboard.
The previous shell script had more protections to avoid these. Added
in commit a7ee79b9c455 ("selftests: net: cope with slow env in
so_txtime.sh test").

Add the same overall protection:

- Suppress so_txtime process failure if KSFT_MACHINE_SLOW

Also relax two timeouts to reduce the number of process failures
themselves

- Increase SO_RCVTIMEO to 2 seconds
- Increase process start-up stabilization to 2 seconds

Delays were experimentally arrived at while running with vng
built with kernel/configs/debug.config

Fixes: 5c6baef3885c ("selftests: drv-net: convert so_txtime to drv-net")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260510174219.74aeee6d@kernel.org/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260511222138.2045551-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/net/so_txtime.c  |   10 ++++++++--
 tools/testing/selftests/drivers/net/so_txtime.py |   11 +++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/drivers/net/so_txtime.c
+++ b/tools/testing/selftests/drivers/net/so_txtime.c
@@ -38,6 +38,7 @@
 static int	cfg_clockid	= CLOCK_TAI;
 static uint16_t	cfg_port	= 8000;
 static int	cfg_variance_us	= 4000;
+static bool	cfg_machine_slow;
 static uint64_t	cfg_start_time_ns;
 static int	cfg_mark;
 static bool	cfg_rx;
@@ -142,7 +143,7 @@ static void do_recv_one(int fdr, struct
 
 	if (llabs(tstop - texpect) > cfg_variance_us) {
 		fprintf(stderr, "exceeds variance (%d us)\n", cfg_variance_us);
-		if (!getenv("KSFT_MACHINE_SLOW"))
+		if (!cfg_machine_slow)
 			errors++;
 	}
 }
@@ -263,7 +264,7 @@ static void start_time_wait(void)
 	now = gettime_ns(CLOCK_REALTIME);
 	if (cfg_start_time_ns < now) {
 		fprintf(stderr, "FAIL: start time already passed\n");
-		if (!getenv("KSFT_MACHINE_SLOW"))
+		if (!cfg_machine_slow)
 			errors++;
 		return;
 	}
@@ -326,6 +327,9 @@ static int setup_rx(struct sockaddr *add
 	if (bind(fd, addr, alen))
 		error(1, errno, "bind");
 
+	if (cfg_machine_slow)
+		tv.tv_sec = 2;
+
 	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)))
 		error(1, errno, "setsockopt rcv timeout");
 
@@ -512,6 +516,8 @@ static void parse_opts(int argc, char **
 	setup_sockaddr(domain, saddr, &cfg_src_addr);
 
 	cfg_num_pkt = parse_io(argv[optind], cfg_buf);
+
+	cfg_machine_slow = getenv("KSFT_MACHINE_SLOW");
 }
 
 int main(int argc, char **argv)
--- a/tools/testing/selftests/drivers/net/so_txtime.py
+++ b/tools/testing/selftests/drivers/net/so_txtime.py
@@ -6,6 +6,7 @@
 Test delivery time in FQ and ETF qdiscs.
 """
 
+import os
 import time
 
 from lib.py import ksft_exit, ksft_run, ksft_variants
@@ -15,17 +16,23 @@ from lib.py import NetDrvEpEnv, bkg, cmd
 
 def test_so_txtime(cfg, clockid, ipver, args_tx, args_rx, expect_success):
     """Main function. Run so_txtime as sender and receiver."""
+    slow_machine = os.environ.get('KSFT_MACHINE_SLOW')
+
     bin_path = cfg.test_dir / "so_txtime"
 
-    tstart = time.time_ns() + 200_000_000
+    tstart = time.time_ns() + (2000_000_000 if slow_machine else 200_000_000)
 
     cmd_addr = f"-S {cfg.addr_v[ipver]} -D {cfg.remote_addr_v[ipver]}"
     cmd_base = f"{bin_path} -{ipver} -c {clockid} -t {tstart} {cmd_addr}"
     cmd_rx = f"{cmd_base} {args_rx} -r"
     cmd_tx = f"{cmd_base} {args_tx}"
 
+    expect_fail = not expect_success
+    if slow_machine:
+        expect_success = False
+
     with bkg(cmd_rx, host=cfg.remote, fail=expect_success,
-             expect_fail=(not expect_success), exit_wait=True):
+             expect_fail=expect_fail, exit_wait=True):
         cmd(cmd_tx)
 
 


