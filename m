Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E26348C45;
	Thu, 28 May 2026 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001600; cv=none; b=mReYzvzSdVkd3pdM4xkKstmnfYH6Z72wrRC4l9sn5I+oPzPti0kP2XgB/8HwmFzdWhf+NWQ8PlnFyniVZ0w5lQd6nxzte9OwkhNpDNGRFGHORQi7XTRGaQ4qEiJPb5oWCfXE5VUdnyHNrL0iJdKsIiWz1T0C0X4l/jXZjsYdbMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001600; c=relaxed/simple;
	bh=RkhNBMM2tevv2WCjHlIqVjFlLTLmSdR6dPkCcGORNMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFGehK8sxNg6KE4Gsmer+8RX25QmRF7PmhcXBrJizq0MbeVs0NXlDKBvJASByMLa1d88CQ5sBUAd25uLt5xAx/2T0R+z9zid2AfY7a/0mc2irldbdD3E8NcV1HBcRYyoNhFSclHIY1J4bToBnHjCauhhdIWEKy6kKXl2B0Yn49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhIP6u9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhIP6u9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968DE1F000E9;
	Thu, 28 May 2026 20:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001599;
	bh=G/3e2Yyrd6qz2qBa5bLLf5nrZxnMdsNWAwndiQ1En94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhIP6u9A/HLokbrpMMdrnILPUQUq18WYxubzqTESevCOnut1/LUyQrc0VK0KbRuN/
	 MBoG48lJi3AGFRbPX6X4BO2utqs1qyQgej3j/7dRd8+8ak8c63ywN21nDP1GS6zctu
	 FQ9IUcp+l7QkPX5LKqu1jAmVZl37P9xtnoBDqQM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/186] x86/xen: Fix xen_e820_swap_entry_with_ram()
Date: Thu, 28 May 2026 21:50:28 +0200
Message-ID: <20260528194932.951888238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec3ffb94807d3..3d5236fa54dd6 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -656,7 +656,7 @@ static void __init xen_e820_swap_entry_with_ram(struct e820_entry *swap_entry)
 			/* Fill new entry (keep size and page offset). */
 			entry->type = swap_entry->type;
 			entry->addr = entry_end - swap_size +
-				      swap_addr - swap_entry->addr;
+				      swap_entry->addr - swap_addr;
 			entry->size = swap_entry->size;
 
 			/* Convert old entry to RAM, align to pages. */
-- 
2.53.0



