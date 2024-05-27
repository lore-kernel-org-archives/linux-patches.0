Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970517727;
	Mon, 27 May 2024 19:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838367; cv=none; b=NqNCQH1mgdpcGiNYVyvDwlp+H6v8THNBoPAs5qefx2FQhoMR2XL8gF4SmbE/QB0e+AjEfnaiTQ+vpWAzRKe+2iUooQCpb5OW/mDg5vJie9f9tSDr/Ms+C9sChHLGzRIopxpi9Lo1JFNLzpxMysve/0u4rqkDNIpepuzM1OCPAYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838367; c=relaxed/simple;
	bh=jnV8Frh46TKX6J9ZFlmXHiNi9uNDSOem8JgGbbNXAIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqIg1oKTqm+S9HZHa4gOagumzxELOK2p2TfwwjFF+aTVVPWdU0RZ7FvUmneYmsIbBB4LqZDyg14pVRt5WFtb2/lR5PLuqhXH09gnaPT9saj2Wdbxk5viLo9fy1KmAfIAYOQ/lPMPdwHKy5lFe4HoEeg7nYY7bzSAnPQ6/BRM08U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtZh3keT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtZh3keT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F66C2BBFC;
	Mon, 27 May 2024 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838367;
	bh=jnV8Frh46TKX6J9ZFlmXHiNi9uNDSOem8JgGbbNXAIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtZh3keTKzv/uThyT/Qh22ZtNRH9J1SPnKEETswIq1UR7hLo8Q7CVL2ttaDASrttV
	 DQfEH85QKpIAacSQk/l1WK17fcASX05XYb9FPDTAU6PBpQgT3LtNuDUN1vvxWo313A
	 yiMx+m2Wgpkkrh7vE81qhvaZzFEdb88mzsAhsFZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Robson <donald.robson@imgtec.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 366/493] drm/imagination: avoid -Woverflow warning
Date: Mon, 27 May 2024 20:56:08 +0200
Message-ID: <20240527185642.258869843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 07b9d0144fff9af08b8dcd0ae134510bfd539e42 ]

The array size calculation in pvr_vm_mips_fini() appears to be incorrect based on
taking the size of the pointer rather than the size of the array, which manifests
as a warning about signed integer overflow:

In file included from include/linux/kernel.h:16,
                 from drivers/gpu/drm/imagination/pvr_rogue_fwif.h:10,
                 from drivers/gpu/drm/imagination/pvr_ccb.h:7,
                 from drivers/gpu/drm/imagination/pvr_device.h:7,
                 from drivers/gpu/drm/imagination/pvr_vm_mips.c:4:
drivers/gpu/drm/imagination/pvr_vm_mips.c: In function 'pvr_vm_mips_fini':
include/linux/array_size.h:11:25: error: overflow in conversion from 'long unsigned int' to 'int' changes value from '18446744073709551615' to '-1' [-Werror=overflow]
   11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
      |                         ^
drivers/gpu/drm/imagination/pvr_vm_mips.c:106:24: note: in expansion of macro 'ARRAY_SIZE'
  106 |         for (page_nr = ARRAY_SIZE(mips_data->pt_pages) - 1; page_nr >= 0; page_nr--) {
      |                        ^~~~~~~~~~

Just use the number of array elements directly here, and in the corresponding
init function for consistency.

Fixes: 927f3e0253c1 ("drm/imagination: Implement MIPS firmware processor and MMU support")
Reviewed-by: Donald Robson <donald.robson@imgtec.com>
Link: https://lore.kernel.org/lkml/9df9e4f87727399928c068dbbf614c9895ae15f9.camel@imgtec.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_vm_mips.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_vm_mips.c b/drivers/gpu/drm/imagination/pvr_vm_mips.c
index b7fef3c797e6c..4f99b4af871c0 100644
--- a/drivers/gpu/drm/imagination/pvr_vm_mips.c
+++ b/drivers/gpu/drm/imagination/pvr_vm_mips.c
@@ -46,7 +46,7 @@ pvr_vm_mips_init(struct pvr_device *pvr_dev)
 	if (!mips_data)
 		return -ENOMEM;
 
-	for (page_nr = 0; page_nr < ARRAY_SIZE(mips_data->pt_pages); page_nr++) {
+	for (page_nr = 0; page_nr < PVR_MIPS_PT_PAGE_COUNT; page_nr++) {
 		mips_data->pt_pages[page_nr] = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!mips_data->pt_pages[page_nr]) {
 			err = -ENOMEM;
@@ -102,7 +102,7 @@ pvr_vm_mips_fini(struct pvr_device *pvr_dev)
 	int page_nr;
 
 	vunmap(mips_data->pt);
-	for (page_nr = ARRAY_SIZE(mips_data->pt_pages) - 1; page_nr >= 0; page_nr--) {
+	for (page_nr = PVR_MIPS_PT_PAGE_COUNT - 1; page_nr >= 0; page_nr--) {
 		dma_unmap_page(from_pvr_device(pvr_dev)->dev,
 			       mips_data->pt_dma_addr[page_nr], PAGE_SIZE, DMA_TO_DEVICE);
 
-- 
2.43.0



