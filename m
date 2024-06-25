Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63071465A8;
	Tue, 25 Jun 2024 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308350; cv=none; b=E7Y4YxT/8VxQtTvrH1rQnsOPzGdRGZ2ngX3Bo1VzFWLJdhu46wl77SyqS2X8alT+8ApUZsINRWn8Ggk66B4P3vqE5r9kz8oNtN9wEcCDz5HlGsFpXybzIiuzUMLNTYwJWDSLEcv6zimgnd7KaKX7b7vVjNkhmEcb5hEl+88NoVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308350; c=relaxed/simple;
	bh=TXfw0BBfQ/Kwv7v6xr+4ndm5sJZumTQQN9wEHS/PNVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ei/87zN2Lj9pB7+gRZ4p9oLWvcMC9kfEyaOXDrd+suVFsCvcYNaeraPGEgRzmIx4tVtw8WbgpZ8uoZydqc7VTJqx9jRHsSR5+iem0b4MoGRHKG93+IbIDK1QcqKW84vM/dOFVnwxoAG/WI4x+WbRrGJl9FsoW/xcLMblfdMumus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0z6Wq+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0z6Wq+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D48C32781;
	Tue, 25 Jun 2024 09:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308350;
	bh=TXfw0BBfQ/Kwv7v6xr+4ndm5sJZumTQQN9wEHS/PNVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0z6Wq+tI/9of408zPY4lzFOkjItGF+Ahwn841nyjv06+5PmVe2GWMSODFNHeKUY4
	 J+6oLEB8i1NS6rK48XCNmeEenb8HYG9ABUZT3HTcPixZhk3zVCWI4Lk09blmTKA2c2
	 fdojfcasUz18xmAKujbO8GwHFybwHBVYTC+3OULM=
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
Subject: [PATCH 6.9 064/250] platform/x86: p2sb: Dont init until unassigned resources have been assigned
Date: Tue, 25 Jun 2024 11:30:22 +0200
Message-ID: <20240625085550.522020377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 3d66e1d4eb1f5..1ac30034f3e59 100644
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



