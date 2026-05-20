Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3FF3EA953;
	Wed, 20 May 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299829; cv=none; b=OMOWmBLKD03Fc13opAsICYOv8ffqGmn2eBy5RetzquVsOUaZfiXdIOSVzTvRdKwHyygN6Xs8ypLwlIAFxgzyWBZ9jRYzBdl8md8Qa/b/fJnM/HDdtLN9RVlYpuMRbambF08gqaCi67N/yokiI2W8c+2FQoQtWu0J3tG6YnkDwgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299829; c=relaxed/simple;
	bh=S+ETa0MOVTiSeNq1GFK0W7VFsbb/aUQg7qkj3cxfLD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwrYC4z77TRuHoWfkJ3YsrPcHUHSWiE3HvPJqfJQg3SP/8QI37GIjY4SHoMbje3DWPopBnl5xMaTPbgdfFiBhluGgH9Jiep4dmGoefZdv6TKI/zotSQEPp8/x8O9bsYk/2VS46+ENH8Dxq+/61n4kz5mBIBSjbzhGl0bnrTYl4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THrbHs69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THrbHs69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF9D1F000E9;
	Wed, 20 May 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299828;
	bh=CrcUsgG9+4XWlBHd/A+EjpfxLIdCLicb9cCj5CvKnZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THrbHs69nbA+USrZ8ggmYLqoVljC2gejiOrwySR8DFgBMKPS8u/oqbuDOBEDWXudM
	 jag7CTRNv/lN7wSYs5LmSl1C93J60F6dWlYgF5nQ8Phj7S+5ZRIRxGN0S0q1ptp9M5
	 6GU1OafMVssCpfKiYMk8RSfEKy4fqeoePoNVn6is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 885/957] net: ena: PHC: Check return code before setting timestamp output
Date: Wed, 20 May 2026 18:22:48 +0200
Message-ID: <20260520162153.761226304@linuxfoundation.org>
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

From: Arthur Kiyanovski <akiyano@amazon.com>

commit 24a08d7d6218d60c033015cf4870b6096446e734 upstream.

ena_phc_gettimex64() is setting the output parameter regardless
of whether ena_com_phc_get_timestamp() succeeded or failed.

When ena_com_phc_get_timestamp() returns an error, the timestamp
parameter may contain uninitialized stack memory (e.g., when PHC is
disabled or in blocked state) or invalid hardware values. Passing
these to userspace via the PTP ioctl is both a security issue
(information leak) and a correctness bug.

Fix by checking the return code after releasing the lock and only
setting the output timestamp on success.

Fixes: e0ea34158ee8 ("net: ena: Add PHC support in the ENA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260507003518.22554-1-akiyano@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_phc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_phc.c b/drivers/net/ethernet/amazon/ena/ena_phc.c
index 7867e893fd15..c2a3ff1ef645 100644
--- a/drivers/net/ethernet/amazon/ena/ena_phc.c
+++ b/drivers/net/ethernet/amazon/ena/ena_phc.c
@@ -46,9 +46,12 @@ static int ena_phc_gettimex64(struct ptp_clock_info *clock_info,
 
 	spin_unlock_irqrestore(&phc_info->lock, flags);
 
+	if (rc)
+		return rc;
+
 	*ts = ns_to_timespec64(timestamp_nsec);
 
-	return rc;
+	return 0;
 }
 
 static int ena_phc_settime64(struct ptp_clock_info *clock_info,
-- 
2.54.0



