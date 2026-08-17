Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49A4334B5;
	Mon, 17 Aug 2026 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979473; cv=none; b=cVG0B/4aXqhCdrDsUmJWXF6ixIXPqRMQN0tLxfoJpeYXIBKeCwwZmrU9ZDe5wpIMm1458NS5E6YS/Ta/PSUggnv9gu+Kj07JKujmHlNqcEF9rkbk7vH/BY/4NepcJh948RVUhWWmFDgsNewGZTtO7C9QBDsHOaHEqTeP2a9DvSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979473; c=relaxed/simple;
	bh=RnCCZoX5D490w/nRmtL+oM9P+Xlx0yOQ0w+1/0YQKhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiV+cgRT6CtifB41ZIj/rr+YqTSBtWyQS46IOn/UvnZoVTfqiulnY2aC0cIVg7FuDMW8HzhiLPEPUsqsu8J3YU9R8zR5rlwr1XfMsB+xmrsAJRv9GlZvtcepWgCCUNRyWcm/jCCVllSipifHRkAFiPxTWt5lAVH1PF+j0PLsZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDzBRD/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDzBRD/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E7F1F000E9;
	Mon, 17 Aug 2026 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979472;
	bh=GO72kUGN6c/fXiVxCzpjFpE3VbyINE9otTwHh6zYJSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDzBRD/0egkOWa3cEKuFp+Z5nOq9mx9ykHglvKrCcUP/LY2P1SxmmpeKT0olZIIsw
	 e/QrV/oIgjHXbGhNb+On1NTWrWG094qhUWzn7GTTZJDla3tebK8oVkdRiY4gEQAGo0
	 bY/IlA0bYE2SoHyUzPRUmccSgYEIJs0s+D27LC+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 199/609] media: pci: dm1105: Free allocated workqueue
Date: Mon, 17 Aug 2026 15:28:15 +0200
Message-ID: <20260817132550.758792709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1193,6 +1193,7 @@ static void dm1105_remove(struct pci_dev
 
 	dm1105_hw_exit(dev);
 	free_irq(pdev->irq, dev);
+	destroy_workqueue(dev->wq);
 	pci_iounmap(pdev, dev->io_mem);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);


