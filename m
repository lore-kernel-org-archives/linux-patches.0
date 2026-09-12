Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25C38398F;
	Sat, 12 Sep 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237154; cv=none; b=pu7OR4H/ygj9EkJgemnc7arQm3/5iymW1lFhkqek71wxitM/5eHkIBSvXuNkg3+MNZVEx9NVxKQBw2pZsicafbn8NZRjzFGufm6uH66wSGyyGdkjFBPVyavNatdJUEgP6mf9VIDXSKXHOdbNmIWTYHJuIcTkfxrJGyAu1iQmQ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237154; c=relaxed/simple;
	bh=NqW1GlZ6ev74tu+4lm6bpJi9DA7vUiA1Rz3NgHRLf0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvSeYdhQ/wCp2klqvQVe+BZwMeSIyRE1K4U4pml9C2J0KC5kJmQBzdKYTtGNZXYTrmcPIjMvIPhc2BwOuGRwttY81peHCt63qKv6BxfnSa2pfYUBBx1pVaJ482bsYhHikmYl7wt+83DaAZgorDKukPbJXAXKtPhIfhshRPlsFfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fab4QlC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fab4QlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9F31F000FF;
	Sat, 12 Sep 2026 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237152;
	bh=KVaNYMfQt0yyL1kVWezLpYX1QLPXqVWdNhMAgKwn3ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fab4QlCrMLLFYfNveqzOdNvN72jHcJPSGbjJwumk+CQAvkgX5bScZ69FArVV0kvG
	 fjX1UsGW5gfntVUnl/YzzAGpdIRbO4IoabqWfOoMX/Iz0/KKpzulWy6ePPn/DXswRY
	 aTYW1sRB991zjG0TQopfOxsW2N+hxBlW3zOyoxtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 200/935] dm-switch: use WRITE_ONCE() in switch_region_table_write()
Date: Sat, 12 Sep 2026 08:53:50 +0200
Message-ID: <20260912065531.401544780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


