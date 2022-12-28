Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C07C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2092BC433EF;
	Wed, 28 Dec 2022 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244890;
	bh=srXs20Sx1Vm4Sgsww+fon6BnnfceytwJKVU73sknZUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUBwvM+b92LzKPgNzc+8MRks10YQFnQ+JjtbMaX3KGaowYhhKavpbQ+hXRqSXv+9u
	 8nns9Ckt/OSAMflIdmDJd+Ooe3hGHTM8yzCFztLdJkdE6vD+Y4DTsMWh+BTqIir/WR
	 FhsOFi1EQVIseSgRs+/ZhlXQQBNa9soiXQ4+d2z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0757/1146] fbdev: vermilion: decrease reference count in error path
Date: Wed, 28 Dec 2022 15:38:16 +0100
Message-Id: <20221228144350.705406538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 82b36dbb5b1a..33051e3a2561 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -278,8 +278,10 @@ static int vmlfb_get_gpu(struct vml_par *par)
 
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



