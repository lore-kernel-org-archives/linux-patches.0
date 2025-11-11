Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5563434888F;
	Tue, 11 Nov 2025 01:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823768; cv=none; b=ENN0ON+k5DJvo67brBKjZ2tg5Yh9Y8+ENOVNVJrdG+zbZXROMd9rInOGarzkKDfMzhRUJHWljW62s7NUzEZxNd7RZtkSmV/myV8LP/WTGQrGblg3nVUY/7gmYJccwxpQt+AzAVkieOnKJgxxxIpYvs6xqDxC6rEyWBr3T9meRLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823768; c=relaxed/simple;
	bh=Ep8nM/nrGV87z+s1QHFLC8XSfkc0bXKt5mFYCgiY7RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4z71+Wj0MP6K+SySikOM0jK48wHKx7uYH+8io69Ken/2QNS4BzlV1M23CS7JZAXJ375idHaRfwJNO/+1RhrIS8xypH5igN1CuFf4cTI7AsjvOZwDclReaMZOTcX4YdmFJRSxMFE8QMPO5fpOsEeUTVuUUsg8qUkQXQ+9xRfMlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfEdyzk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfEdyzk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AAAC113D0;
	Tue, 11 Nov 2025 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823768;
	bh=Ep8nM/nrGV87z+s1QHFLC8XSfkc0bXKt5mFYCgiY7RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfEdyzk1i8T58uV1TOe7BNqAOuMhTdWXMFFlSVpYAnPCVNS7sqrkM6CDIfjA42mzO
	 jRWy39LGk/gHpp2KsUSaZADslZ9f1Q2csgIso6ovTWpwVXrMstfpYC3hJxsE2mlN3c
	 1wwZDaHxxCHjI82AlFq8dlGDpSKbkUGCwUX2K0XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 365/849] selftests: drv-net: hds: restore hds settings
Date: Tue, 11 Nov 2025 09:38:55 +0900
Message-ID: <20251111004545.244667917@linuxfoundation.org>
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

[ Upstream commit ee3ae27721fb994ac0b4705b5806ce68a5a74c73 ]

The test currently modifies the HDS settings and doesn't restore them.
This may cause subsequent tests to fail (or pass when they should not).
Add defer()ed reset handling.

Link: https://patch.msgid.link/20250825175939.2249165-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hds.py | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/hds.py b/tools/testing/selftests/drivers/net/hds.py
index 7c90a040ce45a..a2011474e6255 100755
--- a/tools/testing/selftests/drivers/net/hds.py
+++ b/tools/testing/selftests/drivers/net/hds.py
@@ -3,6 +3,7 @@
 
 import errno
 import os
+from typing import Union
 from lib.py import ksft_run, ksft_exit, ksft_eq, ksft_raises, KsftSkipEx
 from lib.py import CmdExitFailure, EthtoolFamily, NlError
 from lib.py import NetDrvEnv
@@ -58,7 +59,39 @@ def get_hds_thresh(cfg, netnl) -> None:
     if 'hds-thresh' not in rings:
         raise KsftSkipEx('hds-thresh not supported by device')
 
+
+def _hds_reset(cfg, netnl, rings) -> None:
+    cur = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
+
+    arg = {'header': {'dev-index': cfg.ifindex}}
+    if cur.get('tcp-data-split') != rings.get('tcp-data-split'):
+        # Try to reset to "unknown" first, we don't know if the setting
+        # was the default or user chose it. Default seems more likely.
+        arg['tcp-data-split'] = "unknown"
+        netnl.rings_set(arg)
+        cur = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
+        if cur['tcp-data-split'] == rings['tcp-data-split']:
+            del arg['tcp-data-split']
+        else:
+            # Try the explicit setting
+            arg['tcp-data-split'] = rings['tcp-data-split']
+    if cur.get('hds-thresh') != rings.get('hds-thresh'):
+        arg['hds-thresh'] = rings['hds-thresh']
+    if len(arg) > 1:
+        netnl.rings_set(arg)
+
+
+def _defer_reset_hds(cfg, netnl) -> Union[dict, None]:
+    try:
+        rings = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
+        if 'hds-thresh' in rings or 'tcp-data-split' in rings:
+            defer(_hds_reset, cfg, netnl, rings)
+    except NlError as e:
+        pass
+
+
 def set_hds_enable(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         netnl.rings_set({'header': {'dev-index': cfg.ifindex}, 'tcp-data-split': 'enabled'})
     except NlError as e:
@@ -76,6 +109,7 @@ def set_hds_enable(cfg, netnl) -> None:
     ksft_eq('enabled', rings['tcp-data-split'])
 
 def set_hds_disable(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         netnl.rings_set({'header': {'dev-index': cfg.ifindex}, 'tcp-data-split': 'disabled'})
     except NlError as e:
@@ -93,6 +127,7 @@ def set_hds_disable(cfg, netnl) -> None:
     ksft_eq('disabled', rings['tcp-data-split'])
 
 def set_hds_thresh_zero(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         netnl.rings_set({'header': {'dev-index': cfg.ifindex}, 'hds-thresh': 0})
     except NlError as e:
@@ -110,6 +145,7 @@ def set_hds_thresh_zero(cfg, netnl) -> None:
     ksft_eq(0, rings['hds-thresh'])
 
 def set_hds_thresh_random(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         rings = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
     except NlError as e:
@@ -140,6 +176,7 @@ def set_hds_thresh_random(cfg, netnl) -> None:
     ksft_eq(hds_thresh, rings['hds-thresh'])
 
 def set_hds_thresh_max(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         rings = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
     except NlError as e:
@@ -157,6 +194,7 @@ def set_hds_thresh_max(cfg, netnl) -> None:
     ksft_eq(rings['hds-thresh'], rings['hds-thresh-max'])
 
 def set_hds_thresh_gt(cfg, netnl) -> None:
+    _defer_reset_hds(cfg, netnl)
     try:
         rings = netnl.rings_get({'header': {'dev-index': cfg.ifindex}})
     except NlError as e:
@@ -178,6 +216,7 @@ def set_xdp(cfg, netnl) -> None:
     """
     mode = _get_hds_mode(cfg, netnl)
     if mode == 'enabled':
+        _defer_reset_hds(cfg, netnl)
         netnl.rings_set({'header': {'dev-index': cfg.ifindex},
                          'tcp-data-split': 'unknown'})
 
-- 
2.51.0



