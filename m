Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563527E
	for <patches@lists.linux.dev>; Tue, 22 Nov 2022 02:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D66C433D7;
	Tue, 22 Nov 2022 02:04:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KlNhuaG/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1669082654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rn43NMm2YFbXIKxqcJTRkqXmYYbQTLqTZ42eLiNxak=;
	b=KlNhuaG/xR8W6HdklgmSDbdvVf1Ip08ubSYsrQvA54zolXDK9aP+NfM+QWweGZzPRuZTa2
	/5Pne4xPKavjZtq3w/5BfE4zjdCNtJqln2X/06j78HDEqB9olx1WShnXkfIcl3CI8Zyfit
	QMAxKaJFxK7lT7dJUoTYQt8MXGtTtzA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6a8be201 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 22 Nov 2022 02:04:13 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-efi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	ardb@kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v3 1/5] efi: vars: prohibit reading random seed variables
Date: Tue, 22 Nov 2022 03:04:00 +0100
Message-Id: <20221122020404.3476063-2-Jason@zx2c4.com>
In-Reply-To: <20221122020404.3476063-1-Jason@zx2c4.com>
References: <20221122020404.3476063-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In anticipation of putting random seeds in EFI variables, it's important
that the random GUID namespace of variables remains hidden from
userspace. We accomplish this by not populating efivarfs with entries
from that GUID, as well as denying the creation of new ones in that
GUID.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/efivarfs/inode.c | 4 ++++
 fs/efivarfs/super.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 939e5e242b98..617f3ad2485e 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -91,6 +91,10 @@ static int efivarfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 	err = guid_parse(dentry->d_name.name + namelen + 1, &var->var.VendorGuid);
 	if (err)
 		goto out;
+	if (guid_equal(&var->var.VendorGuid, &LINUX_EFI_RANDOM_SEED_TABLE_GUID)) {
+		err = -EPERM;
+		goto out;
+	}
 
 	if (efivar_variable_is_removable(var->var.VendorGuid,
 					 dentry->d_name.name, namelen))
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 6780fc81cc11..07e82e246666 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -116,6 +116,9 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	int err = -ENOMEM;
 	bool is_removable = false;
 
+	if (guid_equal(&vendor, &LINUX_EFI_RANDOM_SEED_TABLE_GUID))
+		return 0;
+
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return err;
-- 
2.38.1

