Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630CB2222B2;
	Mon, 23 Jun 2025 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717624; cv=none; b=U1C7iTqG0fVbpaEdEIpZTT9UTZBr3HuT5OySGhP8XtPOGbPfNRzjo3Brj9vpEMFuUJWdFLK75iO2yDzloLrIM7h5OBgouw5KPxFO0CjRAZc9wnS5JxaMc4GBDz37GMK5Yl0b2DiebItw+jA83PmNEbpbVH0QKyU0Ab+QH/SCcuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717624; c=relaxed/simple;
	bh=CllhJPJ/7yvNXXv2GUKs5aE58YLWtnYyBkC3n9ylv5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qn+LMWP/34kY/pHAE5PYvfVny2mE8GAP5lJGgGhaAdFNdrBCUDqOF6T8wuJDdS/qzEygqpX7etezp3ktolt1ULGzXbRSr3cRuc9330iEuEx0w0sceA077G3vOy0p5Az/bVLlLkeRvlkEM100cmASme6xVbiS2YdRAJZ8GCIOTOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1unUlh0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1unUlh0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB31C4CEEA;
	Mon, 23 Jun 2025 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717624;
	bh=CllhJPJ/7yvNXXv2GUKs5aE58YLWtnYyBkC3n9ylv5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1unUlh0UKzTdAZ0Sku/vJ5A7DBdUH1jx8HU1dM6i9mGdp+tTwLJtBNh1331IgTUsu
	 ortfJPBrX2q3qoyXElkSgZVmcM6Qbt5lqXtW7v+anJSqGE4Gfg3eR/kStBvQLfTBN9
	 AB4HwmZFfWatYE9l1G+k5Wu76EtB2wg/p6McGmQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/508] platform/x86: dell_rbu: Stop overwriting data buffer
Date: Mon, 23 Jun 2025 15:08:04 +0200
Message-ID: <20250623130655.964279759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit f4b0fa38d5fefe9aed6ed831f3bd3538c168ee19 ]

The dell_rbu driver will use memset() to clear the data held by each
packet when it is no longer needed (when the driver is unloaded, the
packet size is changed, etc).

The amount of memory that is cleared (before this patch) is the normal
packet size. However, the last packet in the list may be smaller.

Fix this to only clear the memory actually used by each packet, to prevent
it from writing past the end of data buffer.

Because the packet data buffers are allocated with __get_free_pages() (in
page-sized increments), this bug could only result in a buffer being
overwritten when a packet size larger than one page is used. The only user
of the dell_rbu module should be the Dell BIOS update program, which uses
a packet size of 4096, so no issues should be seen without the patch, it
just blocks the possiblity.

Fixes: 6c54c28e69f2 ("[PATCH] dell_rbu: new Dell BIOS update driver")
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Link: https://lore.kernel.org/r/20250609184659.7210-5-stuart.w.hayes@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell_rbu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index 4d2b5f6dd513f..fee20866b41e4 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -322,7 +322,7 @@ static void packet_empty_list(void)
 		 * zero out the RBU packet memory before freeing
 		 * to make sure there are no stale RBU packets left in memory
 		 */
-		memset(newpacket->data, 0, rbu_data.packetsize);
+		memset(newpacket->data, 0, newpacket->length);
 		set_memory_wb((unsigned long)newpacket->data,
 			1 << newpacket->ordernum);
 		free_pages((unsigned long) newpacket->data,
-- 
2.39.5



