Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163C43E094;
	Thu, 30 Jul 2026 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424504; cv=none; b=meGRtZpWS2jMj/H+sAIKYI8uLR2/Gn6Erg4/aDeyYxoCqQpm+sPrAqCe8ZRiexfmniKirrFWp3LAAICHWNjICEyX6M3BKPtO+H+CpTXIySczsjqjKda0D9TlGVEdzdK55IbaWvCPczHzW0ZJYhqbysulTDqsGWbjP7/eW3w5lco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424504; c=relaxed/simple;
	bh=IeNi9KHquzSdlud7mjFBZ1AG4Yfd0+rUSXk+78Lj9to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEQ0d5PUNSFYQX8n1EM4GeK7ukDpauAqc1qepdkjs0osWlBPf5Rwj5N29Q2LpZ6zPK2V7ESUEO73fiKJ8MCs8BcKyWLT6I8lk+rIUMzGHVayu7wlp50dIS/WxJRWt3J5oHaNeYeKIL+B1Xj0v3Q0EkvVW4y0URsuLZnlP8Eqj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtJYemnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtJYemnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240551F000E9;
	Thu, 30 Jul 2026 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424503;
	bh=ibq0I2uHbjJn2tdA+Jd5DoZjAJMCS7VSeeEEsGjcTb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtJYemnQw3yB84AlEErxVKtR/hdJ2Sh8ujJjo76p3ualX/ZUiKsX4fO5ASGkNincM
	 JkIIhBgcvccrLF6kRJvglaCUOZsensCfNWH1O6gdJZh3EvrjIU7wdrRCQeh057J+sg
	 jCSDHQVEVu6mabv41ksPckMeZ/poJfssAYLZGpO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 418/675] media: pci: dm1105: Free allocated workqueue
Date: Thu, 30 Jul 2026 16:12:28 +0200
Message-ID: <20260730141454.018136555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 1a65db225b25bb8c8febf16974c060e0cc242eb9 upstream.

Destroy allocated workqueue in remove() callback to free its resources,
thus fixing memory leak.

Fixes: 519a4bdcf822 ("V4L/DVB (11984): Add support for yet another SDMC DM1105 based DVB-S card.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/dm1105/dm1105.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1194,6 +1194,7 @@ static void dm1105_remove(struct pci_dev
 
 	dm1105_hw_exit(dev);
 	free_irq(pdev->irq, dev);
+	destroy_workqueue(dev->wq);
 	pci_iounmap(pdev, dev->io_mem);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);


