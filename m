Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CF5327204;
	Sat, 12 Sep 2026 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220989; cv=none; b=P9Qs48W8d0zyceDkuOw2dKah8dScAlLvTEP1dBbSoqa2VzbeQoYk5RgGNnCIwk5ThF3CxHI/LCwkl54/SX6tB4E+Ju0Kg7Gs8XQshlSSg5xevGnXiOEqLCKKuJAYKOgLK2YTUSFHRCTyEclk9NRkkeXmwlkQrDLDSlFpE++hgiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220989; c=relaxed/simple;
	bh=3J2CYkgisqkyKTii4nbfLPttE7386T0+GjgMxjX1Fkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DERHJ97rX+P5UNw+2vNLL6v62HIyauYqdXK/wtt1H2ScEIDSAKBJOjS3haRUvYuxJvFcnTGHCNYZknJsuwodpr6ULnnqwDGgtKdUHYJR1/yYOhK0qJsWjobVTdkFfV7EKHikM6ORHMY6U3gWlYEK/1XuBGOlKxeUe7hqJ/JSSTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRL/hfSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRL/hfSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53231F000FF;
	Sat, 12 Sep 2026 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220987;
	bh=KxVsAENFZfPloniiRmog6WD7+MdsOnd5JODYeHi74mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRL/hfSd6UTspDKkYpuSj86Sz9feGdlK6bFXT+h68hNZ8MM0hjsNU5CD+SI5coCwo
	 qL8cam9+V0ceGAz2qhCH5weaOyQca09mJ/kjmIGQxAaGhIZOpYlJdzsFeHTODA1YER
	 1RVxmk/Us8QnfqC2rOev3WI4SZHOGQMCKDyNAZ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0290/1424] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Sat, 12 Sep 2026 08:45:22 +0200
Message-ID: <20260912065613.778530232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


