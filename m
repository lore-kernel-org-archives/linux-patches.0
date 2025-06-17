Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2F2EF659;
	Tue, 17 Jun 2025 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174291; cv=none; b=A30YpPZCbYjm9RWXesabT6vKOOcI49DQX/mKRmFWuqvpr5a0O/k32OCS1GF9oCmYMKeDa48JCEoGcFjyz7n3nOXdIRzmvLvKPjWgg991Gw1wRfiJD0XRh8dOD+3EGtM+B/sBDNlFcD6JndzI9O01f2Tf3K4NZRSxPGsB1ZWGkWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174291; c=relaxed/simple;
	bh=iFgKkBLYHLIquHVbKNJG4ErZQuWH1wDuFGn9XfsPXd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXKH9N74JJWU1d4o9wUGiBe/E+OC7cxItXe1qydm2Bz26F4+rTZNPo+BbHqrtKBH6YEE8EtcmahmMbpPmoiHwciErdyJuS72+36B9RnCRaQsxdrpjM+6oEhbVfaaOiKSrZXQA692lwVs/9neLPQPx2V5VRefYo/FVbuXqPKb70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GokDaXYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GokDaXYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4EDC4CEE3;
	Tue, 17 Jun 2025 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174291;
	bh=iFgKkBLYHLIquHVbKNJG4ErZQuWH1wDuFGn9XfsPXd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GokDaXYkssfD0aXQIkZk0036QnMfFckxKIITMHke0ezehHg6UPk/yhq/tLEetvoKQ
	 YV79uiZ7D0WKVoY0koI6R1fJtLCRJPBASDlf9x+yGowuyB2y6pjhdvpZIa44ZARe/s
	 C0h2ZJF7XDmL6HYPuRN5gHt87j05Ivjt1gGwPXs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xu <feng.f.xu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/356] EDAC/skx_common: Fix general protection fault
Date: Tue, 17 Jun 2025 17:22:36 +0200
Message-ID: <20250617152339.885037156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 20d2d476b3ae18041be423671a8637ed5ffd6958 ]

After loading i10nm_edac (which automatically loads skx_edac_common), if
unload only i10nm_edac, then reload it and perform error injection testing,
a general protection fault may occur:

  mce: [Hardware Error]: Machine check events logged
  Oops: general protection fault ...
  ...
  Workqueue: events mce_gen_pool_process
  RIP: 0010:string+0x53/0xe0
  ...
  Call Trace:
  <TASK>
  ? die_addr+0x37/0x90
  ? exc_general_protection+0x1e7/0x3f0
  ? asm_exc_general_protection+0x26/0x30
  ? string+0x53/0xe0
  vsnprintf+0x23e/0x4c0
  snprintf+0x4d/0x70
  skx_adxl_decode+0x16a/0x330 [skx_edac_common]
  skx_mce_check_error.part.0+0xf8/0x220 [skx_edac_common]
  skx_mce_check_error+0x17/0x20 [skx_edac_common]
  ...

The issue arose was because the variable 'adxl_component_count' (inside
skx_edac_common), which counts the ADXL components, was not reset. During
the reloading of i10nm_edac, the count was incremented by the actual number
of ADXL components again, resulting in a count that was double the real
number of ADXL components. This led to an out-of-bounds reference to the
ADXL component array, causing the general protection fault above.

Fix this issue by resetting the 'adxl_component_count' in adxl_put(),
which is called during the unloading of {skx,i10nm}_edac.

Fixes: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Reported-by: Feng Xu <feng.f.xu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Link: https://lore.kernel.org/r/20250417150724.1170168-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index d47f0055217e4..9e43aed72bd9f 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -115,6 +115,7 @@ EXPORT_SYMBOL_GPL(skx_adxl_get);
 
 void skx_adxl_put(void)
 {
+	adxl_component_count = 0;
 	kfree(adxl_values);
 	kfree(adxl_msg);
 }
-- 
2.39.5



