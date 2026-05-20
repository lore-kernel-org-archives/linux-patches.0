Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18DD3BA246;
	Wed, 20 May 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297773; cv=none; b=NdrJJluSpX+D/bRIBuLM7PziOnK7PmRZJ25g1sLdnneIvl9oWZDNAcQ1cibAQe5PUv4PUjlsD6zEsV8o+7BE7zLtNHCpa1+tPvmyarC+cWctUbvNBsGxpLDYrTwRh1MCuFsNfWBYXRhCkispqS4q/o0CUv9IRXv9w7/JtiWcE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297773; c=relaxed/simple;
	bh=uyeLZoTaJui5BYJZEiBNSwZEbJeHKwkCX/gob62JSnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbhi52VErfmHHX8f060zVSADS3Bc7QKTqP0+LRZhL+1o0ptDBUbb5PEqXfLTT4WgKewWEs/hz2KzkyZ4JOoipN4vVu9MyOJFlmBcA9qUapQP4JTmAippwPTYk6JD1TDNHS3yvk9DHvOpQ9/+SsxUjEtGan+ZSzp7Zc8TfGGofYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KohtR+o+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KohtR+o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146B21F000E9;
	Wed, 20 May 2026 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297772;
	bh=jmfGMXBj4Mz46NJhfUPYY6iA6KIOt1ktKNldVdxxgQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KohtR+o+/hhDSYbHknG7+hpZvsE2LK+dvKu3jfH0pKYS24vjJRG7KtH6i2HBKl6nT
	 3zWR2strM9H0BZpMeUMCq7WP469tmjrTgURwTWFzc8nDJe6842deFPC4DqVEWQl5+8
	 /rwVmGOhtMMO2TyzHFRuY1kjVZkvL/6CgIBO1hJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/957] net: mana: Use pci_name() for debugfs directory naming
Date: Wed, 20 May 2026 18:10:40 +0200
Message-ID: <20260520162137.955167431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit c116f07ab9d22bb6f355f3cf9e44c1e6a47fe559 ]

Use pci_name(pdev) for the per-device debugfs directory instead of
hardcoded "0" for PFs and pci_slot_name(pdev->slot) for VFs. The
previous approach had two issues:

1. pci_slot_name() dereferences pdev->slot, which can be NULL for VFs
   in environments like generic VFIO passthrough or nested KVM,
   causing a NULL pointer dereference.

2. Multiple PFs would all use "0", and VFs across different PCI
   domains or buses could share the same slot name, leading to
   -EEXIST errors from debugfs_create_dir().

pci_name(pdev) returns the unique BDF address, is always valid, and is
unique across the system.

Fixes: 6607c17c6c5e ("net: mana: Enable debugfs files for MANA device")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260408081224.302308-2-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 962fdd29d6063..c0de20b2183a2 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1927,11 +1927,8 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	gc->dev = &pdev->dev;
 	xa_init(&gc->irq_contexts);
 
-	if (gc->is_pf)
-		gc->mana_pci_debugfs = debugfs_create_dir("0", mana_debugfs_root);
-	else
-		gc->mana_pci_debugfs = debugfs_create_dir(pci_slot_name(pdev->slot),
-							  mana_debugfs_root);
+	gc->mana_pci_debugfs = debugfs_create_dir(pci_name(pdev),
+						  mana_debugfs_root);
 
 	err = mana_gd_setup(pdev);
 	if (err)
-- 
2.53.0



