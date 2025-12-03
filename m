Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A6331A5F;
	Wed,  3 Dec 2025 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777600; cv=none; b=EwgClta5mu6DGGTLUgs05pmYQ0aX9FfrQsbGJHsSjqCK5xSdUPi4sfAxBfxmWOO4S18138MFs/aLrNHmDvr4U5QkGBZKyxYD9zH83U/UJ7W4HyuIRyqP+dTfvuiBSrhQz6FhXEQo+NLVVD0fc3O+c7k3WfPy8rYezX/NKNgKYd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777600; c=relaxed/simple;
	bh=1b4Mi8qZZ/4UcGN8dc++SCAT6HC0tuxfwGHYTeb86aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vdhl99z54jWsvlgILXsjMkt/2DUTm0+3IzuW2s37yr7JiqDsWCdpvpyY28NMnQYwfFyeoD0opuZCjfpPMDWjlLD/qWvT7PenCM78RnNsNnQW7ga6yM+iq5u3qOGk4NQpmK5IYyr35+jJroX2fwE948XGSbCzrsmjSVpOe/dGOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSRFjLgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSRFjLgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835E0C4CEF5;
	Wed,  3 Dec 2025 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777599;
	bh=1b4Mi8qZZ/4UcGN8dc++SCAT6HC0tuxfwGHYTeb86aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSRFjLgZPjSmX/R1ILO7w9j4CqSe4ucrtldo5DfypxlE3zLSHwbIova+hT/xkyBWP
	 PoUSlgXoCiDHNxUg37AzqNYkjgPkuNUnryFXEGJT2r1C5zx2AMH1tUXEi45PiNtxn7
	 7Bb9jYD+BXMR399ECcY7EhoTe7x8dHTx/eugEcWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/392] mfd: madera: Work around false-positive -Wininitialized warning
Date: Wed,  3 Dec 2025 16:23:58 +0100
Message-ID: <20251203152417.341199970@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2abc0094def7..87797d77c9f0c 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -457,7 +457,7 @@ int madera_dev_init(struct madera *madera)
 	struct device *dev = madera->dev;
 	unsigned int hwid;
 	int (*patch_fn)(struct madera *) = NULL;
-	const struct mfd_cell *mfd_devs;
+	const struct mfd_cell *mfd_devs = NULL;
 	int n_devs = 0;
 	int i, ret;
 
@@ -671,7 +671,7 @@ int madera_dev_init(struct madera *madera)
 		goto err_reset;
 	}
 
-	if (!n_devs) {
+	if (!n_devs || !mfd_devs) {
 		dev_err(madera->dev, "Device ID 0x%x not a %s\n", hwid,
 			madera->type_name);
 		ret = -ENODEV;
-- 
2.51.0



