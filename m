Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F426FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB865C433EF;
	Mon, 16 Jan 2023 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888985;
	bh=lNexJotvUxQyAIKn9DYfX4roNZbST8vF+2nw6cUaxxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV/I3psNAph7MBpYA0RKC66L08gHYlCf7k1kCV+g6bCVlgXy4X/xEmi20dpUPY7Zx
	 aeRJ6tXJFr3nKZIiaoSSLv/HI9RTz3gZrrvG/GdlDHfvHg4xLcaw7uoerdH58s7UHF
	 c0rFGAcELD8Wo/9XGPuxd7EQZtpR+tq0JeUyeWoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 184/338] fbdev: vermilion: decrease reference count in error path
Date: Mon, 16 Jan 2023 16:50:57 +0100
Message-Id: <20230116154828.960925161@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 001f2cdb952a9566c77fb4b5470cc361db5601bb ]

pci_get_device() will increase the reference count for the returned
pci_dev. For the error path, we need to use pci_dev_put() to decrease
the reference count.

Fixes: dbe7e429fedb ("vmlfb: framebuffer driver for Intel Vermilion Range")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vermilion/vermilion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index 6f8d444eb0e3..b732ea6d0be6 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -291,8 +291,10 @@ static int vmlfb_get_gpu(struct vml_par *par)
 
 	mutex_unlock(&vml_mutex);
 
-	if (pci_enable_device(par->gpu) < 0)
+	if (pci_enable_device(par->gpu) < 0) {
+		pci_dev_put(par->gpu);
 		return -ENODEV;
+	}
 
 	return 0;
 }
-- 
2.35.1



