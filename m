Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438F24E4C6;
	Tue, 11 Nov 2025 01:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823075; cv=none; b=qdXcaPZP7IzCBlxQzccITCJiujyuVTKs7ao1NWxtN/hYGXZ/I3afaxYYb4VJu8CYWP6zr7jjXSSDAXmupIo7g8uQskn3g6ueRlEnwn5MaNxzw5jAJro51goi7hQFnsYgqlM4tlffXxNFzVQxdj0HK1KhZqvYII9G7LPlMDTk0Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823075; c=relaxed/simple;
	bh=TDs18ZjUnUm7TZK+/FGSRDo9TA5paX0nb02LIUzeiVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5cdsWR1HKIXZLwG6dds/NFnK/NvumLqPMiRN9STcZMRAOGcRnzsWirWtf9tXT5gFttID9FovTCnDQxAvIP5/vslmqADW3okprn6J0RuerM3B6DuGXQdDagatzQVKVvAnQfsnWeL9r/NqrgNTTK3remml1LjAKx7fn4MEr2/JDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgdCg8Aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgdCg8Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA61C113D0;
	Tue, 11 Nov 2025 01:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823075;
	bh=TDs18ZjUnUm7TZK+/FGSRDo9TA5paX0nb02LIUzeiVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgdCg8AquuuzV4efsunC+dAmt3CfazKK4SHcivr4pET6n9AsnGbhL4A0kIte7EqFE
	 PVdLhMq4jZ+81B1K5L5x7ppJRNGLy97vJPdJAi9RfGDR2BaU+m1fL1aK7tOpPjwzx4
	 q37sevTOEUDBaVBbwCBKvHMhORP4YU77kywTtnjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 226/849] mfd: core: Increment of_nodes refcount before linking it to the platform device
Date: Tue, 11 Nov 2025 09:36:36 +0900
Message-ID: <20251111004541.906110006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

[ Upstream commit 5f4bbee069836e51ed0b6d7e565a292f070ababc ]

When an MFD device is added, a platform_device is allocated. If this
device is linked to a DT description, the corresponding OF node is linked
to the new platform device but the OF node's refcount isn't incremented.
As of_node_put() is called during the platform device release, it leads
to a refcount underflow.

Call of_node_get() to increment the OF node's refcount when the node is
linked to the newly created platform device.

Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Link: https://lore.kernel.org/r/20250820-mfd-refcount-v1-1-6dcb5eb41756@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 76bd316a50afc..7d14a1e7631ee 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -131,6 +131,7 @@ static int mfd_match_of_node_to_dev(struct platform_device *pdev,
 	of_entry->np = np;
 	list_add_tail(&of_entry->list, &mfd_of_node_list);
 
+	of_node_get(np);
 	device_set_node(&pdev->dev, of_fwnode_handle(np));
 #endif
 	return 0;
-- 
2.51.0



