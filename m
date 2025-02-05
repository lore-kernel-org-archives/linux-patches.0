Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD05487BF;
	Wed,  5 Feb 2025 14:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765861; cv=none; b=o307IKnmuzuk1YLdAfkmH7U0SjHFKQ8pCBcX7PwjrmumiWgorozDZBAzIfwakMTV/OMo+roULHE/cp7zCSyvv4QUXrsC8SNIIF7XvXc0tRPNIuGcepuvpSAvGIN5UD6Y0FGJLtjGmYU4len3m/ks82kaCaVm2eOJL/Gzbsgz1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765861; c=relaxed/simple;
	bh=YHedXoVna26xgC9+FxcfUeI5q7XTTRWzaqIZ90ndzOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+ny0aF/lwsc9HUNgLGQ/jQl9basdhqz1p6uc8PH6RxsGiwRDM7Ggs9jdWxZ8o8/i3+jVcAYE4UOZzhXe/XBEKj4V4S8GoPD2lUOASK+ZaSBwPbwlYXidImZtNrbxyTU3uqg4PSQAC0HzXn/I6FqK9bWVawg0bNxhkkpr6hPVAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EE8ST/gH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EE8ST/gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF4DC4CED1;
	Wed,  5 Feb 2025 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765861;
	bh=YHedXoVna26xgC9+FxcfUeI5q7XTTRWzaqIZ90ndzOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EE8ST/gH4nYqI/dPZaFMwQTZ7dYY2gUB61r6z5qnVL7dbjxVe1BOHd2tjkcFLQCZL
	 IDZ2HR5SsV0wsU8K/Tb6sQrQG3c6k9sUeDLc46UboVSTjYS6ecTqHSF7hmbEd5NNrO
	 xUXKPnjoKAAbQjp+wVMU5rJCrfcJX3T8odrL2TJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/590] crypto: iaa - Fix IAA disabling that occurs when sync_mode is set to async
Date: Wed,  5 Feb 2025 14:40:17 +0100
Message-ID: <20250205134505.300550972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

[ Upstream commit 4ebd9a5ca478673cfbb38795cc5b3adb4f35fe04 ]

With the latest mm-unstable, setting the iaa_crypto sync_mode to 'async'
causes crypto testmgr.c test_acomp() failure and dmesg call traces, and
zswap being unable to use 'deflate-iaa' as a compressor:

echo async > /sys/bus/dsa/drivers/crypto/sync_mode

[  255.271030] zswap: compressor deflate-iaa not available
[  369.960673] INFO: task cryptomgr_test:4889 blocked for more than 122 seconds.
[  369.970127]       Not tainted 6.13.0-rc1-mm-unstable-12-16-2024+ #324
[  369.977411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  369.986246] task:cryptomgr_test  state:D stack:0     pid:4889  tgid:4889  ppid:2      flags:0x00004000
[  369.986253] Call Trace:
[  369.986256]  <TASK>
[  369.986260]  __schedule+0x45c/0xfa0
[  369.986273]  schedule+0x2e/0xb0
[  369.986277]  schedule_timeout+0xe7/0x100
[  369.986284]  ? __prepare_to_swait+0x4e/0x70
[  369.986290]  wait_for_completion+0x8d/0x120
[  369.986293]  test_acomp+0x284/0x670
[  369.986305]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986312]  alg_test_comp+0x263/0x440
[  369.986315]  ? sched_balance_newidle+0x259/0x430
[  369.986320]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986323]  alg_test.part.27+0x103/0x410
[  369.986326]  ? __schedule+0x464/0xfa0
[  369.986330]  ? __pfx_cryptomgr_test+0x10/0x10
[  369.986333]  cryptomgr_test+0x20/0x40
[  369.986336]  kthread+0xda/0x110
[  369.986344]  ? __pfx_kthread+0x10/0x10
[  369.986346]  ret_from_fork+0x2d/0x40
[  369.986355]  ? __pfx_kthread+0x10/0x10
[  369.986358]  ret_from_fork_asm+0x1a/0x30
[  369.986365]  </TASK>

This happens because the only async polling without interrupts that
iaa_crypto currently implements is with the 'sync' mode. With 'async',
iaa_crypto calls to compress/decompress submit the descriptor and return
-EINPROGRESS, without any mechanism in the driver to poll for
completions. Hence callers such as test_acomp() in crypto/testmgr.c or
zswap, that wrap the calls to crypto_acomp_compress() and
crypto_acomp_decompress() in synchronous wrappers, will block
indefinitely. Even before zswap can notice this problem, the crypto
testmgr.c's test_acomp() will fail and prevent registration of
"deflate-iaa" as a valid crypto acomp algorithm, thereby disallowing the
use of "deflate-iaa" as a zswap compress (zswap will fall-back to the
default compressor in this case).

To fix this issue, this patch modifies the iaa_crypto sync_mode set
function to treat 'async' equivalent to 'sync', so that the correct and
only supported driver async polling without interrupts implementation is
enabled, and zswap can use 'deflate-iaa' as the compressor.

Hence, with this patch, this is what will happen:

echo async > /sys/bus/dsa/drivers/crypto/sync_mode
cat /sys/bus/dsa/drivers/crypto/sync_mode
sync

There are no crypto/testmgr.c test_acomp() errors, no call traces and zswap
can use 'deflate-iaa' without any errors. The iaa_crypto documentation has
also been updated to mention this caveat with 'async' and what to expect
with this fix.

True iaa_crypto async polling without interrupts is enabled in patch
"crypto: iaa - Implement batch_compress(), batch_decompress() API in
iaa_crypto." [1] which is under review as part of the "zswap IAA compress
batching" patch-series [2]. Until this is merged, we would appreciate it if
this current patch can be considered for a hotfix.

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20241221063119.29140-5-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/list/?series=920084

Fixes: 09646c98d ("crypto: iaa - Add irq support for the crypto async interface")
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 9 ++++++++-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index bba40158dd5c5..8e50b900d51c2 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -272,7 +272,7 @@ The available attributes are:
       echo async_irq > /sys/bus/dsa/drivers/crypto/sync_mode
 
     Async mode without interrupts (caller must poll) can be enabled by
-    writing 'async' to it::
+    writing 'async' to it (please see Caveat)::
 
       echo async > /sys/bus/dsa/drivers/crypto/sync_mode
 
@@ -283,6 +283,13 @@ The available attributes are:
 
     The default mode is 'sync'.
 
+    Caveat: since the only mechanism that iaa_crypto currently implements
+    for async polling without interrupts is via the 'sync' mode as
+    described earlier, writing 'async' to
+    '/sys/bus/dsa/drivers/crypto/sync_mode' will internally enable the
+    'sync' mode. This is to ensure correct iaa_crypto behavior until true
+    async polling without interrupts is enabled in iaa_crypto.
+
 .. _iaa_default_config:
 
 IAA Default Configuration
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 237f870000702..d2f07e34f3142 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -173,7 +173,7 @@ static int set_iaa_sync_mode(const char *name)
 		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async")) {
-		async_mode = true;
+		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async_irq")) {
 		async_mode = true;
-- 
2.39.5



