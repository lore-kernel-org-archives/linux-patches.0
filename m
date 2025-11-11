Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CADB261B6E;
	Tue, 11 Nov 2025 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823082; cv=none; b=h0IohCga8PhwVjCF3V5vES+JiLruoeMtoj80G4kPGoMDe5bEVs8Aj7kkUxoXea2dwkPRNeq2hBMTHob8HPOiyxKXkx9pB9tzS+pAF6jl59H6FisK0Cw+3LN4rEks/qFA/OgYzhOojXOm16HKkOTj8qcRnJgu835E0IKF0yOoDQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823082; c=relaxed/simple;
	bh=57IlWoiE+unP0kkp7hCj8aF0295Y+nXxKAjMNB2aiNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jElv2IkHhynDydH1pLMHu+o/v8/BISjSrO+1QOBI1k2BH6On5NTz9aGYJ9oLMQRktNN8PjKOl4g/ZPbJeis7R7j9eBbnqlDfzbYZBI9ESdQIB8siT2dZxO1LZl1kaYVFxlg8EmLu8hL2Nkbq/VKfhPgb18SyRNb/Hshp76pNu1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL5KYplt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL5KYplt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E44C4CEF5;
	Tue, 11 Nov 2025 01:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823082;
	bh=57IlWoiE+unP0kkp7hCj8aF0295Y+nXxKAjMNB2aiNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL5KYpltPKXJup8qDGVPQ9hy4+rKefXop3JywTfdVFaaEGKtdV3J1qzeoE5b1JWvQ
	 v00ohL/aAIWo5G5E5Gpk+szEFEhSg2Uy1CWBwLgUr4/695IJYDzYG/oR68KNkyAYsJ
	 pnGRCsJRrF0mvekd+RVCn6iZmtWP5BFwZ0Aeb6fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/565] mfd: madera: Work around false-positive -Wininitialized warning
Date: Tue, 11 Nov 2025 09:40:24 +0900
Message-ID: <20251111004530.714261109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bdbd5bfc97145..2f74a8c644a32 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -456,7 +456,7 @@ int madera_dev_init(struct madera *madera)
 	struct device *dev = madera->dev;
 	unsigned int hwid;
 	int (*patch_fn)(struct madera *) = NULL;
-	const struct mfd_cell *mfd_devs;
+	const struct mfd_cell *mfd_devs = NULL;
 	int n_devs = 0;
 	int i, ret;
 
@@ -670,7 +670,7 @@ int madera_dev_init(struct madera *madera)
 		goto err_reset;
 	}
 
-	if (!n_devs) {
+	if (!n_devs || !mfd_devs) {
 		dev_err(madera->dev, "Device ID 0x%x not a %s\n", hwid,
 			madera->type_name);
 		ret = -ENODEV;
-- 
2.51.0



