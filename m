Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A0046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8206DC433EF;
	Mon, 16 Jan 2023 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886153;
	bh=IoBwvQBfnAWsNK+WzDnaiuMJlvW27xC2l5fId9zx01M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHi4B3S8lu6oSfXDQmdIAQK4txFARFItfxnfizpvJFh+pGRWMtEF1sWgGP6fyH/FW
	 FYmpGlLR1Uf1MG1mRPBxN7FXxNMV+yf1gIxtCMSDdpcQiLEXaVr9olLl0gOckF7Wal
	 9yFIN3ghsUsZyd/BX1Ag/gxsEbVwg6tyVRE/KX10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 315/658] samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
Date: Mon, 16 Jan 2023 16:46:43 +0100
Message-Id: <20230116154923.972819944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit d1f0f50fbbbbca1e3e8157e51934613bf88f6d44 ]

Add missing pci_disable_device() in fail path of mdpy_fb_probe().
Besides, fix missing release functions in mdpy_fb_remove().

Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Link: https://lore.kernel.org/r/20221208013341.3999-1-shangxiaojing@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/vfio-mdev/mdpy-fb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index a760e130bd0d..8ad1aa13ddd9 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -109,7 +109,7 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 
 	ret = pci_request_regions(pdev, "mdpy-fb");
 	if (ret < 0)
-		return ret;
+		goto err_disable_dev;
 
 	pci_read_config_dword(pdev, MDPY_FORMAT_OFFSET, &format);
 	pci_read_config_dword(pdev, MDPY_WIDTH_OFFSET,	&width);
@@ -191,6 +191,9 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 err_release_regions:
 	pci_release_regions(pdev);
 
+err_disable_dev:
+	pci_disable_device(pdev);
+
 	return ret;
 }
 
@@ -199,7 +202,10 @@ static void mdpy_fb_remove(struct pci_dev *pdev)
 	struct fb_info *info = pci_get_drvdata(pdev);
 
 	unregister_framebuffer(info);
+	iounmap(info->screen_base);
 	framebuffer_release(info);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
 }
 
 static struct pci_device_id mdpy_fb_pci_table[] = {
-- 
2.35.1



