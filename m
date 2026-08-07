Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA113AB26D;
	Fri,  7 Aug 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114211; cv=none; b=sKbEsistjx791fTQIfNfloeflPtJ16iSI9NeO/4Dj5JVcPoP1hS4ad5wF+eZ5X7aKPAIJ2MBI59H/tFZlH2WuL6wxGwjz67vSSxflbXdinHMUUTw7u8M3aWqK9ZQwDm9wSffLnzq/vS/Ou9FFti9rRKtxdeP1vKAOmO9fXdBeUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114211; c=relaxed/simple;
	bh=5RWaiNgGoit+HeTz4kAjwB2IgRBoO8pWnIfycR1IFNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8gPVhiFE7bYqViIzhuLkAed/u6kfl2zQjK0tydlt0LC32va3ER9OYDTfm5WvU6EoO9zptDOyR7Z3UtmD/3GOuB9WHmxzbUEm65TQpOPT5gsgIabgA6tWQJaCwTnKLnPOhtEDELldxIiSXnVWYCtu7MWpZCHBaBlVTPgrJe8lE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRbd0AvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRbd0AvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E691F000E9;
	Fri,  7 Aug 2026 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114209;
	bh=60S8FBra5ebZXhyYxRqxc/1ivTxZsBjCy0ourIiv3z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRbd0AvBSjMir3U/x4cQO1rOpIK+7SUg7hgQwRy63wxnomqDijKm5i0e9Umbo4+P/
	 fg20Qm+i6Y/+JIfZnnAvEhSSGru8sUzce/cjRebShgK3wHMwTEV17Jqhjj91kh+bTn
	 u/gAHFR2KscxXFFtsmJfZ+FX06rAXYHAYhSGlpog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 184/337] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Fri,  7 Aug 2026 16:36:27 +0200
Message-ID: <20260807143422.547391680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -615,6 +615,7 @@ static int dma_ioc0_map_pages(struct ps3
 
 fail_map:
 	for (iopage--; 0 <= iopage; iopage--) {
+		offset = (1 << r->page_size) * iopage;
 		lv1_put_iopte(0,
 			      c->bus_addr + offset,
 			      c->lpar_addr + offset,


