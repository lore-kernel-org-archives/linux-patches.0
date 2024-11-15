Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF96185B5B;
	Fri, 15 Nov 2024 06:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653453; cv=none; b=O0YeFmxR6VOO57ZkWchIlt9dQaakFCVP3qfnHSTvskZZ3GGR2r/ZhK3hKJGLegXARRt5yqlI7dxg17tdkO3wdvYqArgOynhM/eTkKmAtp0eFwHaAJVOJh1QXFz9eYLT4TEdAz7z+U+dsCoHhEIcI+ZOrikb35WSRV+539dhraWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653453; c=relaxed/simple;
	bh=nVLPdZqM/dpSKhj5jbQP2rCmryy0C7a3FtzEK3eMQO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW0Zl5ZFzyLfN/e+yzNB4VFcImAnUTbCzrdD3CNkP1q2ze4576n+G0SJ+j9UrRW9XMKijNNDgNSl8Nfv/e5eZOO7y8Yo6xZXpe/miyt5c9eF6oMrhZkjaLJOjyEo/sH7mElKrC7F3URpjtP0kIi00gFc0hpoJ98bNMRJK6ASkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbsQAhRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbsQAhRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FADAC4CECF;
	Fri, 15 Nov 2024 06:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653452;
	bh=nVLPdZqM/dpSKhj5jbQP2rCmryy0C7a3FtzEK3eMQO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbsQAhRTuA9cq2c9G1+mGFyKXgHPv93VxkBPO9x9l6D9N721MsjhlaYgmU0qVNuLY
	 bgwD2Dmk8BO0kVsgF9SpBRJbwkQBFZPCXFEBkbFT8ZgVKEK86rDA9W/4MBXJQjiZYQ
	 IafiOl9ydYuWGvBBUpYSQR7BcCQpHdLX0SvF4SO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/48] vDPA/ifcvf: Fix pci_read_config_byte() return code handling
Date: Fri, 15 Nov 2024 07:38:15 +0100
Message-ID: <20241115063723.907829166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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
index 060f837a4f9f7..3b09476e007c8 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -109,7 +109,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 	u32 i;
 
 	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
-	if (ret < 0) {
+	if (ret) {
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
-- 
2.43.0



