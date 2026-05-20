Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834ED37754D;
	Wed, 20 May 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298026; cv=none; b=gfBHoiZd+OsLfE6b4WBAFkIkFA9GiaORyZQwqxR5VxbXP2w01qfndd37QhEoQnTxOdQvTUqTtgzXLcd7QvXjK1nNYUDCBeRjZD9AVdycF7HlELOOwmUuot+oMFReXlR565BAtLg5Biko/nm6BbV946AmFNFUF40sbrSrPA2+fm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298026; c=relaxed/simple;
	bh=bguS/A8FCGAok4jWdleic0fu8WqVQs0Bl/KTyGhWW2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgGQzoM0MRswcsaQR7qZ+RhF99swgqTR8OgkZVv8A3uk6hy57d1zSu4U+p99pumPWRXib00koJ9GxdM7p2IUJvmAJT+p3gYKpCTQndUW9UMth1ve6TjIv1iyzjvNJEtT8luReonYCcRo9At0BUshNr6udFQs7RtQviX9arkqeVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFXQtEh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFXQtEh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B901F000E9;
	Wed, 20 May 2026 17:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298025;
	bh=DSC3KM0AxBPJleuRKY/HVl3R77XUSDtQifceCopKlUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFXQtEh9KQKTQS3KvATFJEB57zpgqJTlbRQtctjf+kNbLtx2tDA4wa/qEOalTXPF9
	 gWnd394xpk4H+Mlk9LY7a5KPRGdSvKBGh+IrFVhlL8K1umWHsc/y1Z5exCtr94ZgG6
	 qfvL0HaHfN05guXyl7rC+6tqg6BXgGEzjcZtxnIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Nisbet <peter.nisbet@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/957] PCI: Fix premature removal from realloc_head list during resource assignment
Date: Wed, 20 May 2026 18:12:16 +0200
Message-ID: <20260520162140.028883660@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 1ee4716a5a28eaef81ae1f280d983258bee49623 ]

reassign_resources_sorted() checks for two things:

a) Resource assignment failures for mandatory resources by checking if the
   resource remains unassigned, which are known to always repeat, and does
   not attempt to assign them again.

b) That resource is not among the ones being processed/assigned at this
   stage, leading to skip processing such resources in
   reassign_resources_sorted() as well (resource assignment progresses
   one PCI hierarchy level at a time).

The problem here is that a) is checked before b), but b) also implies the
resource is not being assigned yet, making also a) true. As a) only skips
resource assignment but still removes the resource from realloc_head, the
later stages that would need to process the information in realloc_head
cannot obtain the optional size information anymore. This leads to
considering only non-optional part for bridge windows deeper in the PCI
hierarchy.

This problem has been observed during rescan (add_size is not considered
while attempting assignment for 0000:e2:00.0 indicating the corresponding
entry was removed from realloc_head while processing resource assignments
for 0000:e1):

  pci_bus 0000:e1: scanning bus
  ...
  pci 0000:e3:01.0: bridge window [mem 0x800000000-0x1000ffffff 64bit pref] to [bus e4] add_size 60c000000 add_align 800000000
  pci 0000:e3:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus e4] add_size 200000 add_align 200000
  pci 0000:e3:02.0: disabling bridge window [mem 0x00000000-0x000fffff 64bit pref] to [bus e5] (unused)
  pci 0000:e2:00.0: bridge window [mem 0x800000000-0x1000ffffff 64bit pref] to [bus e3-e5] add_size 60c000000 add_align 800000000
  pci 0000:e2:00.0: bridge window [mem 0x00100000-0x001fffff] to [bus e3-e5] add_size 200000 add_align 200000
  pcieport 0000:e1:02.0: bridge window [io  size 0x2000]: can't assign; no space
  pcieport 0000:e1:02.0: bridge window [io  size 0x2000]: failed to assign
  pcieport 0000:e1:02.0: bridge window [io  0x1000-0x2fff]: resource restored
  pcieport 0000:e1:02.0: bridge window [io  0x1000-0x2fff]: resource restored
  pcieport 0000:e1:02.0: bridge window [io  size 0x2000]: can't assign; no space
  pcieport 0000:e1:02.0: bridge window [io  size 0x2000]: failed to assign
  pci 0000:e2:00.0: bridge window [mem 0x28f000000000-0x28f800ffffff 64bit pref]: assigned

Fixes: 96336ec70264 ("PCI: Perform reset_resource() and build fail list in sync")
Reported-by: Peter Nisbet <peter.nisbet@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Peter Nisbet <peter.nisbet@intel.com>
Link: https://patch.msgid.link/20260313084551.1934-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3ea6f3e726a8c..29ad8d8718974 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -428,6 +428,10 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		dev = add_res->dev;
 		idx = pci_resource_num(dev, res);
 
+		/* Skip this resource if not found in head list */
+		if (!res_to_dev_res(head, res))
+			continue;
+
 		/*
 		 * Skip resource that failed the earlier assignment and is
 		 * not optional as it would just fail again.
@@ -436,10 +440,6 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 		    !pci_resource_is_optional(dev, idx))
 			goto out;
 
-		/* Skip this resource if not found in head list */
-		if (!res_to_dev_res(head, res))
-			continue;
-
 		res_name = pci_resource_name(dev, idx);
 		add_size = add_res->add_size;
 		align = add_res->min_align;
-- 
2.53.0



