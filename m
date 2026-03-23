Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFD53AEF22;
	Mon, 23 Mar 2026 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274767; cv=none; b=KKlL2B6tTTtt5PFWKMa/5gLRHuBkWrgmKbRobtfOCR/IaguA+SOhOZIn1Te+633bZjPhFkjVIRz1j09C5OFvZQZ+hvWoojcm2ChdqaxVr5G19VEDu1H/Cp9Rwo/nhnrewiGfAoRHpv3K8DjJF082gDR8wvbJKMw6joaxNBsUkAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274767; c=relaxed/simple;
	bh=jac9PeboftAlQLCcaetn7VRVt8oBNDw6mQ7xoA8p5l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WunivIb2/LxsSn++z6xq+Uz4/3PQEKLt/jr4BWo57JW8FVNujPmW6aeRA0+Do1z4kNbu/g0f6MtLLLj7PMrWiL2lVQifblXMaKob7lakXdHwvZB22FPSPucpBp5JK+BNXdRe/e3++kw1G2udUvZdz6Lhavh0aYPcskV/QUOoooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aBZmoneL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aBZmoneL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18080C4CEF7;
	Mon, 23 Mar 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274767;
	bh=jac9PeboftAlQLCcaetn7VRVt8oBNDw6mQ7xoA8p5l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBZmoneLtv/JPQaUXUSNFi6nclu0lVlGu0V5aLs8Iqno+9VOBR4DzUKOqvX8ta5j6
	 oDsXBnzpCVi83m2JCJPIKuOtyOocJ4Gz7KR4u+5QUxIcwJg88TwHS9LmzEGVTIf3p+
	 0PgiWdRbKPTRlu+lSvnX6kooOOyb8o6EF8KpaotU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/212] cache: starfive: fix device node leak in starlink_cache_init()
Date: Mon, 23 Mar 2026 14:45:23 +0100
Message-ID: <20260323134507.003073042@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 3c85234b979af71cb9db5eb976ea08a468415767 ]

of_find_matching_node() returns a device_node with refcount incremented.

Use __free(device_node) attribute to automatically call of_node_put()
when the variable goes out of scope, preventing the refcount leak.

Fixes: cabff60ca77d ("cache: Add StarFive StarLink cache management")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/starfive_starlink_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cache/starfive_starlink_cache.c b/drivers/cache/starfive_starlink_cache.c
index 24c7d078ca227..3a25d2d7c70ca 100644
--- a/drivers/cache/starfive_starlink_cache.c
+++ b/drivers/cache/starfive_starlink_cache.c
@@ -102,11 +102,11 @@ static const struct of_device_id starlink_cache_ids[] = {
 
 static int __init starlink_cache_init(void)
 {
-	struct device_node *np;
 	u32 block_size;
 	int ret;
 
-	np = of_find_matching_node(NULL, starlink_cache_ids);
+	struct device_node *np __free(device_node) =
+		of_find_matching_node(NULL, starlink_cache_ids);
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
-- 
2.51.0



