Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2A229B78B;
	Sat, 30 May 2026 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164202; cv=none; b=mn7Ian59Ib+I7kIOK2l2lPXUyFUOrY3h5i7MZOUIQHIhvHoGtMDHhsYVuoxX+zep9l7yUDlwq6Gnvo/DRb3TCa/FWitP6sXZqzVmiYx2Xs/lWBERYoRAQ55ce4es6bhYr+hUOWir0NU6GnKAKF/5omVyjyXyhBph45ZGU0BcAe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164202; c=relaxed/simple;
	bh=1D9GHeZWEwaZvz59Nbu1+W4db+0t0EPNLcdjIiTb5zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owX0b7y8ssgkWzLK+9ZzG49NkGPGdJIkpg3cSkT3g4DpD/+FNg4ReU1hAcb0zNEVp05Vg2OvIHyHX0JV/60/IAwW7e7SYoT2rt5LrE2YPYZj/u6Y4y0nAYpjcS1RCJCkkNY+tUiG0IdoeJet5NCGLbUjrww4BPxJgOVRKPvlTKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC64jaq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC64jaq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81541F00893;
	Sat, 30 May 2026 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164201;
	bh=hyvsliSRVcv67eqkAbhzpt23h9d07u9NcItLImYOnJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CC64jaq7X3+L0XsexRqlYicQye0KWLOy7psQquE+OzPaXCvoZM4mDlJ/H2Y/pKTL0
	 RRTXgdIhTFrtxsxV0DvovkyDJSTE8lBJ3YxQt0eXtG+STynioy2jYd2SpeqwQHKmHt
	 fgk8CLI//ad1fgBjWf41z1hoRzA9dJzUo0q6Gr18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 484/776] efi/capsule-loader: fix incorrect sizeof in phys array reallocation
Date: Sat, 30 May 2026 18:03:18 +0200
Message-ID: <20260530160252.843209028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 48a428215782321b56956974f23593e40ce84b7a ]

The krealloc() call for cap_info->phys in __efi_capsule_setup_info() uses
sizeof(phys_addr_t *) instead of sizeof(phys_addr_t), which might be
causing an undersized allocation.

The allocation is also inconsistent with the initial array allocation in
efi_capsule_open() that allocates one entry with sizeof(phys_addr_t),
and the efi_capsule_write() function that stores phys_addr_t values (not
pointers) via page_to_phys().

On 64-bit systems where sizeof(phys_addr_t) == sizeof(phys_addr_t *), this
goes unnoticed. On 32-bit systems with PAE where phys_addr_t is 64-bit but
pointers are 32-bit, this allocates half the required space, which might
lead to a heap buffer overflow when storing physical addresses.

This is similar to the bug fixed in commit fccfa646ef36 ("efi/capsule-loader:
fix incorrect allocation size") which fixed the same issue at the initial
allocation site.

Fixes: f24c4d478013 ("efi/capsule-loader: Reinstate virtual capsule mapping")
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/capsule-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 97bafb5f70389..c6a8bdbcae71b 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -67,7 +67,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 	cap_info->pages = temp_page;
 
 	temp_page = krealloc(cap_info->phys,
-			     pages_needed * sizeof(phys_addr_t *),
+			     pages_needed * sizeof(phys_addr_t),
 			     GFP_KERNEL | __GFP_ZERO);
 	if (!temp_page)
 		return -ENOMEM;
-- 
2.53.0



