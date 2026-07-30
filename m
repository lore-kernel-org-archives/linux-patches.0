Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D143D503;
	Thu, 30 Jul 2026 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422633; cv=none; b=ImgoJQkYZ4rGr/pDyj6AE1+4xVZM6b6e5lpC7cH+QQDdkCN/vAOaKuKQBTOyEp23P3jJxIWZeVdSWcovlnHBiGP7gkh+Dy5n1U2JIgYlVZHDMY12/H55nHbgxDT8zTHriU5zBBJMcxGto53RQgUleWpjmLTiOq7mm2CxtjOZ0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422633; c=relaxed/simple;
	bh=Cevg/j063ZdmuCgRHjkWFkAHzvNuBJuN+PpXRZnItUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8FXJce6g0iYYBjbAMLB/tcUaoD39z2vzt1KvofEi+zjCz88NBheuPI2WBRv+myUgDpB+iVbltoZ/W5cXrYI+tl99AGUkuvn/pqxTCzuMhwfqS2BY51Glh4EgEg0H1gn47+aUdoY+nX2lEaSVuYw19extAO1wOc/dimmXjsR8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yY1toZTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yY1toZTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CABB1F000E9;
	Thu, 30 Jul 2026 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422632;
	bh=8zK2KTtfhwthM5NpADPH1Ques8osDKqL+/raYDbA9ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yY1toZTqJYImQZderA3Pu9BfK4n7bQWmYDR40h6qxULUCOSKTBTg39tCOxyv6hZ4z
	 OVJ+MssrqSL+pjQrtmExjhWQjVXZCTCoai3c8hvi+kEOa5dZIHYDN3ZkgsXjyTHGrb
	 FlhVrDfmVwLwrGLsN5jK75lcOMM5A12CHLf13+PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 503/744] media: pci: dm1105: Free allocated workqueue
Date: Thu, 30 Jul 2026 16:12:56 +0200
Message-ID: <20260730141454.975161378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


