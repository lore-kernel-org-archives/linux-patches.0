Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91583EAC6F;
	Tue, 17 Mar 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766486; cv=none; b=BckFZuirZZD3MbzMDMO7VouC7pUGR08gexApF6Iax5mVPDMhA0w/QUmg8VLoLIRiWAhn28n3uWpkAUq8Mko9UTzAkF87toP/HvcX1B+GFozZjYpx1s46IWZHxaJsSlA+T3ixnxDm3fTvGR2/XfNEO8mibypjhC9W/gFgxdBic6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766486; c=relaxed/simple;
	bh=oQvg3HHMDT9xE8mziGJJFwtgZnvapOKh8QtFwu0hwAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njA9Nb5sk5o5+Sj/ZHOjlJPwALncjOV77dfITRfMMJrc9DX3eCzTYJarNEKwqdE4v/oleQVaKpsgvBJTE5RMJm/C6xAFmKZjQQ+cl/KQUPhRRIoOnnajngQ5N4rz6GRtPVdgPDaei/ygchAkzY8eGu2F6NCOu1msfUY9L50umak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQXP5cuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQXP5cuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A539C4CEF7;
	Tue, 17 Mar 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766486;
	bh=oQvg3HHMDT9xE8mziGJJFwtgZnvapOKh8QtFwu0hwAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQXP5cuEk34WniCUaRy7JR82QkSG6ycj0K/9d0TBKJNhEVV9Voxpx68ZtlDzR9vNS
	 m4To8f9Tpdtii9jCom+cSr+T5bXe76WBYEv9+i1xU2NgLjDoI/DNI1fp/ae4plvVtv
	 WmtcIHOlQ0JxSvjGq8yPIAgyD/d7WZPZeDM6sky4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.19 256/378] pinctrl: cy8c95x0: Dont miss reading the last bank registers
Date: Tue, 17 Mar 2026 17:33:33 +0100
Message-ID: <20260317163016.435634876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b6c3af46c26f2d07c10a1452adc34b821719327e upstream.

When code had been changed to use for_each_set_clump8(), it mistakenly
switched from chip->nport to chip->tpin since the cy8c9540 and cy8c9560
have a 4-pin gap. This, in particular, led to the missed read of
the last bank interrupt status register and hence missing interrupts
on those pins. Restore the upper limit in for_each_set_clump8() to take
into consideration that gap.

Fixes: 83e29a7a1fdf ("pinctrl: cy8c95x0; Switch to use for_each_set_clump8()")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -627,7 +627,7 @@ static int cy8c95x0_write_regs_mask(stru
 	bitmap_scatter(tmask, mask, chip->map, MAX_LINE);
 	bitmap_scatter(tval, val, chip->map, MAX_LINE);
 
-	for_each_set_clump8(offset, bits, tmask, chip->tpin) {
+	for_each_set_clump8(offset, bits, tmask, chip->nport * BANK_SZ) {
 		unsigned int i = offset / 8;
 
 		write_val = bitmap_get_value8(tval, offset);
@@ -655,7 +655,7 @@ static int cy8c95x0_read_regs_mask(struc
 	bitmap_scatter(tmask, mask, chip->map, MAX_LINE);
 	bitmap_scatter(tval, val, chip->map, MAX_LINE);
 
-	for_each_set_clump8(offset, bits, tmask, chip->tpin) {
+	for_each_set_clump8(offset, bits, tmask, chip->nport * BANK_SZ) {
 		unsigned int i = offset / 8;
 
 		ret = cy8c95x0_regmap_read_bits(chip, reg, i, bits, &read_val);


