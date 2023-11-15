Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696D83C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk0bIk7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B3CC433C7;
	Wed, 15 Nov 2023 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077498;
	bh=//GGuPJ9NbNVHfTqhXt98DAVzwfCCHNEYIv9UHwSJ9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk0bIk7tuylOCTjtaWgi/Eu142u01eT0TOoJeD0lgiIGFmXg+4O3vr7cd2FYRQp9o
	 N2uNE8/heiPY2znJyJfKk96UJkRDpkMBI6uX9Xua5dS6/Iiw6PSnEQ5Jvyq2i13MVW
	 3AHrtOGpHnljtdSPBUdvwuiV7xWzbnCSbJtHvznk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/603] crypto: ccp - Fix ioctl unit tests
Date: Wed, 15 Nov 2023 14:14:44 -0500
Message-ID: <20231115191636.989706957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7f71c3e033824e1da237916a1885e3c0699f86b2 ]

A local environment change was importing ioctl_opt which is required
for ioctl tests to pass.  Add the missing import for it.

Fixes: 15f8aa7bb3e5 ("crypto: ccp - Add unit tests for dynamic boost control")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/crypto/ccp/test_dbc.py | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/crypto/ccp/test_dbc.py b/tools/crypto/ccp/test_dbc.py
index 998bb3e3cd040..a28a1f94c1d2f 100755
--- a/tools/crypto/ccp/test_dbc.py
+++ b/tools/crypto/ccp/test_dbc.py
@@ -4,6 +4,12 @@ import unittest
 import os
 import time
 import glob
+import fcntl
+try:
+    import ioctl_opt as ioctl
+except ImportError:
+    ioctl = None
+    pass
 from dbc import *
 
 # Artificial delay between set commands
@@ -64,13 +70,16 @@ class TestInvalidIoctls(DynamicBoostControlTest):
     def setUp(self) -> None:
         if not os.path.exists(DEVICE_NODE):
             self.skipTest("system is unsupported")
+        if not ioctl:
+            self.skipTest("unable to test IOCTLs without ioctl_opt")
+
         return super().setUp()
 
     def test_invalid_nonce_ioctl(self) -> None:
         """tries to call get_nonce ioctl with invalid data structures"""
 
         # 0x1 (get nonce), and invalid data
-        INVALID1 = IOWR(ord("D"), 0x01, invalid_param)
+        INVALID1 = ioctl.IOWR(ord("D"), 0x01, invalid_param)
         with self.assertRaises(OSError) as error:
             fcntl.ioctl(self.d, INVALID1, self.data, True)
         self.assertEqual(error.exception.errno, 22)
@@ -79,7 +88,7 @@ class TestInvalidIoctls(DynamicBoostControlTest):
         """tries to call set_uid ioctl with invalid data structures"""
 
         # 0x2 (set uid), and invalid data
-        INVALID2 = IOW(ord("D"), 0x02, invalid_param)
+        INVALID2 = ioctl.IOW(ord("D"), 0x02, invalid_param)
         with self.assertRaises(OSError) as error:
             fcntl.ioctl(self.d, INVALID2, self.data, True)
         self.assertEqual(error.exception.errno, 22)
@@ -88,7 +97,7 @@ class TestInvalidIoctls(DynamicBoostControlTest):
         """tries to call set_uid ioctl with invalid data structures"""
 
         # 0x2 as RW (set uid), and invalid data
-        INVALID3 = IOWR(ord("D"), 0x02, invalid_param)
+        INVALID3 = ioctl.IOWR(ord("D"), 0x02, invalid_param)
         with self.assertRaises(OSError) as error:
             fcntl.ioctl(self.d, INVALID3, self.data, True)
         self.assertEqual(error.exception.errno, 22)
@@ -96,7 +105,7 @@ class TestInvalidIoctls(DynamicBoostControlTest):
     def test_invalid_param_ioctl(self) -> None:
         """tries to call param ioctl with invalid data structures"""
         # 0x3 (param), and invalid data
-        INVALID4 = IOWR(ord("D"), 0x03, invalid_param)
+        INVALID4 = ioctl.IOWR(ord("D"), 0x03, invalid_param)
         with self.assertRaises(OSError) as error:
             fcntl.ioctl(self.d, INVALID4, self.data, True)
         self.assertEqual(error.exception.errno, 22)
@@ -104,7 +113,7 @@ class TestInvalidIoctls(DynamicBoostControlTest):
     def test_invalid_call_ioctl(self) -> None:
         """tries to call the DBC ioctl with invalid data structures"""
         # 0x4, and invalid data
-        INVALID5 = IOWR(ord("D"), 0x04, invalid_param)
+        INVALID5 = ioctl.IOWR(ord("D"), 0x04, invalid_param)
         with self.assertRaises(OSError) as error:
             fcntl.ioctl(self.d, INVALID5, self.data, True)
         self.assertEqual(error.exception.errno, 22)
-- 
2.42.0



