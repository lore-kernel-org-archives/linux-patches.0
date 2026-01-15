Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460553C009B;
	Thu, 15 Jan 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499659; cv=none; b=kKGbmZMwdCDq03W/En2+2Hio/yo/L46hshEZ473XYAx7EOSmm3ORUZ9jwZRYvw+AeQH45IAg+BH9hLwfOB9xVhil9Z8aWfSAjNWlfQ/6BWRmIaP4aaVbql2lQMIm9ebCv0lxlcM57V9kfvoqtifXqpBF3A4xb8WzJeuAu7ZkQ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499659; c=relaxed/simple;
	bh=dVcKaO5FLquctu4LDCejOL8ypOwrgs/Fxcgd50gmaQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWMaO4PT/ThDWzmp8xi72LyqUaCr8FjknoTFbLP4fXtCToa0RwSijU0eCwjX+mlcNYcCtZ1ZIFUpEUPdc62a9XJ5XgwMpiLHSPiOcXx89tBXBOiut0mwXftz+QkPNXIdB6E4ixWzINBb2RVk/QEyRWQG4b+VwJmFgQ3uu9lWu3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GczMo9tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GczMo9tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEE8C116D0;
	Thu, 15 Jan 2026 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499658;
	bh=dVcKaO5FLquctu4LDCejOL8ypOwrgs/Fxcgd50gmaQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GczMo9tPmJsSFIfty2BqiOQ7R4gOBHvLEgF1or2+T2VDu4b2EjlsFiX9NtnQ1QNOM
	 /N+GsyNI7TOdtF8nQv6nVPVKSyYc/bN2MAjkFu8W7vrf1Uzw6WOiy2Pm4WAoTsfIUj
	 xJuc8+imXIrKxW4iLj37bibROFm318v49o2qhWlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/451] iavf: fix off-by-one issues in iavf_config_rss_reg()
Date: Thu, 15 Jan 2026 17:47:53 +0100
Message-ID: <20260115164240.726272354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 6daa2893f323981c7894c68440823326e93a7d61 ]

There are off-by-one bugs when configuring RSS hash key and lookup
table, causing out-of-bounds reads to memory [1] and out-of-bounds
writes to device registers.

Before commit 43a3d9ba34c9 ("i40evf: Allow PF driver to configure RSS"),
the loop upper bounds were:
    i <= I40E_VFQF_{HKEY,HLUT}_MAX_INDEX
which is safe since the value is the last valid index.

That commit changed the bounds to:
    i <= adapter->rss_{key,lut}_size / 4
where `rss_{key,lut}_size / 4` is the number of dwords, so the last
valid index is `(rss_{key,lut}_size / 4) - 1`. Therefore, using `<=`
accesses one element past the end.

Fix the issues by using `<` instead of `<=`, ensuring we do not exceed
the bounds.

[1] KASAN splat about rss_key_size off-by-one
  BUG: KASAN: slab-out-of-bounds in iavf_config_rss+0x619/0x800
  Read of size 4 at addr ffff888102c50134 by task kworker/u8:6/63

  CPU: 0 UID: 0 PID: 63 Comm: kworker/u8:6 Not tainted 6.18.0-rc2-enjuk-tnguy-00378-g3005f5b77652-dirty #156 PREEMPT(voluntary)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  Workqueue: iavf iavf_watchdog_task
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6f/0xb0
   print_report+0x170/0x4f3
   kasan_report+0xe1/0x1a0
   iavf_config_rss+0x619/0x800
   iavf_watchdog_task+0x2be7/0x3230
   process_one_work+0x7fd/0x1420
   worker_thread+0x4d1/0xd40
   kthread+0x344/0x660
   ret_from_fork+0x249/0x320
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 63:
   kasan_save_stack+0x30/0x50
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x7f/0x90
   __kmalloc_noprof+0x246/0x6f0
   iavf_watchdog_task+0x28fc/0x3230
   process_one_work+0x7fd/0x1420
   worker_thread+0x4d1/0xd40
   kthread+0x344/0x660
   ret_from_fork+0x249/0x320
   ret_from_fork_asm+0x1a/0x30

  The buggy address belongs to the object at ffff888102c50100
   which belongs to the cache kmalloc-64 of size 64
  The buggy address is located 0 bytes to the right of
   allocated 52-byte region [ffff888102c50100, ffff888102c50134)

  The buggy address belongs to the physical page:
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x102c50
  flags: 0x200000000000000(node=0|zone=2)
  page_type: f5(slab)
  raw: 0200000000000000 ffff8881000418c0 dead000000000122 0000000000000000
  raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff888102c50000: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
   ffff888102c50080: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
  >ffff888102c50100: 00 00 00 00 00 00 04 fc fc fc fc fc fc fc fc fc
                                       ^
   ffff888102c50180: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
   ffff888102c50200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 43a3d9ba34c9 ("i40evf: Allow PF driver to configure RSS")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 65259722a572..4ed93c7f81d2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1262,11 +1262,11 @@ static int iavf_config_rss_reg(struct iavf_adapter *adapter)
 	u16 i;
 
 	dw = (u32 *)adapter->rss_key;
-	for (i = 0; i <= adapter->rss_key_size / 4; i++)
+	for (i = 0; i < adapter->rss_key_size / 4; i++)
 		wr32(hw, IAVF_VFQF_HKEY(i), dw[i]);
 
 	dw = (u32 *)adapter->rss_lut;
-	for (i = 0; i <= adapter->rss_lut_size / 4; i++)
+	for (i = 0; i < adapter->rss_lut_size / 4; i++)
 		wr32(hw, IAVF_VFQF_HLUT(i), dw[i]);
 
 	iavf_flush(hw);
-- 
2.51.0



