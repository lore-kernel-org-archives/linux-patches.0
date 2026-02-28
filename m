Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D9136D9EC;
	Sat, 28 Feb 2026 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301432; cv=none; b=eUpX2luyPpIsbpdKXFDsWP+1RxFT+LsounwbJI/yCVr0iNdYsJNgcQi3Bqy/4oU11ousvW/FT/Zej3Vj2CPVd7fiddE9Bx23cdq73ACtPu+Ge4Rvvk1KjwJ9pYrrZhU+MM/5wh5MygdYFTA/YvWNe6ndD0/ZAtvCCdMj+QaX9u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301432; c=relaxed/simple;
	bh=suS1G29rwyODbeA8ltbX9rF6GG+gP7ioxW0BGo/4Y/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTyTqaQsCx6MsRKCXuSCKIiwFezH9XorQEqrF6r1pfoDcvb61TjFzTDwy9gxNvJQBCboyzCqmvLzdobD+AOjneP0JuLa8pMnd00JSGivYGOcGCFzHTJqSqJWqrtsoOpla4mmJIRy0k7nkUnj+PdLF91SeOctHh4L2p50QYramQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOwSu6fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOwSu6fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACA1C19423;
	Sat, 28 Feb 2026 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301432;
	bh=suS1G29rwyODbeA8ltbX9rF6GG+gP7ioxW0BGo/4Y/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOwSu6fhotL7TO+lw3gciCccgNDwP41XgXMEvlb0RdaVWEbR+F5p4dOlTu4oxvGuN
	 QWLSNpJmyNrY31LEF4wnNUqzoDUMIQBDXYDhZEug/zA+3eeYd/UvFS9LBGRrFQhjtd
	 /vc31fKPXPYonF9EQxi9iiawI+++/GHea69QsSpKXO76IOWEomYftCrW3yOTI7dqU2
	 LolxuhezVSeyw9niWkxjZQyT0lbyGMDsTBxP9Q8XWkU9kRvdO6F1trEEks9H3YsEGi
	 WdPu+6KWui2AaWwZ84eBsjCfQXedWHe0yfKW/JWpOa2lnr+hj1ZUTA6ibXCsk/k8V6
	 LCOK/E9m9+lpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Malte=20Schr=C3=B6der?= <malte+lkml@tnxip.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 623/752] PCI: Fix bridge window alignment with optional resources
Date: Sat, 28 Feb 2026 12:45:34 -0500
Message-ID: <20260228174750.1542406-623-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 7e90360e6d4599795b6f4e094e20d0bdf3b2615f ]

pbus_size_mem() has two alignments, one for required resources in min_align
and another in add_align that takes account optional resources.

The add_align is applied to the bridge window through the realloc_head
list. It can happen, however, that add_align is larger than min_align but
calculated size1 and size0 are equal due to extra tailroom (e.g., hotplug
reservation, tail alignment), and therefore no entry is created to the
realloc_head list. Without the bridge appearing in the realloc head,
add_align is lost when pbus_size_mem() returns.

The problem is visible in this log for 0000:05:00.0 which lacks
add_size ... add_align ... line that would indicate it was added into
the realloc_head list:

  pci 0000:05:00.0: PCI bridge to [bus 06-16]
  ...
  pci 0000:06:00.0: bridge window [mem 0x00100000-0x001fffff] to [bus 07] requires relaxed alignment rules
  pci 0000:06:06.0: bridge window [mem 0x00100000-0x001fffff] to [bus 0a] requires relaxed alignment rules
  pci 0000:06:07.0: bridge window [mem 0x00100000-0x003fffff] to [bus 0b] requires relaxed alignment rules
  pci 0000:06:08.0: bridge window [mem 0x00800000-0x00ffffff 64bit pref] to [bus 0c-14] requires relaxed alignment rules
  pci 0000:06:08.0: bridge window [mem 0x01000000-0x057fffff] to [bus 0c-14] requires relaxed alignment rules
  pci 0000:06:08.0: bridge window [mem 0x01000000-0x057fffff] to [bus 0c-14] requires relaxed alignment rules
  pci 0000:06:08.0: bridge window [mem 0x01000000-0x057fffff] to [bus 0c-14] add_size 100000 add_align 1000000
  pci 0000:06:0c.0: bridge window [mem 0x00100000-0x001fffff] to [bus 15] requires relaxed alignment rules
  pci 0000:06:0d.0: bridge window [mem 0x00100000-0x001fffff] to [bus 16] requires relaxed alignment rules
  pci 0000:06:0d.0: bridge window [mem 0x00100000-0x001fffff] to [bus 16] requires relaxed alignment rules
  pci 0000:05:00.0: bridge window [mem 0xd4800000-0xd97fffff]: assigned
  pci 0000:05:00.0: bridge window [mem 0x1060000000-0x10607fffff 64bit pref]: assigned
  pci 0000:06:08.0: bridge window [mem size 0x04900000]: can't assign; no space
  pci 0000:06:08.0: bridge window [mem size 0x04900000]: failed to assign

While this bug itself seems old, it has likely become more visible after
the relaxed tail alignment that does not grossly overestimate the size
needed for the bridge window.

Make sure add_align > min_align too results in adding an entry into the
realloc head list. In addition, add handling to the cases where add_size is
zero while only alignment differs.

Fixes: d74b9027a4da ("PCI: Consider additional PF's IOV BAR alignment in sizing and assigning")
Reported-by: Malte Schröder <malte+lkml@tnxip.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Malte Schröder <malte+lkml@tnxip.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251219174036.16738-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index cc592ccff5424..5d15298469cbc 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -14,6 +14,7 @@
  *	     tighter packing. Prefetchable range support.
  */
 
+#include <linux/align.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -459,7 +460,7 @@ static void reassign_resources_sorted(struct list_head *realloc_head,
 					"%s %pR: ignoring failure in optional allocation\n",
 					res_name, res);
 			}
-		} else if (add_size > 0) {
+		} else if (add_size > 0 || !IS_ALIGNED(res->start, align)) {
 			res->flags |= add_res->flags &
 				 (IORESOURCE_STARTALIGN|IORESOURCE_SIZEALIGN);
 			if (pci_reassign_resource(dev, idx, add_size, align))
@@ -1388,12 +1389,13 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 
 	resource_set_range(b_res, min_align, size0);
 	b_res->flags |= IORESOURCE_STARTALIGN;
-	if (bus->self && size1 > size0 && realloc_head) {
+	if (bus->self && realloc_head && (size1 > size0 || add_align > min_align)) {
 		b_res->flags &= ~IORESOURCE_DISABLED;
-		add_to_list(realloc_head, bus->self, b_res, size1-size0, add_align);
+		add_size = size1 > size0 ? size1 - size0 : 0;
+		add_to_list(realloc_head, bus->self, b_res, add_size, add_align);
 		pci_info(bus->self, "bridge window %pR to %pR add_size %llx add_align %llx\n",
 			   b_res, &bus->busn_res,
-			   (unsigned long long) (size1 - size0),
+			   (unsigned long long) add_size,
 			   (unsigned long long) add_align);
 	}
 }
-- 
2.51.0

