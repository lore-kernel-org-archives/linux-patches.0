Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F011347515;
	Wed, 20 May 2026 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300992; cv=none; b=D0ON7jSt1FSTmDZr7eLSRlWiHprTkkTtMMcYAtFaJJf/+JeHVAdQZgYgoCR2Wt+Hz+I69ENWSkDIQOSgWFVf+W5w6T3unPoGv6+2RwDnnABp5MvM2iYk2v1htoDMivjHzMnY3n73DB6waPKvHQmZk+nS8SPq5UWubbyOgzAtqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300992; c=relaxed/simple;
	bh=3B40NH6CQrPAVTZgAcff0HbWiqjLWkBL+kBZlfPw/es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkalfWl7RG7eMWiGyMjRosP/YhgdgF94cyPpHCPkhWfJs4wTEAYbw514KTwLXZb8GGCmEOoGFvItX31/e8RXd15kgW2OYxZjKXcL7NMNCEXeiXTtutf5vycAyDqiwjOQdH3DXXy0b7eA7Ffg42Er/J+Ot4hiOKVzXXZzzar5id0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+1to6LK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+1to6LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A479C1F000E9;
	Wed, 20 May 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300991;
	bh=Uy+TCOlmAtOYgIdEC+F5zrNiDvErBW6Czt+hhuIFyEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+1to6LKYaIsbmWcbkBQ6F65EyHaCWaUY9l21ZNhWEP3hg9JRUMY4nHBZhBlaPIny
	 GFgHo+ITqwdC09O+GlA6j/LNJxREDAh3xPB/vPD3OiFYGmqUxtWmmvF4tKi0Gz12NP
	 90cGchLY/vYaPE2jKl1pSm2Lq7QME16+n3DTF6yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/666] i3c: dw: Fix memory leak in dw_i3c_master_i3c_xfers()
Date: Wed, 20 May 2026 18:19:54 +0200
Message-ID: <20260520162119.554667901@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 256cc1f1305a8e5dcadf8ca208d04a3acadd26f1 ]

The dw_i3c_master_i3c_xfers() function allocates memory for the xfer
structure using dw_i3c_master_alloc_xfer(). If pm_runtime_resume_and_get()
fails, the function returns without freeing the allocated xfer, resulting
in a memory leak.

Since dw_i3c_master_free_xfer() is a thin wrapper around kfree(), use
the __free(kfree) cleanup attribute to handle the free automatically on
all exit paths.

Fixes: 62fe9d06f570 ("i3c: dw: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260404-dw-i3c-2-v3-1-8f7d146549c1@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 6c56e0b89b02d..a60eb86bddba8 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/err.h>
@@ -912,7 +913,6 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct dw_i3c_master *master = to_dw_i3c_master(m);
 	unsigned int nrxwords = 0, ntxwords = 0;
-	struct dw_i3c_xfer *xfer;
 	int i, ret = 0;
 
 	if (!i3c_nxfers)
@@ -932,7 +932,7 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	    nrxwords > master->caps.datafifodepth)
 		return -ENOTSUPP;
 
-	xfer = dw_i3c_master_alloc_xfer(master, i3c_nxfers);
+	struct dw_i3c_xfer *xfer __free(kfree) = dw_i3c_master_alloc_xfer(master, i3c_nxfers);
 	if (!xfer)
 		return -ENOMEM;
 
@@ -983,7 +983,6 @@ static int dw_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	}
 
 	ret = xfer->ret;
-	dw_i3c_master_free_xfer(xfer);
 
 	pm_runtime_mark_last_busy(master->dev);
 	pm_runtime_put_autosuspend(master->dev);
-- 
2.53.0



