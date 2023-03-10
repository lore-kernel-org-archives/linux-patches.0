Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16528484
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1617BC4339B;
	Fri, 10 Mar 2023 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456883;
	bh=jBO+9yF13EmApSE0R4KjaJE9woEJGEqHfkyOh+W2jNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpFro3xHiTekmRgQjjF8X7DdbnNMl293HwMM50Y+d4nLEQdLd+uwmtEiFt77Nacie
	 2VFrDGnPy2KQZSPwYGqSjyTsVJdaYWd3eItLn0iTWCvwt+mJ8rTHlziHFXGqvAkJ+r
	 O+r6cVCBN65tLKNUp/n1wfCH6yZM1NDnR0pF6eho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 158/211] USB: ULPI: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:38:58 +0100
Message-Id: <20230310133723.565215612@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 8f4d25eba599c4bd4b5ea8ae8752cda480a9d563 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/ulpi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index d7c8461976ce0..38703781ee2d1 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -271,7 +271,7 @@ static int ulpi_regs_show(struct seq_file *seq, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(ulpi_regs);
 
-#define ULPI_ROOT debugfs_lookup(KBUILD_MODNAME, NULL)
+static struct dentry *ulpi_root;
 
 static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 {
@@ -301,7 +301,7 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 		return ret;
 	}
 
-	root = debugfs_create_dir(dev_name(dev), ULPI_ROOT);
+	root = debugfs_create_dir(dev_name(dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
@@ -349,8 +349,7 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	debugfs_remove_recursive(debugfs_lookup(dev_name(&ulpi->dev),
-						ULPI_ROOT));
+	debugfs_lookup_and_remove(dev_name(&ulpi->dev), ulpi_root);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
@@ -360,12 +359,11 @@ EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
 static int __init ulpi_init(void)
 {
 	int ret;
-	struct dentry *root;
 
-	root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	ulpi_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
 	ret = bus_register(&ulpi_bus);
 	if (ret)
-		debugfs_remove(root);
+		debugfs_remove(ulpi_root);
 	return ret;
 }
 subsys_initcall(ulpi_init);
@@ -373,7 +371,7 @@ subsys_initcall(ulpi_init);
 static void __exit ulpi_exit(void)
 {
 	bus_unregister(&ulpi_bus);
-	debugfs_remove_recursive(ULPI_ROOT);
+	debugfs_remove(ulpi_root);
 }
 module_exit(ulpi_exit);
 
-- 
2.39.2



