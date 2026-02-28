Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE141372242;
	Sat, 28 Feb 2026 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301488; cv=none; b=BNfDBkCaa1egNM1KsGqD4aTU//216/yiHNSR0xHYnXbxVk5T/5fErlmHtbKJmR32j49tNSU5ftAeR6nk4qSK6j9nnoTjLdnsMJJYZoBhXGTrGcgTUshYKd3FOCBBpSeCCH20UFxHDa3uYiMQiLhdcUbYVtIl7woDCdLl4KAj43s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301488; c=relaxed/simple;
	bh=XmUWvmMkqZbf6OY/z1ICtchVT2A7ctd9pKK+1ZnxMOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoKeglQubLu4bkWbmPqpKqqUcK1teRyUZmQSQFMa8QbAnXbVBegtxfmA24eSdxeegTcK1dAe8aWOdNTC01CYGu68GhHKjd4CKQ7U8v0zZzTN/lFOSuorU1pECziuFsRBhjbO6J9dgfn7TTEg3XLpqbuoXiIL2yqKZz+mV+oUDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHn9QoQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHn9QoQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01482C19424;
	Sat, 28 Feb 2026 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301488;
	bh=XmUWvmMkqZbf6OY/z1ICtchVT2A7ctd9pKK+1ZnxMOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHn9QoQKlOghgr3nJ/RJDi2X07CIQTOYt0YM/1zs45mCo5eJ4x9Nf8AsTDkJYDw2j
	 GRtq2TRNVROThu8jQ01S3odtUJJc8zhbF6OJuQz/EmoFlT3HQ2RgGqn/KCmYnGRy4x
	 lZDGieFtVDGEFlQDFJSBlMSMphIVxKS+xaTqzJoZs/LoY+XyyjkQrolc/8JAD3uj7u
	 FLX0JTEvZVIJLHWuBSf+c8EvpkZnO6uHvK0FDur5MZ897lTtzWyKjAnA8krJepvJOe
	 mwVZhOVjzdW0bqG+5BUsOIjYN+ZZrI++waz/I/rVeksYZxDpsixcSXYLeQy8ifVHmF
	 Y0QsVdZuQtFcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jinhui Guo <guojinhui.liam@bytedance.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 674/752] PCI: Fix pci_slot_trylock() error handling
Date: Sat, 28 Feb 2026 12:46:25 -0500
Message-ID: <20260228174750.1542406-674-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 9368d1ee62829b08aa31836b3ca003803caf0b72 ]

Commit a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
delegates the bridge device's pci_dev_trylock() to pci_bus_trylock() in
pci_slot_trylock(), but it forgets to remove the corresponding
pci_dev_unlock() when pci_bus_trylock() fails.

Before a4e772898f8b, the code did:

  if (!pci_dev_trylock(dev)) /* <- lock bridge device */
    goto unlock;
  if (dev->subordinate) {
    if (!pci_bus_trylock(dev->subordinate)) {
      pci_dev_unlock(dev);   /* <- unlock bridge device */
      goto unlock;
    }
  }

After a4e772898f8b the bridge-device lock is no longer taken, but the
pci_dev_unlock(dev) on the failure path was left in place, leading to the
bug.

This yields one of two errors:

  1. A warning that the lock is being unlocked when no one holds it.
  2. An incorrect unlock of a lock that belongs to another thread.

Fix it by removing the now-redundant pci_dev_unlock(dev) on the failure
path.

[Same patch later posted by Keith at
https://patch.msgid.link/20260116184150.3013258-1-kbusch@meta.com]

Fixes: a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251212145528.2555-1-guojinhui.liam@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7858121344655..d4e70570d09f2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5500,10 +5500,8 @@ static int pci_slot_trylock(struct pci_slot *slot)
 		if (!dev->slot || dev->slot != slot)
 			continue;
 		if (dev->subordinate) {
-			if (!pci_bus_trylock(dev->subordinate)) {
-				pci_dev_unlock(dev);
+			if (!pci_bus_trylock(dev->subordinate))
 				goto unlock;
-			}
 		} else if (!pci_dev_trylock(dev))
 			goto unlock;
 	}
-- 
2.51.0

