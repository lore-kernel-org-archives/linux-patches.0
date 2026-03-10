Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A83859E3;
	Tue, 10 Mar 2026 11:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140802; cv=none; b=Da2J/GfDIUzlRnInDaaDav/7+sYgmoNYNMn7jAmOvIgGDVdJgCLPwJVoid2+fcGAkKB+Rip1AiEN/hE+piWYj1M1WxteDjZ95ipNRlnwbAtrBNUGx/UVRd9GxVYdIg10hEYXj07VPBeldyRp1ywhUEFvgfOCBe1CDLG/Gqz0gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140802; c=relaxed/simple;
	bh=C+eWog7JoMIEXV5o4imtsRWCvpVE3z/HqZkN7rheiCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti1/zSfTiSR7C3g0iT6VbWspHSSOhxBBybyloIdufhW4GjjTyy07Qa1de6UdCixz1xG/NKCBXkTUhlSU7m3sfKhzp0S9+7QobVwCH5fRqiYrdwTAga6q4UKks00/DFeTCiqf2E9pLZGrlHXOY+Hp854XehNi5O3WHP8CPFVaSWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXVu5Ac5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXVu5Ac5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B0EC2BC86;
	Tue, 10 Mar 2026 11:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140802;
	bh=C+eWog7JoMIEXV5o4imtsRWCvpVE3z/HqZkN7rheiCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXVu5Ac5ZrN2f7DZODW5YIzBhHIWu/jtLF7HYdc7E8hMUc2HAjKBM/Fr27Avvm2Lw
	 NeXO93p+yjRSFrQJrpvBeQ8bdgyKjDdpH1oHlHWQDWLxAu+vpFqCMNibftqg1kYKAX
	 pi+Lvwo7YWaz3mYsnQMGIFjohlyw1o5lCUmOm52fNnZJ+GnbHp2P+BYkZ61VZzpoE1
	 Os6ribdRkC9FKJqBtsJmkNBTmjZgjXQnZcZXNtN1lhaLNVt07GfIoveR7w9J0UG+kw
	 hBD7ALj/LLc+y75qYTV80VWqJ4Y9Xo0GomKf3xjzbW7W6M9goQB9YcSaqUVNMXaOyW
	 uwIS+sB6BpJog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 040/311] accel/amdxdna: Prevent ubuf size overflow
Date: Tue, 10 Mar 2026 07:01:27 -0400
Message-ID: <9e0e393a0e63bccd6efec30d2aa6afae0f1b89f4.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 03808abb1d868aed7478a11a82e5bb4b3f1ca6d6 ]

The ubuf size calculation may overflow, resulting in an undersized
allocation and possible memory corruption.

Use check_add_overflow() helpers to validate the size calculation before
allocation.

Fixes: bd72d4acda10 ("accel/amdxdna: Support user space allocated buffer")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260217192815.1784689-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ubuf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 9e3b3b055caa8..62a478f6b45fb 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -7,6 +7,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_print.h>
 #include <linux/dma-buf.h>
+#include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 
@@ -176,7 +177,10 @@ struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
 			goto free_ent;
 		}
 
-		exp_info.size += va_ent[i].len;
+		if (check_add_overflow(exp_info.size, va_ent[i].len, &exp_info.size)) {
+			ret = -EINVAL;
+			goto free_ent;
+		}
 	}
 
 	ubuf->nr_pages = exp_info.size >> PAGE_SHIFT;
-- 
2.51.0

