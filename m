Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787233438F;
	Thu, 30 Jul 2026 15:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426162; cv=none; b=Vhys9J9hO89wsRr5KCpyPQ1oiZPCMqIYqpyRBkcK8y6WRBPU3Ufok+cK5CTBoFI9sG+w1l1uUeDfgSURfcPJpieKRTzmUq4+yVGjyawthRqIZ0Tltaj6PUH+lWNidriQeEr3ytntB6TvNefIw77cu1iQ6XLMLVf0JpEp+ROmQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426162; c=relaxed/simple;
	bh=06bS6UsLs2EIITiP60v3glgrpQQ7mmJKshRiiO/fB5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TI9wpDh2NBdl8H0FE9d6TPt0lbiMim1JWRlGLbAfmj92vWZEpaNmQ8XjJKdywYEDX73JKhtqsbgGrzVD3JHpi7tbbY9CXlGcEyVgIUJ6nF4RPk0DA4O95ElLZKcQJYxwyVEi3ZleWf14nP3vBy8vKawfgPOG4Cmz1FNbDb4gsEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J67mxNZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J67mxNZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837971F000E9;
	Thu, 30 Jul 2026 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426161;
	bh=ezO5VDX8PrlD+qmpFn/lfkwBnYrr2GYnwVtc/zBTT9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J67mxNZLFmEuIbfacpfLAw1zU+A7tiDZrMKf3g7K5eFkH79vXNkqfmxNun5cxlPhK
	 rU5b3WtweWxcexpIQQ0uGaC0rn1gzbGYwhZS6DTiJD4vF5D9G8z7Pjdab+iruXFLa/
	 uJOm0FlcWMgjMUUBOIC7Sj6XC6Ng2yMissFfGn04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 320/602] media: pci: dm1105: Free allocated workqueue
Date: Thu, 30 Jul 2026 16:11:52 +0200
Message-ID: <20260730141442.691210575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


