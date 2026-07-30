Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707103815D5;
	Thu, 30 Jul 2026 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427665; cv=none; b=l6Jt3WWNn/OXVoSIDfPj0eKuG503LOHUTM2qz1fq9MhtotWw63v5F5RQuHv97TJnojZZ49LW+WUJPeoFTFBw1DJcTnVlf2YasYQnAChNmNfZsXSaxzGIgg0Sz9N96MBxIf+L4KS90kuapXXZdm2rqiPU+4fHZ9TBFM+atgbCw98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427665; c=relaxed/simple;
	bh=wXXSmvWC8dV+HHKENno5Cv5IFcBP80uBoZuyA3aE+b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFYx7T7oaUvX+aVe5AxzOUGPS2S4AqbDSpu/h4pbxGMnDPaDwTuJlED88ShMOBgDvXd3QWE300XxV//i9G+ct8CkJYBaVsNKXVKRavzLneVEeHcxOeOwlDomhyQzjMk5Ayzq/3taFym3xAb5oedEdauIONErZVEQ2kkiTdVe+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvY/HL1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvY/HL1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38881F000E9;
	Thu, 30 Jul 2026 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427664;
	bh=D2Jh934l+U/BfzDfJxDcG/VF4WiVUEdhRLtSw4I8JmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvY/HL1P/BECh8AFG8MYbOzdtGFloNJARtF5Hy3ZJCHkefhj9XX5yDe3COMxnamyY
	 uDNzOaBqzM4PYugGj5jAqvMWGaGKlXZm7MqyZ/PH+cCnAvBhGeZJD32BynsaJJWSTT
	 MaMwWu740+02G0cS3irGlWnC78uDQSnHwRrFUZ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 250/484] media: pci: dm1105: Free allocated workqueue
Date: Thu, 30 Jul 2026 16:12:27 +0200
Message-ID: <20260730141428.917207943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


