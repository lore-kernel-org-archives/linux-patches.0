Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C50340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301107; cv=none; b=Fyfw+IylVc0zOJ+2fP0kEGtMMYvBZKOI/0CJdYj/Yd7dcj729sNp4iEuxYKvZBOXg1rYGskjT/JElyOgNUz13YjtXvcF98RjrM8iJ9wkxh8XjfFBbbIkpoHKRHjoHSQrtHONGCHDRQ6n/fHYaIUHffxPHSveUufA3iLAJ08SnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301107; c=relaxed/simple;
	bh=e3ZXd0XXxi0wpZ4x26jBB6Oe3mMb01vU4qY4HNeryYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0neQbDfwkyTD0FTjoIJ83ivE6UEBaMbSwTYMPQ3nREUMArH+gJY6180NehjZ/VEm1sAxu9NZKAFpbi4wqoXq5mCQWZXiy3h8nMl9vUqN3hz8YAxTYNf2j8cciNlGGVnrZmg3I7py7YWGkUQqfjjRlnaiW8xf6Vjs8Iy5n5e3yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoUMTF8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoUMTF8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F5CC19425;
	Sat, 28 Feb 2026 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301107;
	bh=e3ZXd0XXxi0wpZ4x26jBB6Oe3mMb01vU4qY4HNeryYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoUMTF8QBOz9LxGIkAi8ES3tf4PHVP5+qKKVuwYRlYgSHYZzTQYG7Xowtc7g4QHlD
	 zR87IEAeVvFh6S+PJ303yTzxZ5XIsbXcctlMW3xvpelKrEm/3hulIn1BFKmfru08VU
	 INQHDkhk8idorsi/G+SgoB+c2MzFWG3rjW89spNr3tnVbsigVlq9mJ4lM8+eFEu/QO
	 vQq78mvx8892e10g/uP9/7IzIgLkMWUQTcpSFpIDgUv/lkDUKVbCagsFOWZ9ozicGP
	 ItiuGnD/9TkTepQMCQAkXvf2hIHe08ddt4acrtVX3KtqX0I8iQanL9u9mxVe6So/lT
	 1F0t0EBHavsug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/752] driver core: faux: stop using static struct device
Date: Sat, 28 Feb 2026 12:39:32 -0500
Message-ID: <20260228174750.1542406-261-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 61b76d07d2b46a86ea91267d36449fc78f8a1f6e ]

faux_bus_root should not have been a static struct device, but rather a
dynamically created structure so that lockdep and other testing tools do
not trip over it (as well as being the right thing overall to do.)  Fix
this up by making it properly dynamic.

Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://lore.kernel.org/lkml/CALbr=LYKJsj6cbrDLA07qioKhWJcRj+gW8=bq5=4ZvpEe2c4Yg@mail.gmail.com/
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026012145-lapping-countless-ef81@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/faux.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/base/faux.c b/drivers/base/faux.c
index 21dd02124231a..23d7258172325 100644
--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -29,9 +29,7 @@ struct faux_object {
 };
 #define to_faux_object(dev) container_of_const(dev, struct faux_object, faux_dev.dev)
 
-static struct device faux_bus_root = {
-	.init_name	= "faux",
-};
+static struct device *faux_bus_root;
 
 static int faux_match(struct device *dev, const struct device_driver *drv)
 {
@@ -152,7 +150,7 @@ struct faux_device *faux_device_create_with_groups(const char *name,
 	if (parent)
 		dev->parent = parent;
 	else
-		dev->parent = &faux_bus_root;
+		dev->parent = faux_bus_root;
 	dev->bus = &faux_bus_type;
 	dev_set_name(dev, "%s", name);
 	device_set_pm_not_required(dev);
@@ -236,9 +234,15 @@ int __init faux_bus_init(void)
 {
 	int ret;
 
-	ret = device_register(&faux_bus_root);
+	faux_bus_root = kzalloc(sizeof(*faux_bus_root), GFP_KERNEL);
+	if (!faux_bus_root)
+		return -ENOMEM;
+
+	dev_set_name(faux_bus_root, "faux");
+
+	ret = device_register(faux_bus_root);
 	if (ret) {
-		put_device(&faux_bus_root);
+		put_device(faux_bus_root);
 		return ret;
 	}
 
@@ -256,6 +260,6 @@ int __init faux_bus_init(void)
 	bus_unregister(&faux_bus_type);
 
 error_bus:
-	device_unregister(&faux_bus_root);
+	device_unregister(faux_bus_root);
 	return ret;
 }
-- 
2.51.0

