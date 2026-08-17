Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D03DDB0D;
	Mon, 17 Aug 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976140; cv=none; b=EZ5vjClmMyKtR7U6c0UUauU4rGxJxQk+DzKN0uwzs/EbhBPKL/rpzl/3uk2EftSoxMnRolp4Xk+Ho0eXaw5QD4zjlE9OBJAVsU34v9v/HfdZwagLjcpDV0TSfwDI0R4Zgj6s5dum6TSFClCEBCcmQagKiNKpBpJHJH0sse0LVM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976140; c=relaxed/simple;
	bh=0yOs8wtKa2omkEi658/mQc3LtUGBYqmhmZiLas/IfBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV2reTpMZThPGtOzMJ8ByjhJbpZvvPqWYYwGa5zskKxs8U32J9BYOI9eKj0G+KH/tlZ0O23MVojrKFzJ0dOGip9q94tg/tRuu6Dm+X5LqtlVLeZoYsDcAHdqbB/LEBTyCSPPhFAa6iicxWjey76IQhQ6frv8V/xWbLruXGpoGPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX/ZkjLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX/ZkjLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ED71F000E9;
	Mon, 17 Aug 2026 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976138;
	bh=pKJwBgYCqfF69Gb8LgJY6UWbfe40MEPTY0bVeQOL87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PX/ZkjLM4uZw1iOq7uugQ7yW4SzN89mDA9IPw92ZMMpSLX38g2cMQcz2UQ3JlxBOB
	 iuoBBis68D5RS77BmbBYU8mTIEKZmkE7BmZig3I4Rl0x+XE83PNwIcaJE/d/lUNKPV
	 lURCBxbWr4bWRt8tD4Tm8HbknhS9Oqkj1pp85hiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.10 269/389] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Mon, 17 Aug 2026 15:31:48 +0200
Message-ID: <20260817132549.664894230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 0bb024f11d120abff3e8db9144a585b9d7fb8459 upstream.

If lv1_put_iopte() fails in dma_ioc0_map_pages(), the error path
decrements iopage but keeps using the failed mapping's offset. As a
result, it repeatedly tries to invalidate the failed IOPTE slot and
leaves the already installed IOPTEs valid.

Recompute offset and invalidate the installed IOPTEs instead.

Fixes: 6bb5cf102541 ("[POWERPC] PS3: System-bus rework")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260711130931.740719-3-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/ps3/mm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -614,6 +614,7 @@ static int dma_ioc0_map_pages(struct ps3
 
 fail_map:
 	for (iopage--; 0 <= iopage; iopage--) {
+		offset = (1 << r->page_size) * iopage;
 		lv1_put_iopte(0,
 			      c->bus_addr + offset,
 			      c->lpar_addr + offset,


