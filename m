Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719B5197A98;
	Thu,  6 Jun 2024 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682928; cv=none; b=QOT3+BRBjVWvfp3xWTx3zMQLseQLlXEuByB6cZjSHFaaHh+NHuC0vKMiomuezeaI3pMUsryzftYNdi3xU8REtKYDPg0clTJoJrm/Fx7tyQL66SY/6D9B+EU+mE+o0T+10C4xGg69shShSedAAWut+3TLyNdjWQjVl/rrNdHawcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682928; c=relaxed/simple;
	bh=kdyH4egdLSDWpLbXwXCyseU76qaHFu8pNW/9xWUbusQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es8OOrrNpzRV/yl4e+8eunRNjgVej//Fxw/KVyhT0EG9Iw5Edhi/Bg5NcfikOSBM6mSq34PEeN+hX8yCWQfXv524hN1ka5fqR5RA9alsuKgbRUQHf1jTS+jshwD8ExOfWNl8/O3WW5VQ0/yYbye3vzg8APVhExO+cIl9qp/miX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZADZWaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZADZWaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E02BC32782;
	Thu,  6 Jun 2024 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682928;
	bh=kdyH4egdLSDWpLbXwXCyseU76qaHFu8pNW/9xWUbusQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZADZWaqh4pdDSpSBBfw+pV0xNzRy9GReVWuXleiJ8hR+QLpPIxT1WO/fLnYUOboC
	 XcEeNScBjSjHG8JBd/4JOaWH66v8Tl6qVvUAl3j2vf+sOJVmL91bssx0R08/eo5roj
	 xCNOkwf5UZNDo0RYYENcLdacHB5/Wj0AjeNUwM0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 073/374] PCI: of_property: Return error for int_map allocation failure
Date: Thu,  6 Jun 2024 16:00:52 +0200
Message-ID: <20240606131654.308025622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



