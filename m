Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74736AC2;
	Tue,  5 Dec 2023 03:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxPlKEBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44691C433C8;
	Tue,  5 Dec 2023 03:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747710;
	bh=gKhoceIljoSL9c08KcPqu2L/7KTbdFQBSDA1JO9iPEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxPlKEBwuAsHzpwhu0PjT9i93FhzxcVnxJ1PQ3jSH6DsaKOo4qCapNZ8z4TMeyFNs
	 3ACxJxlNeH/U1hZ/AxQs37dL335gpHT5sQ1mw7JHSM2GkU6PCrlB6CQ29KKevdk/u4
	 bJwGgv6Xdv5p6+NzOvm1mkRpGZTxjo3aDXkcXnOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Abdul Halim, Mohd Syazwan" <mohd.syazwan.abdul.halim@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Abdul,
	Halim
Subject: [PATCH 5.15 16/67] iommu/vt-d: Add MTL to quirk list to skip TE disabling
Date: Tue,  5 Dec 2023 12:17:01 +0900
Message-ID: <20231205031520.742983694@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdul Halim, Mohd Syazwan <mohd.syazwan.abdul.halim@intel.com>

commit 85b80fdffa867d75dfb9084a839e7949e29064e8 upstream.

The VT-d spec requires (10.4.4 Global Command Register, TE field) that:

Hardware implementations supporting DMA draining must drain any in-flight
DMA read/write requests queued within the Root-Complex before switching
address translation on or off and reflecting the status of the command
through the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do so after some
kind of power state transition. As the result, the system might stuck in
iommu_disable_translation(), waiting for the completion of TE transition.

Add MTL to the quirk list for those devices and skips TE disabling if the
qurik hits.

Fixes: b1012ca8dc4f ("iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu")
Cc: stable@vger.kernel.org
Signed-off-by: Abdul Halim, Mohd Syazwan <mohd.syazwan.abdul.halim@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20231116022324.30120-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5749,7 +5749,7 @@ static void quirk_igfx_skip_te_disable(s
 	ver = (dev->device >> 8) & 0xff;
 	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
 	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
-	    ver != 0x9a && ver != 0xa7)
+	    ver != 0x9a && ver != 0xa7 && ver != 0x7d)
 		return;
 
 	if (risky_device(dev))


