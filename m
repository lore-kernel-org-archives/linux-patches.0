Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430A043B3E3;
	Mon, 17 Aug 2026 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976961; cv=none; b=EEcIr76j0DRKmwy3Rvl9KlJSTMMMgESoK0aSfyOc4/P2xRs8qywF49/zpYzgSFO17ophyufp6S/DGLJKEc9sFS6W8UZwAl25poX+wufPkpohP4axoU1R1iUBHj5tdKxKWQh0R2HehvU/6XdHrubJbaO69TkpwtxrSfw0FH+A9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976961; c=relaxed/simple;
	bh=O4Z1Dc4/8h48VoGW1FHlzVumGTsJ9wfBqEsL1/JThNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV2s0QlEIOtpXdL6tBTBKY6hstwlMLMwi7tez2czkzgY4QYqdqEkJ6yCXbFN0MbYWaPhU/W+uFbNHbgylGV8DcSzmN0ZoTsCyxGUyNu/5SpQ4dnHxoyoXcGM0H7EIKneJOXEGfwJe5u1nNZzjt3X5Ug0Zc1YbzXiXpIUwzeruss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwZTLqoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwZTLqoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACE11F000E9;
	Mon, 17 Aug 2026 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976960;
	bh=p7siyOJ9GyJy9vOkDZHQn7ryGrgXozVNPaHiA4NQsTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwZTLqoPEvsgn9SOVxwMg6olu7bZGRwQudxd8aCN05NsnXhyw+KV0ZY1BXde4G09Z
	 qM0Z9bXUn8uD/QpBqKiIJ+T9E+vO9RRc47RWCjvLXgoZIDrjTE+6fdVckXIuuiJ2AP
	 bzxQmAH2uPJDdXR2akL6NTjcEDrNX4Nc5z9YCuMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 164/456] media: pci: dm1105: Free allocated workqueue
Date: Mon, 17 Aug 2026 15:29:14 +0200
Message-ID: <20260817132546.501150418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


