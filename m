Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4874F21B8F6;
	Mon, 23 Jun 2025 22:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716860; cv=none; b=pogTAiaeMbdZGkVT4gLDSYYpM5EXUex85ejohjaSn+lZLTKm/WgzUj9rZh7a7qyrH3rjYhJ7MCacxKXbaWKvL1h+Xh8X5bADdoHMuu81Bf5Gt7n9ydUTfYfYUBLm8K1LFU13mNNDiqKzp8tR/6tTuebie9sFH2NRIgyBlD98b90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716860; c=relaxed/simple;
	bh=PCsHjhSSbUY/grINkEo112OKh7rFVQQyEU8Lffu/J1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9e4m27lFuxm2UjNtRynlK196BGZ1/U6VdnvuW+qhUy0XJK9gAZ1ubntsTyOr0YRoE1EAGwhOpdr4oFfgEfto5xKhhzngoSLFuRUa2ps+s79sLO4G7buy15XwFDWjpyi+awvmdDX+jdHJcFjWtIqL733yPritgdar0IQ1EknBis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZqGcdgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZqGcdgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E488C4CEEA;
	Mon, 23 Jun 2025 22:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716859;
	bh=PCsHjhSSbUY/grINkEo112OKh7rFVQQyEU8Lffu/J1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZqGcdgtZFH/+fzdESvpF94CwwOXOFJvWsRBee8kgrNK/omC7FBRa2CoW/Igd5ycT
	 FdHyv2Z99y54GVuqcSDXr+G/cG62WfKEyT0dRrcSoWpminmRvSqRJHTRFFWo9W82q5
	 52VPbsBrkDJcx4yMYCUpxEZTFQKm75JA94PyMvfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/414] platform/x86: dell_rbu: Stop overwriting data buffer
Date: Mon, 23 Jun 2025 15:07:09 +0200
Message-ID: <20250623130649.311829444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



