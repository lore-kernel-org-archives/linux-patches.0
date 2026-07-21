Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9146AA70;
	Tue, 21 Jul 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648143; cv=none; b=RTzqKOBGH2LQccrZrfRZdqA40rp0TrBadDfHYWeBWfxlAQlZabmK941oudsagKqHQpsaKZNVukHTnbrToFAJJU2+egmRYw8lBhdIp62Yf9Btl7z03cX1XjWaTViD5ABKkbEF4e7G8Iz6zTvQ15xyzqh5B8zs/l3FiwIBpxeNfRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648143; c=relaxed/simple;
	bh=2irC+n/ZqDPvs+iUBytlYXWeRVsNj5HtrvEwjR1qW80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUlrCc4JOcb43K4q+bg9A/GVT9dcPHMCB655JC8ILDGVR1YEABspn4Ne0BxXIG7ZGXEtOv0JEIdxwcDjff5A4ejSxJ8mJf3tJVgBPp0bsn80Vx82zZzRFHbBJlNejg7IbcyMwVu9eImVCEPoV7AN0aHLDrnqaD/X8QfwXzNCCzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7Txiyb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7Txiyb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4FC1F000E9;
	Tue, 21 Jul 2026 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648142;
	bh=qgNruFG4TUdGaYUcvObVZFgl3X4qcdpOIkU8qr6GNds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7Txiyb7HJJUzGcfuhcgejtd3SvKvAXGh49kRoPx3E2lRM56/D8KiCjYn3jjVycvM
	 ZPnBvn30GZEUdMagyopxdfZpAsF3oY23ZT/IgOPqxNaUweoaQ/0LvX6R9kBGsMqDCa
	 u5clH97hX4EbpNKqHkBaXcl6a1Bh5pX7KUiGIZe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0044/2077] accel/amdxdna: Fix leak when pinning ubuf pages
Date: Tue, 21 Jul 2026 16:55:17 +0200
Message-ID: <20260721152553.726120389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Zhen <max.zhen@amd.com>

[ Upstream commit d946347edc4f0a7b846325323d77e936a4c90d0f ]

When pin_user_pages_fast() returns fewer pages than requested, the pages
that were successfully pinned are not released, leading to a leak.

Fix this by unpinning any partially pinned pages before returning failure.

Fixes: bd72d4acda10 ("accel/amdxdna: Support user space allocated buffer")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260326010642.2596525-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ubuf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 85390e3cc9f982..0e0cd69cd1fbfc 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -146,13 +146,17 @@ struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
 		ret = pin_user_pages_fast(va_ent[i].vaddr, npages,
 					  FOLL_WRITE | FOLL_LONGTERM,
 					  &ubuf->pages[start]);
-		if (ret < 0 || ret != npages) {
-			ret = -ENOMEM;
+		if (ret >= 0) {
+			start += ret;
+			if (ret != npages) {
+				XDNA_ERR(xdna, "Partially pinned pages %d/%u", ret, npages);
+				ret = -ENOMEM;
+				goto destroy_pages;
+			}
+		} else {
 			XDNA_ERR(xdna, "Failed to pin pages ret %d", ret);
 			goto destroy_pages;
 		}
-
-		start += ret;
 	}
 
 	exp_info.ops = &amdxdna_ubuf_dmabuf_ops;
-- 
2.53.0



