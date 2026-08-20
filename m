Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9702847DD4D;
	Thu, 20 Aug 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244408; cv=none; b=OeAD7QBd7S4ymmaTqlA6omzAS8QJirUgE2J8x115i0J/geKgZ1a/UwhPYf6DqWr9L8APzJ8Q+KOUQuuAQrPfJdCz6cM0R/W77sQxIJjhqdWwnD0ySbp8ySikc4jBCUEGEAn8AWFfMJynLQjM1PYYrngRkTSS84appDyKIfztTnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244408; c=relaxed/simple;
	bh=JKO88qM0Gapu9vXm3esMX2lQ4GHjXGq6RaRM9dUlv3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoTK9GjHdtjp0zPpwBnv0Q2lXsdm+exm7L89iaG0qciiEORzrO+IbMYiogz+bTaaJo/B/UQqfUuMmCXHCoavb8x54WDoOI0FI+eZKEO0DPZnbFPqW1ViX4CnJQQIA8UqVE4dEhoQQQP20skDGWi9fNH9DJvXNFEAlypTW0B6MPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/BAGF43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/BAGF43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39DA1F000E9;
	Thu, 20 Aug 2026 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244407;
	bh=6q9Fp6//e7rBtcbXZp6gjNhHeW0PXfpT3l7WW6gI/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/BAGF43eVUw6KRJE5VBZPBGBOhFYnzuGkQr3mA/cNBsM5X4WZ7xzeBkXMDG9z6s3
	 S9cRbXz8mFg4vvMXcA7MF9bJrcQiQoUaI6G3L4y3VdjjwMjMQuSN+zl+ImUC40SPXx
	 VmdFjGY2dGWM0i05QSBVIRUH7c0gjr+NGuEW3IOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/235] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 20 Aug 2026 16:56:34 +0200
Message-ID: <20260820145221.266031954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 033ff0420e4c9c240ae5523fff39770298efa964 ]

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -600,6 +600,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


