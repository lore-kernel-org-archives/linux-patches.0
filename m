Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA79356744;
	Sat, 12 Sep 2026 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227707; cv=none; b=eQaJEOaQeYZBwSOdr2aVjcI9x6xKpVwBX+f/F3JMPJyhM0mn+HsPjYHFsMqSQ7NZRkrNm/smsqvIWFb4dN6BVtxwXU7QPRw8zxrq8GXtysmCm7mGPespsec+WkHqDk5cVHKs7yQ7dBlGYQzVYO/wtLET4I4dX07RO9J9DpFb++M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227707; c=relaxed/simple;
	bh=OhJJjsf/gkG5Ua/FZdWpvHNEdLcF3SVHW+0SmWVxmOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXqmRzGr+3Q4ptr1moKvHHkVSR3iYdbqnkP0CjTizSHTMm/HtG+GijhFjJgulJjBTZhQcA4V+rHhwuox+IK1Al052Yn2NAjV6ucUprEUyb4tV54QJ8tAa8sOUuSE1PWbdeWDYgcqvHTbspG9PRB5B2BcWZfIJcrkj4knEcaHu6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBhXU4Ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBhXU4Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0061F000FF;
	Sat, 12 Sep 2026 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227706;
	bh=7U86MhdoyK2On3MaBPVFZVgRDn/1wiXGdF06NiumJdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBhXU4Ht7O60rUQgd7Atzsd/cLXHu91sFd1GYyrwKoVA2BSXGCYrduei9VRjmlnRL
	 YNGhhBaBPn/O5v6IjN6WME2Kv3lnqI2u2iJkkT/7HUMl3mcLTpbBjSZoA8Q21c65sY
	 62ULc7B1laBcAZZJ0RyELvl01vakEwBGlxhRKn40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0234/1191] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Sat, 12 Sep 2026 08:49:22 +0200
Message-ID: <20260912065553.466416121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,7 +183,7 @@ static void switch_region_table_write(st
 	pte = sctx->region_table[region_index];
 	pte &= ~((((region_table_slot_t)1 << sctx->region_table_entry_bits) - 1) << bit);
 	pte |= (region_table_slot_t)value << bit;
-	sctx->region_table[region_index] = pte;
+	WRITE_ONCE(sctx->region_table[region_index], pte);
 }
 
 /*


