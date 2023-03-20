Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B891C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EF2C433A0;
	Mon, 20 Mar 2023 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324240;
	bh=v0uafu2RIETWV2/bC0afztTsBXSYkOI1XkB+wQoi9Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6qMwwc+W9Bxl37YVaCeIsmPrr7+FzFV/wfWygHrCqzjRMW9Z8iNkaAZjZuBmY00E
	 kimQWhflgJ+Lyv3JIVs07ROTPLuc00pOgJFzqFa61FjV4x08eHNQNzrQ3zQlE2M+zd
	 EV58uGVoqhh1nENnW0vUxqJ/xl4I+CgE4jva030g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.14 02/30] fs: sysfs_emit_at: Remove PAGE_SIZE alignment check
Date: Mon, 20 Mar 2023 15:54:26 +0100
Message-Id: <20230320145420.318285072@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145420.204894191@linuxfoundation.org>
References: <20230320145420.204894191@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@kernel.org>

From: Eric Biggers <ebiggers@google.com>

[No upstream commit because this fixes a bug in a backport.]

Before upstream commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)") which went into v5.4, kmalloc did
*not* always guarantee that PAGE_SIZE allocations are PAGE_SIZE-aligned.

Upstream commit 2efc459d06f1 ("sysfs: Add sysfs_emit and sysfs_emit_at
to format sysfs output") added two WARN()s that trigger when PAGE_SIZE
allocations are not PAGE_SIZE-aligned.  This was backported to old
kernels that don't guarantee PAGE_SIZE alignment.

Commit 10ddfb495232 ("fs: sysfs_emit: Remove PAGE_SIZE alignment check")
in 4.19.y, and its equivalent in 4.14.y and 4.9.y, tried to fix this
bug.  However, only it handled sysfs_emit(), not sysfs_emit_at().

Fix it in sysfs_emit_at() too.

A reproducer is to build the kernel with the following options:

	CONFIG_SLUB=y
	CONFIG_SLUB_DEBUG=y
	CONFIG_SLUB_DEBUG_ON=y
	CONFIG_PM=y
	CONFIG_SUSPEND=y
	CONFIG_PM_WAKELOCKS=y

Then run:

	echo foo > /sys/power/wake_lock && cat /sys/power/wake_lock

Fixes: cb1f69d53ac8 ("sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output")
Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202303141634.1e64fd76-yujie.liu@intel.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -592,7 +592,7 @@ int sysfs_emit_at(char *buf, int at, con
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf) || at < 0 || at >= PAGE_SIZE,
+	if (WARN(!buf || at < 0 || at >= PAGE_SIZE,
 		 "invalid sysfs_emit_at: buf:%p at:%d\n", buf, at))
 		return 0;
 


