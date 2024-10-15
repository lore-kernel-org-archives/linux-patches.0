Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B11D515E;
	Tue, 15 Oct 2024 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998422; cv=none; b=rI38PAMRG/0nt2Y3byAcZt7fZlYp0zozaLogI1+T/5B4vK2/tr/pEZgKVU/zj8CrglAoybHmADBU2ibj1k7ylAkdg0WfG0SwIgo7S5eFn6/Udlb9bF82j/irfyAt9aD2GjCEQBwTMdcvoGep6B0McNJwJOuH3h6LxWJE5FDEz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998422; c=relaxed/simple;
	bh=hqUDtsPsCqSDkd0M6UFdnOC04e+cTT9sJY7PmDzwqrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apqODWj44/LJMNPEnBFT18rqLdOJdxs0rZqC5AAnYSN2lak3zOZxcKiZ9WG63d3jPrF06NameSVGJToeenMkbvjVfOg0QxgmdWg7SOiRujmVBFh2+akA4zbf2lBYx3xyM+MS2dwuvY2G53sYHzBdH1Vy3yMZJ0zInaDqvo/mhTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKS/KHd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKS/KHd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69985C4CEC6;
	Tue, 15 Oct 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998421;
	bh=hqUDtsPsCqSDkd0M6UFdnOC04e+cTT9sJY7PmDzwqrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKS/KHd+wsgSvoVANblGwg+0XsNyRwuf88cM5k+Ius6BZzdmA2HWhdduYgdFPm6V9
	 vl9rRX1zF48tu8OrXAnj0DZUyVVmHClKBZRWBki6Zvk4CigQhZrZnpeply9eahJ5mL
	 5vqgEQbVzmg1rYobHdrfx/5u8DmgAtpniVro+qjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/518] s390/zcore: release dump save area on restart or power down
Date: Tue, 15 Oct 2024 14:45:45 +0200
Message-ID: <20241015123934.026071652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit dabdfac0e85c8c1e811b10c08742f49285e78a17 ]

The zFCP/NVMe standalone dumper is supposed to release the dump save area
resource as soon as possible but might fail to do so, for instance, if it
crashes. To avoid this situation, register a reboot notifier and ensure
the dump save area resource is released on reboot or power down.

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 0b18c852cc6f ("tracing: Have saved_cmdlines arrays all in one allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/zcore.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 5f659fa9224a3..1aee6b2ae66fb 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
+#include <linux/reboot.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/ipl.h>
@@ -247,6 +248,28 @@ static int __init zcore_reipl_init(void)
 	return 0;
 }
 
+static int zcore_reboot_and_on_panic_handler(struct notifier_block *self,
+					     unsigned long	   event,
+					     void		   *data)
+{
+	if (hsa_available)
+		release_hsa();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block zcore_reboot_notifier = {
+	.notifier_call	= zcore_reboot_and_on_panic_handler,
+	/* we need to be notified before reipl and kdump */
+	.priority	= INT_MAX,
+};
+
+static struct notifier_block zcore_on_panic_notifier = {
+	.notifier_call	= zcore_reboot_and_on_panic_handler,
+	/* we need to be notified before reipl and kdump */
+	.priority	= INT_MAX,
+};
+
 static int __init zcore_init(void)
 {
 	unsigned char arch;
@@ -307,6 +330,9 @@ static int __init zcore_init(void)
 	zcore_hsa_file = debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir,
 					     NULL, &zcore_hsa_fops);
 
+	register_reboot_notifier(&zcore_reboot_notifier);
+	atomic_notifier_chain_register(&panic_notifier_list, &zcore_on_panic_notifier);
+
 	return 0;
 fail:
 	diag308(DIAG308_REL_HSA, NULL);
-- 
2.43.0



