Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F308E43AB9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNbyovIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AA4C433C7;
	Wed, 15 Nov 2023 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081175;
	bh=MrPFzjV04OIW7J5PY3FAhh618fam7m7ql0+P8JEnOT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNbyovIY4bgnWNdNOH/7J1YyV/cZeoWTcJO5CpIHEcUkEjCzOA+bs84DOUYs+Rd/3
	 nMyWkQxq+koc6BP33CDyCD2Fnj2ByxFx0KYw8Zw/IuVCobnmYM+PQIXxcQhnpfuMEc
	 MMtnMilbmXB4RNFppPRyGyiR1ibs0KoN5nwL4ddc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 84/88] fbdev: imsttfb: Fix error path of imsttfb_probe()
Date: Wed, 15 Nov 2023 15:36:36 -0500
Message-ID: <20231115191431.095137053@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 518ecb6a209f6ff678aeadf9f2bf870c0982ca85 ]

Release ressources when init_imstt() returns failure.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: aba6ab57a910 ("fbdev: imsttfb: fix a resource leak in probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 4a3f89b223600..9a9018d143761 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1529,8 +1529,10 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error;
 	info->pseudo_palette = par->palette;
 	ret = init_imstt(info);
-	if (!ret)
-		pci_set_drvdata(pdev, info);
+	if (ret)
+		goto error;
+
+	pci_set_drvdata(pdev, info);
 	return ret;
 
 error:
-- 
2.42.0



