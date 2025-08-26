Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A002FBF0;
	Tue, 26 Aug 2025 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214061; cv=none; b=ua+1QCt8zxq7kNUTWwVkXil7OQJ9HAc4lh4y29iTH9Je05+/oEZev7E1ZcQws/37rmpvMFYUlSZrDNiWGqJOcB7YQPtrIRDnOx8cczPImbO8t+c31rea/yL9jOfufHICvDbM3BCRadJx3g4WvMhfdSdnBnwVueN/9ArhqZlSUu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214061; c=relaxed/simple;
	bh=iz+TOzIs+SgoO98dcDiw8J436hWZggtmCeil8cSGcrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxHCcYlBZdVFLCmgASNDwudMxBJwcbG/qjFd5TJeZrgLyfxe674WI3fYLaq0Dlma1aKPcLHDmwFdDvFrzrKGHlE1E8PjD1PLXLl30hVBpQ365zmgbp/uRJ51XQwxIQjGKvknV3Tk4P4KdA87sdXoEvGbmJWhVQ9jU2sd+kwx2s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KkLizAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KkLizAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E77C4CEF1;
	Tue, 26 Aug 2025 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214060;
	bh=iz+TOzIs+SgoO98dcDiw8J436hWZggtmCeil8cSGcrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KkLizAyQZyz8oRjjRvTa+PxCxQLstYlVKl4v0d0mQS5JKZ1BNH//olJJ/fbEin4l
	 +YfVJXwst0fHaoNpBdN7CI6WjXMCuZzAp1cxETwtO2sy43xTzrzcjEB8VazShBkpY2
	 ZkKUIo3lxis/JbDaApY2QbNuLyR13jwUKDl/3ENI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 551/587] iosys-map: Fix undefined behavior in iosys_map_clear()
Date: Tue, 26 Aug 2025 13:11:40 +0200
Message-ID: <20250826111007.038542880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit 5634c8cb298a7146b4e38873473e280b50e27a2c ]

The current iosys_map_clear() implementation reads the potentially
uninitialized 'is_iomem' boolean field to decide which union member
to clear. This causes undefined behavior when called on uninitialized
structures, as 'is_iomem' may contain garbage values like 0xFF.

UBSAN detects this as:
    UBSAN: invalid-load in include/linux/iosys-map.h:267
    load of value 255 is not a valid value for type '_Bool'

Fix by unconditionally clearing the entire structure with memset(),
eliminating the need to read uninitialized data and ensuring all
fields are set to known good values.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14639
Fixes: 01fd30da0474 ("dma-buf: Add struct dma-buf-map for storing struct dma_buf.vaddr_ptr")
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250718105051.2709487-1-nitin.r.gote@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iosys-map.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/iosys-map.h b/include/linux/iosys-map.h
index cb71aa616bd3..631d58d0b838 100644
--- a/include/linux/iosys-map.h
+++ b/include/linux/iosys-map.h
@@ -264,12 +264,7 @@ static inline bool iosys_map_is_set(const struct iosys_map *map)
  */
 static inline void iosys_map_clear(struct iosys_map *map)
 {
-	if (map->is_iomem) {
-		map->vaddr_iomem = NULL;
-		map->is_iomem = false;
-	} else {
-		map->vaddr = NULL;
-	}
+	memset(map, 0, sizeof(*map));
 }
 
 /**
-- 
2.50.1



