Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EF015FD13;
	Fri, 15 Nov 2024 06:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653922; cv=none; b=DEkfa6heIQiTUqXjrkzZWvus1ju6FpeNirmX5ULyyAiQL5YWC6AzaByMZA5nK257pgoQVUnL2vJXATz3oLOYchBtca7Y/CkLVTp0ltZX0C1ZaWnu3iaVAcx4iafsJ1eBq7VqfO4AQ/Fgo0Xc587RxOgq70IZ/noBOdlh+Xk0v4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653922; c=relaxed/simple;
	bh=+n5cwINiBcWMuzL2R5bexN6XzVFxKDneOO23i8zCWqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxiaADl7q/XteA2VDQuT5vUPY4Gbpqsws36gpTHqkEGcBh2kESMvg08iT+6pwMaOjMWb1onlhzISOiOQG5venjGyOxoXT7S0tmi9Rsx7QeaiO42qtrIpikS147EFVB3VF5nGEUXmAeDa86DqRk/cg3qj8/c6C32UnIayk8wpyyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qph0gZw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qph0gZw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BB7C4CED0;
	Fri, 15 Nov 2024 06:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653922;
	bh=+n5cwINiBcWMuzL2R5bexN6XzVFxKDneOO23i8zCWqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qph0gZw/r4KBlBYHLxzeCBO0JDNXDKyaFcpopQ0esHN5G9Dg+lHtMzoX0ZxTE7E/S
	 0JagOGAE5/oVSJIL2Ka1WeW1mvNrgp2xFtOxFVv/7NeBUmsH2tXEMVXWG3+bflmSls
	 /9JGf7Eri39aVFwLH3AjSSLc+j+P6X38i97DDKU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Zhu Lingshan <lingshan.zhu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 76/82] vDPA/ifcvf: Fix pci_read_config_byte() return code handling
Date: Fri, 15 Nov 2024 07:38:53 +0100
Message-ID: <20241115063728.287230487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2a128e56de5f..b5724b88d42bb 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -105,7 +105,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 	u32 i;
 
 	ret = pci_read_config_byte(pdev, PCI_CAPABILITY_LIST, &pos);
-	if (ret < 0) {
+	if (ret) {
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
-- 
2.43.0



