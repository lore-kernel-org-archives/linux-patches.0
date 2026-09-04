Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9741D22E;
	Fri,  4 Sep 2026 06:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502923; cv=none; b=tZ9ro/xbakexUC0GBCTtNHKUadPBbiA+KMrKqhLCKqfYkq8ZWpxhsY/k2H7d4+IFgNbn6OwCCToLV66wEUmdAIw14pkk3+iTnjCDGBJazy/h1mIbN4HmoaIcUWHM+nxMvhVcrigfRTziECTxW/Wpd4/DD7GJqIQVOeh8ezGo0e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502923; c=relaxed/simple;
	bh=xYktqxXK8QkKEwjCj1laCvX1ThDjtn3ww9pZavBi0IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFRHSI5kMWo7xVVNVX+tgcgX4rTpQzQsw0CWxbjKSZuyRxVbTelUnZqB38fvr0VIWVxYOVa8lznMog3ZYS7RbhmoPiOtYTRchd+ANjjovGMpjfVQDoLWnDJV5x8n76RdcfVuq76amwRQ4ondnXx3AsDX1R00eXhm7xEYKkKLC/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR4z/MNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR4z/MNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C111F00A3D;
	Fri,  4 Sep 2026 06:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502921;
	bh=PV7S9ygUBVgG6hiW4CeYZcAj3yOjvBoY3LL/hLsqBIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR4z/MNk8fF4FQcqsdJGCnkah2pbbdvVKRCDuvT4HpwA/i22U0eCKxOSwQeO1WdpJ
	 n202PFHmPpoVzsICYd2iCsu1noOfK85RcokobXVE/o/hL2u3UVi5RPaZcEj/Sziu6K
	 XiA9ka3L4pZLoPOKOQGi3vy8/iUmYDy7oqkYMMK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 378/403] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Fri,  4 Sep 2026 07:03:01 +0200
Message-ID: <20260904045743.391899089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


