Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC451A73A;
	Wed, 30 Sep 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790757; cv=none; b=m3wwjmQoaEd9Gdi+dbzZjXYgL/6XkAt9FInmnRlU0GQwVnjtXyo/ZZ6n71I3CYciGwH9+huayk+wEf6KMV8QsDcT+RV3mMNN8u64GgVtIi3hKVN2jn3eCJjMXxDyIg5pX+WC1sYqwbcgekOowxZRxfTnZ7EmLwglKjwOS8tqVvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790757; c=relaxed/simple;
	bh=WhzR4QkpJcbB3Unhsx1giALA8MYkxVRGQZwHRj9dJ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5wrN1MKptb5j7Y9Gme7ofrVFautqDhn+cQ2V0NiHWP67JcP33aVCcoAGWURV7WNKdH4Q3G2rfvnpIPyB5Jw4iDuGc6xy4I4oCemlnKbrZZRjyl2myJlt241fTEC7XYDywm8oXdsUt5dC8KziS+yZe7oRDga8GeRRbYO4k5o5OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrlTxOCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrlTxOCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B011F000FF;
	Wed, 30 Sep 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790756;
	bh=LSRhswyMIwhEjs5OrOdCSkoSkhrSCCQ23vK3N4SlPZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrlTxOCDSFN2/qnW+xhqFajK5d8BqYU6PwSLgsQRE5SbDR+I8ndplconvtI8aH/KG
	 OgX/TtuYM4cS72fg6oBOy1DY1pYK5iWfKEaLWldt07wliLJD4zhR1fhwpP3FHn+Mpk
	 PSYiWUenHv38AdQpq+gFJ2q8lu/r0Ox9FNfu8sHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/752] char/nvram: Remove redundant nvram_mutex
Date: Wed, 30 Sep 2026 17:18:52 +0200
Message-ID: <20260930152359.499044524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

[ Upstream commit e8c715f3a7dae43fabae261493a26474fec11863 ]

The global nvram_mutex in drivers/char/nvram.c is redundant and unused,
and this triggers compiler warnings on some configurations.

All platform-specific nvram operations already provide their own internal
synchronization, meaning the wrapper-level mutex does not provide any
additional safety.

Remove the nvram_mutex definition along with all remaining lock/unlock
users across PPC32, x86, and m68k code paths, and rely entirely on the
per-architecture nvram implementations for locking.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>
Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: yeswanth <yeswanth@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20260428061540.73668-1-venkat88@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/nvram.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index e9f694b368719..bd7510abdc076 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -53,7 +53,6 @@
 #include <asm/nvram.h>
 #endif
 
-static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
 static int nvram_open_cnt;	/* #times opened */
 static int nvram_open_mode;	/* special open modes */
@@ -310,11 +309,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		break;
 #ifdef CONFIG_PPC32
 	case IOC_NVRAM_SYNC:
-		if (ppc_md.nvram_sync != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (ppc_md.nvram_sync)
 			ppc_md.nvram_sync();
-			mutex_unlock(&nvram_mutex);
-		}
 		ret = 0;
 		break;
 #endif
@@ -324,11 +320,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.initialize != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.initialize)
 			ret = arch_nvram_ops.initialize();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 	case NVRAM_SETCKS:
 		/* just set checksum, contents unchanged (maybe useful after
@@ -336,11 +329,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.set_checksum != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.set_checksum)
 			ret = arch_nvram_ops.set_checksum();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 #endif /* CONFIG_X86 || CONFIG_M68K */
 	}
-- 
2.53.0



