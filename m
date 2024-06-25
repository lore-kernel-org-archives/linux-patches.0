Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70219146A67;
	Tue, 25 Jun 2024 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309488; cv=none; b=EW5dZHuDvUK9uCD1LiAPbK7ZyRWkIB8kEK+BOl979Y7DS5hBtlyatmUip8YLuzMitMgZGCRAMcC1iHy/94qo2nXNMb2fyg+9ALdnxZwg7gmrmcw1AnU+sPcUAzf5js2cqIgKGEJysvXeKXhNYKbjPktdUsY8xd08rs2E3FAAb3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309488; c=relaxed/simple;
	bh=cGmlJo6NJmaror8LyaaqIK49Cr1eHBzLG4vK+Q1Bh4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBFbJ2aT7Uh6zO/aGwqcQLFtpEqHfL4LMVLrIR0uIrbFLaTfnXS4qiBrU2vomtSNfEpo0/C5anygyYk/+NR5Oan6XanmwLhjUmU+UqfT2TyPo6J7Hrx+/wPkGoimh4mEOFySW85u/7DsyDYjdrQhz4zJmKSPscuvRZr0VDkvzjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yahnXTE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yahnXTE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC56BC32781;
	Tue, 25 Jun 2024 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309488;
	bh=cGmlJo6NJmaror8LyaaqIK49Cr1eHBzLG4vK+Q1Bh4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yahnXTE/zXbAlgPczNwPbkNaxLQeOLXklO/6QlKxe4eYLR49SIm7pnRFm9ICOCryP
	 agkagjXj9D9Tc2UvA4ETqTNVECoqTN71ZURQsJ4CXZdCgB+dOQHpga+LIMesiNSMRV
	 0umXQHKgKpNFvKya/Ym3MwhqwSyO3F6R3oUEjdoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Fradella <bfradell@netapp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Klara Modin <klarasmodin@gmail.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/131] platform/x86: p2sb: Dont init until unassigned resources have been assigned
Date: Tue, 25 Jun 2024 11:33:06 +0200
Message-ID: <20240625085527.132570806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Fradella <bfradell@netapp.com>

[ Upstream commit 2c6370e6607663fc5fa0fd9ed58e2e01014898c7 ]

The P2SB could get an invalid BAR from the BIOS, and that won't be fixed
up until pcibios_assign_resources(), which is an fs_initcall().

- Move p2sb_fs_init() to an fs_initcall_sync(). This is still early
  enough to avoid a race with any dependent drivers.

- Add a check for IORESOURCE_UNSET in p2sb_valid_resource() to catch
  unset BARs going forward.

- Return error values from p2sb_fs_init() so that the 'initcall_debug'
  cmdline arg provides useful data.

Signed-off-by: Ben Fradella <bfradell@netapp.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20240509164905.41016-1-bcfradella@proton.me
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index a64f56ddd4a44..053be5c5e0cad 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -56,12 +56,9 @@ static int p2sb_get_devfn(unsigned int *devfn)
 	return 0;
 }
 
-static bool p2sb_valid_resource(struct resource *res)
+static bool p2sb_valid_resource(const struct resource *res)
 {
-	if (res->flags)
-		return true;
-
-	return false;
+	return res->flags & ~IORESOURCE_UNSET;
 }
 
 /* Copy resource from the first BAR of the device in question */
@@ -220,16 +217,20 @@ EXPORT_SYMBOL_GPL(p2sb_bar);
 
 static int __init p2sb_fs_init(void)
 {
-	p2sb_cache_resources();
-	return 0;
+	return p2sb_cache_resources();
 }
 
 /*
- * pci_rescan_remove_lock to avoid access to unhidden P2SB devices can
- * not be locked in sysfs pci bus rescan path because of deadlock. To
- * avoid the deadlock, access to P2SB devices with the lock at an early
- * step in kernel initialization and cache required resources. This
- * should happen after subsys_initcall which initializes PCI subsystem
- * and before device_initcall which requires P2SB resources.
+ * pci_rescan_remove_lock() can not be locked in sysfs PCI bus rescan path
+ * because of deadlock. To avoid the deadlock, access P2SB devices with the lock
+ * at an early step in kernel initialization and cache required resources.
+ *
+ * We want to run as early as possible. If the P2SB was assigned a bad BAR,
+ * we'll need to wait on pcibios_assign_resources() to fix it. So, our list of
+ * initcall dependencies looks something like this:
+ *
+ * ...
+ * subsys_initcall (pci_subsys_init)
+ * fs_initcall     (pcibios_assign_resources)
  */
-fs_initcall(p2sb_fs_init);
+fs_initcall_sync(p2sb_fs_init);
-- 
2.43.0



