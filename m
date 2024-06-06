Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2741BE24A;
	Thu,  6 Jun 2024 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683534; cv=none; b=E6oNuVzqjENqlE8eQaXAXTvejstGJvyg7euGd8EQss/E8h24uRgfg1SVFWZ+vpPFVFtQcJiPIuoTLFDNCAFbOYWv5itVP8EmoMJoW/RwHe2vozijMf+dLiyAfxIXKVzfOgHfNzxvpfJ5Pk3JmuVDgLDd3tmFo3d+so8z4krngPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683534; c=relaxed/simple;
	bh=+wYVCEb/pyLzKWsxF/DAjZ1otoQHJLrHpZ0j2UIVSuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6c/iaJZVdF0oOw1eacTbPLPLjlifdjrArg5Do++cFjD0gxMQS2ciLag0nnDXvgEwa6pPEeOhMHh8AygkjkJBdGgY5aw3mDQLdSUhToGE2JtyelYcMSfDP9WdQfWIP2v6MdPYFxf/pWarHKeUvQnL2Dk3gny1pfSVmXhDsYqCaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8nZhBZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8nZhBZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B47DC2BD10;
	Thu,  6 Jun 2024 14:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683534;
	bh=+wYVCEb/pyLzKWsxF/DAjZ1otoQHJLrHpZ0j2UIVSuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8nZhBZQ11C0Wv64hEC7YpjRlugMZjtPcRVAgranasudXEcxv6WbOpnuOef2huNSH
	 KJX590/JRxJuJKq7495Y8Q7pKeM7USg+6V9kmRq/mUZVNjQnd+uCN0JG28Q9jCMmma
	 hGCXTHc55okTCUYMVeThFZbsO2w2pEL1lUvMvEGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 474/744] PCI: of_property: Return error for int_map allocation failure
Date: Thu,  6 Jun 2024 16:02:26 +0200
Message-ID: <20240606131747.656188674@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit e6f7d27df5d208b50cae817a91d128fb434bb12c ]

Return -ENOMEM from of_pci_prop_intr_map() if kcalloc() fails to prevent a
NULL pointer dereference in this case.

Fixes: 407d1a51921e ("PCI: Create device tree node for bridge")
Link: https://lore.kernel.org/r/20240303105729.78624-1-duoming@zju.edu.cn
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/of_property.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/of_property.c b/drivers/pci/of_property.c
index c2c7334152bc0..03539e5053720 100644
--- a/drivers/pci/of_property.c
+++ b/drivers/pci/of_property.c
@@ -238,6 +238,8 @@ static int of_pci_prop_intr_map(struct pci_dev *pdev, struct of_changeset *ocs,
 		return 0;
 
 	int_map = kcalloc(map_sz, sizeof(u32), GFP_KERNEL);
+	if (!int_map)
+		return -ENOMEM;
 	mapp = int_map;
 
 	list_for_each_entry(child, &pdev->subordinate->devices, bus_list) {
-- 
2.43.0



