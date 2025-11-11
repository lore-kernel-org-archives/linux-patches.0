Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F8124E4C6;
	Tue, 11 Nov 2025 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823094; cv=none; b=cpx1t/Lq0Z+LdlEgPXAWK0ERy7LDWkmsh2PNckK0NpPWMrAOVjZWGgoK4yxxaFL7bIe63d4L7oK+qq9EVyVGEgOt/DTqaLbN4AJk7MaRXIA4LQ946I/OdBhoTKT0UU9pgY7yQgJXJKqJLKOH85mTWUZ7ze/fFjr/HSs9JevR/Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823094; c=relaxed/simple;
	bh=dkUuDkPIDD99S/m6p97YI4sPlL1/qbqZbvnzjnOPD0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efZcghmomms4BFOmZQvUDaJcJYVJL0K40SZCBT9p/bCAKwJKiM0dIa1MoqaiJWS5moE/stG2qXNM2zcFey3SXbyTsgufcT2V0F1FQa1upCNRcORxrqJXzX93lKkfhmYWPKp+j9DOvsTiM8auGUhsYbYPSfG8pLlBhYxkrh2asv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsgFGAgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsgFGAgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A9CC113D0;
	Tue, 11 Nov 2025 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823094;
	bh=dkUuDkPIDD99S/m6p97YI4sPlL1/qbqZbvnzjnOPD0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsgFGAgp2nhC/CKdRn7S7dw7lyWaHdYOtyOHAIXknE+RnQU9KDChHXhynBrCl/BLN
	 zufZ4gfbw102iLzsxcXpSULCWup/7/WKA4RoTpaB7KmQXRUq9MGxWVMSe85NHF/S4C
	 cLEDW4ScrWLo7jMvthmUp1lujXxwWeO5eYZIF+SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/565] mfd: core: Increment of_nodes refcount before linking it to the platform device
Date: Tue, 11 Nov 2025 09:40:26 +0900
Message-ID: <20251111004530.758846813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



