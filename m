Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB11885B3;
	Fri, 15 Nov 2024 06:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653603; cv=none; b=OzIDENGhMpAnAndje6oouQ/cwaP+e1mO4fvedQyzYVXh7N4n75IBE1t6IlFMwZhm3v7PwPCCcF9dAU1QJ9waU6MoWYaQhKPXrMWSP8aWNW9z/749prkjYHzSXgWXI1n9WiqgVbUcL48lL7zeNtxoUgr0m6+2JzYPQ4cxOG5MduM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653603; c=relaxed/simple;
	bh=PQS7wTW16tUBZhoMOkUdTNua4zjtfq7qn4UBlBzqgKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyppgxe2vMcEyKWocd69w8ozBTNeC48sMkuwvK0NWFRCMb7ZV7TnufdO5fVw8kVJjs+19+PDDvEqhZoFj8hIvZfBiIRqiDTljskveM7a0WLRJohAAsE7EVS6aJ7NGGg6t4KaKWXdDtHvlVg4B9PR00U/p0tq70i7L4WT0dtLXIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwvhBX0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwvhBX0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7323C4CECF;
	Fri, 15 Nov 2024 06:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653603;
	bh=PQS7wTW16tUBZhoMOkUdTNua4zjtfq7qn4UBlBzqgKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwvhBX0Q4hyEemaoHXLestUEoM0yMtfGEQF0aWW6I5wFsP60fGFUElV+OmZSiqLBE
	 UMJgpZ5kqwj5mui0J2HZ+yp1osysYPKcWB7A5At8V+Nso/dLP83qEDkp45WFSb4csB
	 0MMii0c2XGI+mvyE1NV3zDfo6FE97FT1Q6kfogek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/39] vDPA/ifcvf: Fix pci_read_config_byte() return code handling
Date: Fri, 15 Nov 2024 07:38:32 +0100
Message-ID: <20241115063723.411121631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3ec5ca3aefe1d..c80cb72b06491 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -78,7 +78,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 	u32 i;
 
 	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
-	if (ret < 0) {
+	if (ret) {
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
-- 
2.43.0



