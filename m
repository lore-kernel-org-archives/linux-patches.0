Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E632F691F;
	Thu, 28 May 2026 20:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998865; cv=none; b=k+xjfneP39TrF38N3UHowooOZ1u5l7Dgn+S8ePT2BVscY8H5SOoiaocgZu0hoB19v0xaVvDgddGZqUIU4Paks7GPZzFeD2xYWcya3RLE50kNqfzysuPRRnxT3NTGh+TMjacDMxUHzacKy5m2hryI2zu4CgZAesQE6iKyEdg/TJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998865; c=relaxed/simple;
	bh=fI/NOrxAssAHQyV9Pv91m6l5/UctrScZdPwKx1WjYGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvguBgTe6sRlfDA0ZnvyA0q4HI7nsbyKTj/pYs+Xy8zAKLkzp4RBesGYw9eLVTQkFBjvRD6SQQSsEDO4iT3bkScjhauvbmEpGlah7EzeRCJ7j1gTwUQWUx6jP+S7TRyaRMF8WnF9sbpXLGCM3aNkzrUgVJ5IThG51LkMDjpH3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWTHBMoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWTHBMoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D041F000E9;
	Thu, 28 May 2026 20:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998864;
	bh=laRKNTFrgoG4lYd3L4LsSQuiyySx0OJJq4GrfIe7Fxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWTHBMozFZoejL6h/zjDnHX67AeeSYwFQCrbbkhlpZjxQx8FY0XSKxK6BN5yWnlry
	 vNbt/IbBTQ+lVZsCh2t7i9SSISsGu5ASwSfIBYSMM9Awi2O5zrixDzBMFToBWcI5r8
	 ZEX6JPoPoUgr5z+ZYzqMct2IeOLV4weVTqlaJ6XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 326/461] x86/xen: Fix xen_e820_swap_entry_with_ram()
Date: Thu, 28 May 2026 21:47:35 +0200
Message-ID: <20260528194656.780896021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 28e03f78e69cf6628b81f24777799778528a84c1 ]

When swapping a not page-aligned E820 map entry with RAM, the start
address of the modified entry is calculated wrong (the offset into the
page is subtracted instead of being added to the page address).

Fixes: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Reported-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260505102417.208138-1-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index ac8021c3a997e..d4738e03a63a4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -655,7 +655,7 @@ static void __init xen_e820_swap_entry_with_ram(struct e820_entry *swap_entry)
 			/* Fill new entry (keep size and page offset). */
 			entry->type = swap_entry->type;
 			entry->addr = entry_end - swap_size +
-				      swap_addr - swap_entry->addr;
+				      swap_entry->addr - swap_addr;
 			entry->size = swap_entry->size;
 
 			/* Convert old entry to RAM, align to pages. */
-- 
2.53.0



