Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA01189BB0;
	Sun,  7 Sep 2025 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276976; cv=none; b=RruPFw3B2XtpCPIIbivi1JXv+8gefebQ3Y1+TzN2K5QiE90SLSB4g/S4Y6aRKYquCPc4TJuVdx/soA3LUluTo5b5JPdWwuD9FCjP4wsxJQ8Flq3qNTJRFeQcOM14TNdRRywA/9sLjRF2cZ0KbA8w8WWbyjRqJ2bvxOA8L7R+koA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276976; c=relaxed/simple;
	bh=pyoiXh5VL4XTt+Ojmb9eBtVZqTRLq5lasqUA/M2emN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6nVP6UpGx42Uo1HO/xn3L4u+eKMN72tzACn2i2ZlU0BsDHQvycZLJ9piP6bSQoh0s8CGttrmyXgvv6sKJmEqtG7cLYyynzM5mNMIQuOtNuf8A4caBm9llxbIdey3nqk7t0hQVUXaLMlsLX+Qj+NzN2gthbmbfy8HX+HOZrcl/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5zBdHsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5zBdHsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69722C4CEF0;
	Sun,  7 Sep 2025 20:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276976;
	bh=pyoiXh5VL4XTt+Ojmb9eBtVZqTRLq5lasqUA/M2emN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5zBdHsfjl+1gzbeyYDwVHWt8oLrfJEeXUJ9xpgm4sskdfbZMXymzW45gAfBBoYtK
	 cC4pZHkBmgV1ppvQjgXRD90OKtuNYRfcl/7YiNg7qhPFWz1CAIr3Qa77vBXDyMekPW
	 p1WWSG0nHaw9jFSiuQ6Vh/BrJgvvabTVdPe2hVjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/175] selftests: drv-net: csum: fix interface name for remote host
Date: Sun,  7 Sep 2025 21:57:23 +0200
Message-ID: <20250907195615.984933299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 49c2502b5946ebf454d7e16fd0189769a82b6117 ]

Use cfg.remote_ifname for arguments of remote command.
Without this UDP tests fail in NIPA where local interface
is called enp1s0 and remote enp0s4.

Fixes: 1d0dc857b5d8 ("selftests: drv-net: add checksum tests")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250830183842.688935-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/csum.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/csum.py b/tools/testing/selftests/drivers/net/hw/csum.py
index cb40497faee44..b7e55be9bd9fd 100755
--- a/tools/testing/selftests/drivers/net/hw/csum.py
+++ b/tools/testing/selftests/drivers/net/hw/csum.py
@@ -20,7 +20,7 @@ def test_receive(cfg, ipv4=False, extra_args=None):
         ip_args = f"-6 -S {cfg.remote_v6} -D {cfg.v6}"
 
     rx_cmd = f"{cfg.bin_local} -i {cfg.ifname} -n 100 {ip_args} -r 1 -R {extra_args}"
-    tx_cmd = f"{cfg.bin_remote} -i {cfg.ifname} -n 100 {ip_args} -r 1 -T {extra_args}"
+    tx_cmd = f"{cfg.bin_remote} -i {cfg.remote_ifname} -n 100 {ip_args} -r 1 -T {extra_args}"
 
     with bkg(rx_cmd, exit_wait=True):
         wait_port_listen(34000, proto="udp")
@@ -43,7 +43,7 @@ def test_transmit(cfg, ipv4=False, extra_args=None):
     if extra_args != "-U -Z":
         extra_args += " -r 1"
 
-    rx_cmd = f"{cfg.bin_remote} -i {cfg.ifname} -L 1 -n 100 {ip_args} -R {extra_args}"
+    rx_cmd = f"{cfg.bin_remote} -i {cfg.remote_ifname} -L 1 -n 100 {ip_args} -R {extra_args}"
     tx_cmd = f"{cfg.bin_local} -i {cfg.ifname} -L 1 -n 100 {ip_args} -T {extra_args}"
 
     with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
-- 
2.50.1



