Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4A31F03DE;
	Wed, 25 Feb 2026 01:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983043; cv=none; b=g6QLxI2O95LZe3NHup9ymfYFIvRw2pP5uhUh0k8BQaiE+nDSrpnFDX5gaGCbJeOOzP6uvV/rfGAA/+YDp5WUJ+Dv/OCmmeNuYA3YjyuRtzYo607bH+lqVTbXN9eDdVQ4yjP6EoyonkYPMWaWFakTuf8FBIM1TyFdp/npSYLCDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983043; c=relaxed/simple;
	bh=+FMRZdwn26PdYbx4BygU6TozC8GRlkvXoYdppNJQ+mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5e8DjS7f3wkjA5B/eNh5eYf4ngDRMWH4aogbvgmeR1isAGBNQqrqdy0LxNoaMunL9dWjwZIiuQGAL0Fq5/7ilFeniOM3ry72uAeu3O9QVoq288WnsFpDpN3p08rO0gJB4SiTl4z1FkNVA0xBHFVMp9T5g0W/h1fk7+b8qImrp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqmZ81QD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqmZ81QD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D88C19423;
	Wed, 25 Feb 2026 01:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983043;
	bh=+FMRZdwn26PdYbx4BygU6TozC8GRlkvXoYdppNJQ+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqmZ81QD1+mrEpHqy3q6ci+yYpMF4sln7fg/SDsE+G0syhmxt4xPn2l/jOVDKRoMI
	 hlArgUXUZcWGXi2KxmJIHsQIw+V7F2zggEQwgwSDjAXlBQ97DIGFmBjBYC1d1rJdhe
	 tkUmoY/PpGWup7uOJauAEYXby9xeqQtSRINtzYck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 164/781] soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
Date: Tue, 24 Feb 2026 17:14:33 -0800
Message-ID: <20260225012403.674144810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6259094ee806fb813ca95894c65fb80e2ec98bf1 ]

In svs_enable_debug_write(), the buf allocated by memdup_user_nul()
is leaked if kstrtoint() fails.

Fix this by using __free(kfree) to automatically free buf, eliminating
the need for explicit kfree() calls and preventing leaks.

Fixes: 13f1bbcfb582 ("soc: mediatek: SVS: add debug commands")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
[Angelo: Added missing cleanup.h inclusion]
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index f45537546553e..99edecb204f25 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -9,6 +9,7 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/debugfs.h>
@@ -789,7 +790,7 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 	struct svs_bank *svsb = file_inode(filp)->i_private;
 	struct svs_platform *svsp = dev_get_drvdata(svsb->dev);
 	int enabled, ret;
-	char *buf = NULL;
+	char *buf __free(kfree) = NULL;
 
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
@@ -807,8 +808,6 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 		svsb->mode_support = SVSB_MODE_ALL_DISABLE;
 	}
 
-	kfree(buf);
-
 	return count;
 }
 
-- 
2.51.0



