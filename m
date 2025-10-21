Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28D27990B;
	Tue, 21 Oct 2025 20:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077594; cv=none; b=rThNAeemlEEfUFuBl+CUMQcr6OMLr5muKoQ1auEJEDO6+l7yDyOGv9nMAKc/g6KUZJKVX4N9ZU9w9RYBN/61vqJmUGEpsSMj4q64zPR4KN2RrH2TLr/YMjWZaQwwax3FZg7Vwqkl11pJRyBHgkSurXw90l2aDK4b6wVbU7JaPEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077594; c=relaxed/simple;
	bh=uE1aU0+1VPetahuZRPnrEz7OQIR7p4vXoEPViVCe8D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTaaJXTwUrRo/5HaUkec1bOM2+2iDCep9IrZd5Ybd/gY/9k9NOMQH23ZLmfChBE9mTWzMuvlbjxXb8K1iK3/IpRQwXJQJjTUpGwU2dTCaMcl6RDk/kBiEZKuON4cVdVL5309kIeShhw7m7p/XO0c00dZ1P+r4y0q4dXCdoCX1F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shTbIcrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shTbIcrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC40C4CEF1;
	Tue, 21 Oct 2025 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077594;
	bh=uE1aU0+1VPetahuZRPnrEz7OQIR7p4vXoEPViVCe8D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shTbIcrGgNft/yaehwjHQwu2XqLz85G+eyazPT21wTIG7tsWCwBfs+va4Ze64Z14Q
	 aunjzbNQmWcoIEWoxsO7F2QHNQv/IYU6dHX47Dju4JBPTTZ61gQOlnuvW74AHJqWuE
	 222kfqiuDAdKrin63ngTQfRR8boz3qwtvyMfTfZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 154/159] drm/xe: Use devm_ioremap_wc for VRAM mapping and drop manual unmap
Date: Tue, 21 Oct 2025 21:52:11 +0200
Message-ID: <20251021195046.878812650@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit 922ae875230be91c7f05f2aa90d176b6693e2601 ]

Let's replace the manual call to ioremap_wc function with devm_ioremap_wc
function, ensuring that VRAM mappings are automatically released when
the driver is detached.
Since devm_ioremap_wc registers the mapping with the device's managed
resources, the explicit iounmap call in vram_fini is no longer needed,
so let's remove it.

Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250714184818.89201-2-piotr.piorkowski@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: d30203739be7 ("drm/xe: Move rebar to be done earlier")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vram.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -156,7 +156,8 @@ static int determine_lmem_bar_size(struc
 	xe->mem.vram.dpa_base = 0;
 
 	/* set up a map to the total memory area. */
-	xe->mem.vram.mapping = ioremap_wc(xe->mem.vram.io_start, xe->mem.vram.io_size);
+	xe->mem.vram.mapping = devm_ioremap_wc(&pdev->dev, xe->mem.vram.io_start,
+					       xe->mem.vram.io_size);
 
 	return 0;
 }
@@ -278,9 +279,6 @@ static void vram_fini(void *arg)
 	struct xe_tile *tile;
 	int id;
 
-	if (xe->mem.vram.mapping)
-		iounmap(xe->mem.vram.mapping);
-
 	xe->mem.vram.mapping = NULL;
 
 	for_each_tile(tile, xe, id)


