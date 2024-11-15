Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1723153800;
	Fri, 15 Nov 2024 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653374; cv=none; b=cvLfEfYI609RgW13gbk1ua37biXAGIVW/9FO5X2QgKuC6/EKvhHY3W3+/MHbr++bz5yVerWfujKudrmc8n+8qLN99NJ9A591qfnaYE69EChZHSQSnEkKgc16VNE+pAvHAXCKDZfvq50Syp7hJAqQgHjLKspUg7vyevT80uR69TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653374; c=relaxed/simple;
	bh=BPuMh+FqRfUdG5OfbXrecPkAePZ/y/HaeSREskUemRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZFagt1WOve7Z8XhuO8uUmSMdGvmsdbF6lpUNGTUoMor4dGLujKqVu6D85uDOuTf+IQZKYdEoH/nYCpIiszJdYakrneKaBZDQjYHvZd4UhmLyIwbt592S7rniL+w5SoB+MR+w2wLfEHxI7n9F921sC3/IYibC6Q0BkxoWiOAOLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0oMEAA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0oMEAA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524FAC4CECF;
	Fri, 15 Nov 2024 06:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653373;
	bh=BPuMh+FqRfUdG5OfbXrecPkAePZ/y/HaeSREskUemRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0oMEAA3HPTxScbNxV3K/VSCEazExEOrj+xyvAcczPpaHaMDipgeibCg8f3NRXnpw
	 b2rDSVAM5NzUQIhS2sORhb8fFijtdVlZU6s/hlZIyMxa6rnX5+tJAdJCoPOBqya9Zz
	 +cY9zvPB+lL4z2Nl7OTFUdu3d0SmMhVE8co816tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 34/63] vDPA/ifcvf: Fix pci_read_config_byte() return code handling
Date: Fri, 15 Nov 2024 07:37:57 +0100
Message-ID: <20241115063727.149095514@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 7f8825b2a78ac392d3fbb3a2e65e56d9e39d75e9 ]

ifcvf_init_hw() uses pci_read_config_byte() that returns
PCIBIOS_* codes. The error handling, however, assumes the codes are
normal errnos because it checks for < 0.
Convert the error check to plain non-zero check.

Fixes: 5a2414bc454e ("virtio: Intel IFC VF driver for VDPA")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Message-Id: <20241017013812.129952-1-yuancan@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Zhu Lingshan <lingshan.zhu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 472daa588a9d2..d5507b63b6cdb 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -108,7 +108,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 	u32 i;
 
 	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
-	if (ret < 0) {
+	if (ret) {
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
-- 
2.43.0



