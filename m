Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE23144D3E;
	Wed, 19 Jun 2024 13:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803123; cv=none; b=FWbsHZKiPXxhggGoZ6cwDVZKeKxbpH4n5Gs5WjW06s4nGDX/DR1brejA4r+Avu13cuXuYXU8UKGfgrwFlaJJFXrPg6qXJkspoVQt7SOxdl7LwqbeGHpUf/vwgCo7zIi8WI7ibfNFJCd+6JgnhehgtekkETpybMjM6Js2CM18ofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803123; c=relaxed/simple;
	bh=CRY9K3TNyRQ8TJQ3nBbMfx6HLjePLJUP7HBADSkjrbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pysTqLqZQBaDmLEN/MhVAuDNvnIkWzK+0fW4Azt9vBzwEbwLRH9dbTtus5r2ZYXwEn2mC1dvUSHg9BQ4iAXltzxsH4fGlN6ZzSziUJIsxx50ZSmBKSXc3h27SoiPKeUi5q2hb0p2mesZt/h7tnCLZTrCk0n9YD49Z2CAe68+pKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdD2XXEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdD2XXEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70346C32786;
	Wed, 19 Jun 2024 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803122;
	bh=CRY9K3TNyRQ8TJQ3nBbMfx6HLjePLJUP7HBADSkjrbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdD2XXECBchryJ8Boy8kNKBaS0BySXo71QRzJjHMvuQ0G/6VXH9nN5FFdvjyIv5ES
	 XIkUQ1iXeZncUNHYXjYr1uhKCWH9S/SR5VSLR8xI+xCPOXo8JU6IxWhUIls4ZkJ+kt
	 m1OwW6GiJEGGBvagrGoBB2fP2bFady4KfdLiquxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 143/281] drm/vmwgfx: Dont memcmp equivalent pointers
Date: Wed, 19 Jun 2024 14:55:02 +0200
Message-ID: <20240619125615.344067005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 42fcf4698aba9..11755d143e657 100644
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



