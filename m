Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382AB1AAA0F;
	Tue,  8 Apr 2025 11:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112854; cv=none; b=ba2voW8FXT5qoj4LdYgJSU0QYLXsfIwQ5aKUtJLSpFhj71dzT5vkAIk5T8C3otVfHLZGAkoBIKXMbkENkXf+5SiPdut/1aX8k929WhLqMWeNBBX7zP2JKNtBpDCZCSg8liLOHUe+B+M8m08/l7SQjt+wdFUPwJqTKa64nu0qTWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112854; c=relaxed/simple;
	bh=0BVC8SkSRH0vQ5b1Ys2WtUMYKr78B40hrx8jZ6bXv9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eckYl9Q9iUlMEgQ6otFnow2OTPIzzmQyyMIgaTgX54jxdpS2G4yXyL/RopukpHy52co/pxwn/LIS7H2RP04IHDjEAw5n6Uu1j2yOjyczRDd6M9OE4RNqfxU7dcSZjwMzsJVfvLgJLtT+Wej2EmLOCK48W7Ueat07KAXa1watKlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btxZl7DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btxZl7DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6C1C4CEE5;
	Tue,  8 Apr 2025 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112854;
	bh=0BVC8SkSRH0vQ5b1Ys2WtUMYKr78B40hrx8jZ6bXv9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btxZl7DZdmDA+9GCWWok4XQ/8FFvA9xVybHrIJkCDnC7si6QqoUNh3GPn1bIdfVeD
	 ct/cJmvxtd6lrRBgPAsyOzbaiovjwTf8JrftoOwDYv80/RJNkcCHS9U1R98fYUVjyg
	 ujpFP+15bHG0amDZdE1+n6SkgT3hyTNT77z5XwIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/279] nvme-pci: clean up CMBMSC when registering CMB fails
Date: Tue,  8 Apr 2025 12:50:06 +0200
Message-ID: <20250408104832.386356061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 6a3572e10f740acd48e2713ef37e92186a3ce5e8 ]

CMB decoding should get disabled when the CMB block isn't successfully
registered to P2P DMA subsystem.

Clean up the CMBMSC register in this error handling codepath to disable
CMB decoding (and CMBLOC/CMBSZ registers).

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2eb692876f695..39df3ac10a21f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1870,6 +1870,7 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if (pci_p2pdma_add_resource(pdev, bar, size, offset)) {
 		dev_warn(dev->ctrl.device,
 			 "failed to register the CMB\n");
+		hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
 		return;
 	}
 
-- 
2.39.5



