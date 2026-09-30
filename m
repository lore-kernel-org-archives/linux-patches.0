Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EC94F96A6;
	Wed, 30 Sep 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782477; cv=none; b=im2piEB1OJx4bweSnp03snBnm8uVWyTzS4DYYYigJC1g7fyind3FZCux5bwI1HH71WojbeOBY/brCkVVjOflphN7t+kvu/54erFv6aFMoSmzNFW9g00rG2NfJ8/f6/hjh9jffAaPXV/DwjlKo+KXu6Y64nswQujg8JcfcIMHuJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782477; c=relaxed/simple;
	bh=pfzeL0Kg7gu8uRekaTaqiTGnqzI0DPt87RJEnRmlh8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNs0mNMFYRQ32fV0SwGBDHEa4DySc73Q6zAoh/0Y38bslku/4+bTtBSKp0DNiVVEknM6bFJRsNqigjxhiGctd3ba68g1vO4sth6EooCFIEm3SSww/8eY6qObpyOKcONfyU8kM1LRPkvcigmy8fbkevNt1ocv4SgpuvV0i+6BAKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X35aTqYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X35aTqYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAAA1F0089B;
	Wed, 30 Sep 2026 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782467;
	bh=0kBngTDBLu2mxiaTyDeDV+uKC4lPzHZtuzcrmZc6YKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X35aTqYRdQj6lDWVlHggjUya3+jZHLGOxAo0X7rnEd13wlvo0NUeWViIA3HBzDZDW
	 tPqytegbub8KoAx3IiJ4EGf2MIlASYTNGZ9lYqt2ifdQjVIlSCyWsAPURFgA0MLIxF
	 w98piGvyO8h0S9wSbUIfCyqZKOkgdZ9VfTIBZKpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/595] char/nvram: Remove redundant nvram_mutex
Date: Wed, 30 Sep 2026 17:19:08 +0200
Message-ID: <20260930152348.914236353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



