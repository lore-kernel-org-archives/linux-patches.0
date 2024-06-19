Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2375682871;
	Wed, 19 Jun 2024 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802270; cv=none; b=QiCm/hdr/SNWQolDSNsH9ryvEvAAHfVE/B+vQ1pgbI6sEn4ClVi63RTmTv9yNeBpkvIRGBSoj4l46oilUOAfjzUhKNKPdLOBkt47MdOUSTQtItif+/zW6ivAaWOHlCIrb6sK7mHO/1aAWJX14SP0BPntAnwJmLX4QhAzdCr7Y3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802270; c=relaxed/simple;
	bh=848hdcEFA8QQRiPjLogxnqrzm9WSSRk3QWuNX6lA2yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGtdDHe4xpftFAjsF+eDyrcqYb/INSB55813d9vPbFe6fhQbdilYBJpOgQBvz2xWL9BVd6xuU7MpXP9CCjC3gyRmDyrHcfnB3YkquMj0yNRGsG/jh48vxntOTXJQvK4tYSRTw7JZAXmdw4IekmMREhz/rSJEoBZt2NvkmLUxsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y134mFdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y134mFdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939BCC2BBFC;
	Wed, 19 Jun 2024 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802270;
	bh=848hdcEFA8QQRiPjLogxnqrzm9WSSRk3QWuNX6lA2yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y134mFdO+VOTwwqR45RNSXzuQqbMb87IT66iNT8pGwGTUW6neI8iDIx+DYu3nYQna
	 dQJi3fTryVPbwM10EJXwwS86Megqsc0ABm8z0ojSVH20hcDx+z5tFn6dB6o4PPW2V9
	 +A+B7vJAlyCvzYdTZq+FNlawO/4Naf8tRzcVQwtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/267] drm/vmwgfx: Dont memcmp equivalent pointers
Date: Wed, 19 Jun 2024 14:54:50 +0200
Message-ID: <20240619125611.683397158@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 5703fc058efdafcdd6b70776ee562478f0753acb ]

These pointers are frequently the same and memcmp does not compare the
pointers before comparing their contents so this was wasting cycles
comparing 16 KiB of memory which will always be equal.

Fixes: bb6780aa5a1d ("drm/vmwgfx: Diff cursors when using cmds")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328190716.27367-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 93e2a27daed0c..08f2470edab27 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -216,7 +216,7 @@ static bool vmw_du_cursor_plane_has_changed(struct vmw_plane_state *old_vps,
 	new_image = vmw_du_cursor_plane_acquire_image(new_vps);
 
 	changed = false;
-	if (old_image && new_image)
+	if (old_image && new_image && old_image != new_image)
 		changed = memcmp(old_image, new_image, size) != 0;
 
 	return changed;
-- 
2.43.0



