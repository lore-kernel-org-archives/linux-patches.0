Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6713815E1;
	Fri,  4 Sep 2026 05:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500107; cv=none; b=tVDG4hQCP2wvE1MgXW9FSPZ76pCpt9uRvE5yegySfcZIAkz58lIUSid4vii/XPC7ruuT5DkCdlbhC4bKdDSF3lhKllkp3Ggk5Gz/hObK7Db+T/cCwUnUA4ci/gPbn/rf5tsjEzg/WSwZ/SdGaKD04oBkX5uqzdhMltBuPdHiN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500107; c=relaxed/simple;
	bh=aXZbNmdfbr3nrqNh98PE0DBU8QBxGhE4+kGIh48R9eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc/DdMfH8Y6Tcln5WafLulbT7vmVq2T2B3VSiZ5uUe05/fWOX8rx8PIBgZq25NxXIFxxEwqzj4mDjIAYfHSACywvBqlRAoflZVOORncNgJ3FA7TpWwkpFlz5fJ1JdtBQcOF2PbX99IIhEhOoa0GcHKirgGwRpwQNONPIJM4fqzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14Vn6EU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14Vn6EU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE2D1F00A3D;
	Fri,  4 Sep 2026 05:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500106;
	bh=Ku+Uq05aL///3CYbNWzP+oHPcjySjehRGljzLnDRCUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14Vn6EU68IHUToBe3Ka+8VJg11zyAruV9EO8PSHF59IN5TJxFM0d3DAeqN9mlt5Mo
	 ExXAQ0CXCt1YK0H2SwlBddzxHKQNUEFTg99uIUFNNdkIHDmhuMkCvTBPWpNdt/JKRB
	 iKaPnFIKWKvopF8KyFzZmVPSzlAJuiu7ju1+4gwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 653/713] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Fri,  4 Sep 2026 07:00:21 +0200
Message-ID: <20260904045818.470458816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c7391ebe33162c7962b313caea4d8e6b0bc2a671 upstream.

switch_region_table_read() accesses the region table with READ_ONCE()
and is called from the lockless switch_map() IO path. However,
switch_region_table_write() stores to the same array with a plain
assignment. This results in an inconsistent access pattern for a
lockless shared variable and may trigger data race reports.

Use WRITE_ONCE() to pair with the existing READ_ONCE() in
switch_region_table_read().

Cc: stable@vger.kernel.org
Fixes: 99eb1908e643 ("dm switch: factor out switch_region_table_read")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -184,7 +184,7 @@ static void switch_region_table_write(st
 	pte = sctx->region_table[region_index];
 	pte &= ~((((region_table_slot_t)1 << sctx->region_table_entry_bits) - 1) << bit);
 	pte |= (region_table_slot_t)value << bit;
-	sctx->region_table[region_index] = pte;
+	WRITE_ONCE(sctx->region_table[region_index], pte);
 }
 
 /*


