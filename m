Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E71448DA;
	Thu, 13 Jun 2024 12:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280441; cv=none; b=W5pkTx4Fc0YV9dpXRT5JexsCFLYgIhMJo5vcg5UuiMvOT9RGaViTD87slSLrorON8ApXGv6tDc7wSP2DebXhaeT2HfywI38bXoV1BNl0ABPSHIGjvSryITC52RWc5JWjbou+OXwLdMlhC0nn2z0KDte81sc7OlalbRyQRLSgIEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280441; c=relaxed/simple;
	bh=WRjv5Qh2mLjHbxy4hrNzMOn/PIv9w/ROzHY4E5XI5Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSM69MoEFZC6j2WdXMQQrZfX2I3jdBmKIXsI/Ltk/NhCXllAzJPBpGhZG+3M8xpbJu0WpY3eZZe6yC90d0EpRZ7R4NRubHjdoDL82dvBN4uNcI83H/M0Vo1ou5Iblm/WwhtAtVG29zJQY4hpkJ8YXol/EyJLV9kVCGPFIxqta3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG4WtraB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG4WtraB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B2FC2BBFC;
	Thu, 13 Jun 2024 12:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280441;
	bh=WRjv5Qh2mLjHbxy4hrNzMOn/PIv9w/ROzHY4E5XI5Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG4WtraBSaotBF809Dl+8neQBgO+iDtvosGfGOH0S64rznvOKjHIuzug8+uJ1MhEd
	 eUBdtoeV+SE433B8Z5T8D8OCj1qDch+krTz9erxifrsG3ElJw2mJ8BXPqknQwl9Yc5
	 y1pgjJgZB5q/oUc50PVcF0J0/oUlI+opJcvqdZ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 055/137] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:33:55 +0200
Message-ID: <20240613113225.428233193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

commit 6ad959b6703e2c4c5d7af03b4cfd5ff608036339 upstream.

The commit 04e5eac8f3ab("fbdev: savage: Error out if pixclock equals zero")
checks the value of pixclock to avoid divide-by-zero error. However
the function savagefb_probe doesn't handle the error return of
savagefb_check_var. When pixclock is 0, it will cause divide-by-zero error.

Fixes: 04e5eac8f3ab ("fbdev: savage: Error out if pixclock equals zero")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -2276,7 +2276,10 @@ static int savagefb_probe(struct pci_dev
 	if (info->var.xres_virtual > 0x1000)
 		info->var.xres_virtual = 0x1000;
 #endif
-	savagefb_check_var(&info->var, info);
+	err = savagefb_check_var(&info->var, info);
+	if (err)
+		goto failed;
+
 	savagefb_set_fix(info);
 
 	/*


