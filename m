Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106A124DFF9;
	Mon,  1 Dec 2025 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588513; cv=none; b=NT5FDri5FSZQUrnQlw7wgfrJBuuDHpUKnl1pCDuSkHKmocsDlHGcALJxkIpXNAK/dbIIfCZSGXYURt1B8h04FpExurFUwDaQki+13zeIaHIQ4M2Ll4WvNEpA1Eaekdhw7VPBxcRsR6AX5qM8z/MDkGV0r3t++82gxrjXroqxxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588513; c=relaxed/simple;
	bh=7uFqMwxcHz9swbdjqmy2r8yJ75hQbZwbWS98UnOzer4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpkOzpmoA6gvYBGogjjVScJyHUYtQJdbUYXoS2XLJpx9USQStVR2cTS89AKvkhp4zMSQP5v9f1H2dzVEeGHgZsIICsqPW03/2qpafLZkHnRPOeo71AeADjX4j7f8FL1DRZX6IB2Si35WEV9Se875BfgphcDg5ktmhQz+VRrt2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWo2gkN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWo2gkN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4775FC4CEF1;
	Mon,  1 Dec 2025 11:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588512;
	bh=7uFqMwxcHz9swbdjqmy2r8yJ75hQbZwbWS98UnOzer4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWo2gkN4HcjT6JlT08srWtF652InBYsZUlUqNb7BMi0B4kLJa8SrrUu1PrH6SxBMh
	 Iad/sIALkoqExjbX8Fm8ME80te6zgtqm+oS809q/I8Mcl6Wg6wO8up5gVyV83C2Ic9
	 BLKZWxMtbSRzl3wrxFhR3X3UUGXoINU2Q/QcCVV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/187] mfd: madera: Work around false-positive -Wininitialized warning
Date: Mon,  1 Dec 2025 12:22:35 +0100
Message-ID: <20251201112242.947579483@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 364752aa0c6ab0a06a2d5bfdb362c1ca407f1a30 ]

clang-21 warns about one uninitialized variable getting dereferenced
in madera_dev_init:

drivers/mfd/madera-core.c:739:10: error: variable 'mfd_devs' is uninitialized when used here [-Werror,-Wuninitialized]
  739 |                               mfd_devs, n_devs,
      |                               ^~~~~~~~
drivers/mfd/madera-core.c:459:33: note: initialize the variable 'mfd_devs' to silence this warning
  459 |         const struct mfd_cell *mfd_devs;
      |                                        ^
      |                                         = NULL

The code is actually correct here because n_devs is only nonzero
when mfd_devs is a valid pointer, but this is impossible for the
compiler to see reliably.

Change the logic to check for the pointer as well, to make this easier
for the compiler to follow.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250807071932.4085458-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/madera-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/madera-core.c b/drivers/mfd/madera-core.c
index 29540cbf75934..bfd116f5a58d0 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -431,7 +431,7 @@ int madera_dev_init(struct madera *madera)
 	struct device *dev = madera->dev;
 	unsigned int hwid;
 	int (*patch_fn)(struct madera *) = NULL;
-	const struct mfd_cell *mfd_devs;
+	const struct mfd_cell *mfd_devs = NULL;
 	int n_devs = 0;
 	int i, ret;
 
@@ -616,7 +616,7 @@ int madera_dev_init(struct madera *madera)
 		goto err_reset;
 	}
 
-	if (!n_devs) {
+	if (!n_devs || !mfd_devs) {
 		dev_err(madera->dev, "Device ID 0x%x not a %s\n", hwid,
 			madera->type_name);
 		ret = -ENODEV;
-- 
2.51.0



