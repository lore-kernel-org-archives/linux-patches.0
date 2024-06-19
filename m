Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9A31E492;
	Wed, 19 Jun 2024 13:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803881; cv=none; b=HbMyDCRcfuzVR8QT/vQPjCC1ABrFND1R1e021KU0eisV7mWrWPXzm5eeO3vHcgJBUOiRXPElVUum5h0mcAHaIQQ7Lvq9GIBetT6SoN9sJk8AZXw25WCRNIh9L285yQ2dYjQGjWF8O3hd4NwL3DvA0H6hm+fw064bWcTkQ/aAV1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803881; c=relaxed/simple;
	bh=DBM1xbMLAJdvUl1D0jK3Iu2ybPFIyF/JE0ftYqGSzW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jc3A79vjrCOL1a2BepARgjxBH93BHhp3UqGAaK149pcxwgmFcjUFf6ia7f27+MMRofIfiANATxEhHi+pZzoAvKU2zoLBEw4I5r4wRPQQbyARFH5/QdQIcvTviPExgVCksZgAxozg8OWmOk9yiVccxPrmRobyWbGoNZRNAsuE1JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaZOqqgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaZOqqgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B5C2BBFC;
	Wed, 19 Jun 2024 13:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803881;
	bh=DBM1xbMLAJdvUl1D0jK3Iu2ybPFIyF/JE0ftYqGSzW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaZOqqghHlW/B8Bbi1WvlaSqtTL14XKLw7ysPO2fQzU+QaxoGkd1P55J5kfXwdBk2
	 Wk/xZSeuG1CJ8TSmzvqAP1sKAA/c7A6arPQtkNzU0k54Oj3uvB3jWsZ05pz5BTmxb6
	 wULXuRTfqzVu6lPnM5dVx9V88zJvuAEb3xofbLhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/217] cxl/test: Add missing vmalloc.h for tools/testing/cxl/test/mem.c
Date: Wed, 19 Jun 2024 14:55:47 +0200
Message-ID: <20240619125600.703691345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit d55510527153d17a3af8cc2df69c04f95ae1350d ]

tools/testing/cxl/test/mem.c uses vmalloc() and vfree() but does not
include linux/vmalloc.h. Kernel v6.10 made changes that causes the
currently included headers not depend on vmalloc.h and therefore
mem.c can no longer compile. Add linux/vmalloc.h to fix compile
issue.

  CC [M]  tools/testing/cxl/test/mem.o
tools/testing/cxl/test/mem.c: In function ‘label_area_release’:
tools/testing/cxl/test/mem.c:1428:9: error: implicit declaration of function ‘vfree’; did you mean ‘kvfree’? [-Werror=implicit-function-declaration]
 1428 |         vfree(lsa);
      |         ^~~~~
      |         kvfree
tools/testing/cxl/test/mem.c: In function ‘cxl_mock_mem_probe’:
tools/testing/cxl/test/mem.c:1466:22: error: implicit declaration of function ‘vmalloc’; did you mean ‘kmalloc’? [-Werror=implicit-function-declaration]
 1466 |         mdata->lsa = vmalloc(LSA_SIZE);
      |                      ^~~~~~~
      |                      kmalloc

Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/20240528225551.1025977-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index aa2df3a150518..6e9a89f54d94f 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -3,6 +3,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/sizes.h>
-- 
2.43.0



