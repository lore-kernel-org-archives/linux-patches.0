Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4946D2B3;
	Tue, 21 Jul 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655569; cv=none; b=ZQy/rfyMqStarwRKf5UPzC2uzF0izso8oAqwmorTl9v7eOxzmu9W0A/EVVWVSsQe6vnNmQyMzzeIZ6v+RCVQ5L3+GbinHo9muFMBJQr14m7uMKCtPgjN3eAK3K9WgiFv03pYNflKvzYwwmUEEE2VpiGmArKWXO+1w8Rg/FPpxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655569; c=relaxed/simple;
	bh=sPhudrAX9ik3Y0ZAD+PyvuaepPLP5K1HOcF3zygoCj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfQLus69I3s3Q9ioY2XxWvdwxXaI/2SefIrWbSLt7nlqEQ2fLRpgxu+FFg8UkaJgv7k6p2FSZNGCcaHPnHyx6fJ3KVM38LG1rF01DebHHgOGMwr9PF9Tz0VQRw/mY9Ztv9RC/i5ODEY4+GFqVDBlIOEn/0yGnq8VIwlln19L9rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN7dtXi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN7dtXi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431071F000E9;
	Tue, 21 Jul 2026 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655567;
	bh=oifqVQ6QWSHFF4kxJ+l6nNAzGJfFhNteUYZKK1UHxrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PN7dtXi3qqRu2mVCX2gvv8WZQf90RXqH/evLb8tfZvH8ffPSC7kpx1aHYN+GqZQ7r
	 SerIE4HunECIhe8lBItlsmHA2nVhFOqShx8vbpwaSKMXo8iJsALptJ2qIMw3CBrvpG
	 qzGH7O1Puys9o9cfqOfFs91GBUhGLv7AStCX20uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0059/1611] accel/amdxdna: Fix leak when pinning ubuf pages
Date: Tue, 21 Jul 2026 17:02:55 +0200
Message-ID: <20260721152516.158431645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 62a478f6b45fb2..9c2e715b769d09 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -205,13 +205,17 @@ struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
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



