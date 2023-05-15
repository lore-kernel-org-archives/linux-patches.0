Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2C6D2EF
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D2EC433EF;
	Mon, 15 May 2023 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168691;
	bh=+KbmFZzYrNuG+t5ps9os/xQxJJuh1jlvzESQfWYjl08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7iVgr7Fy9wY6UbbRLTwk9Toao8nSjXvRw4LB/Y1XO1k/7W34qeqy2kAgOFpYWpye
	 fxAA+C4Wo8EWcju9QWuHgO+kDNn+u8P6h1IjcH2nQASmk6X56IfesOROihk3bi27Rk
	 ZjurHBjuBbj1mbYjvbCDgqBOSYjpgkZXjqkJhxEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 011/191] debugfs: regset32: Add Runtime PM support
Date: Mon, 15 May 2023 18:24:08 +0200
Message-Id: <20230515161707.624352739@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 30332eeefec8f83afcea00c360f99ef64b87f220 upstream.

Hardware registers of devices under control of power management cannot
be accessed at all times.  If such a device is suspended, register
accesses may lead to undefined behavior, like reading bogus values, or
causing exceptions or system lock-ups.

Extend struct debugfs_regset32 with an optional field to let device
drivers specify the device the registers in the set belong to.  This
allows debugfs_show_regset32() to make sure the device is resumed while
its registers are being read.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund@ragnatech.se>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/file.c       |    8 ++++++++
 include/linux/debugfs.h |    1 +
 2 files changed, 9 insertions(+)

--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 #include <linux/poll.h>
 
 #include "internal.h"
@@ -1084,7 +1085,14 @@ static int debugfs_show_regset32(struct
 {
 	struct debugfs_regset32 *regset = s->private;
 
+	if (regset->dev)
+		pm_runtime_get_sync(regset->dev);
+
 	debugfs_print_regs32(s, regset->regs, regset->nregs, regset->base, "");
+
+	if (regset->dev)
+		pm_runtime_put(regset->dev);
+
 	return 0;
 }
 
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -35,6 +35,7 @@ struct debugfs_regset32 {
 	const struct debugfs_reg32 *regs;
 	int nregs;
 	void __iomem *base;
+	struct device *dev;	/* Optional device for Runtime PM */
 };
 
 extern struct dentry *arch_debugfs_dir;


