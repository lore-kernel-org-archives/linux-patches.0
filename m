Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1A443D50C;
	Mon, 17 Aug 2026 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977414; cv=none; b=WeLfPaHpEAMk3pdtpxIu3zpDQqgBUBCmuFfwcQ8vaB35paJTAG4x0tDnoshtFDVAPpO6B9a3jrU0yeqjsK+3iwJH6VUhlm6f1WP36rGyNM1g3E0OIx2TC1diel2r8DquPRhdDhk/1mXXAwm0vGnqPXnBD0XH9P8YiBPbXeLh25A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977414; c=relaxed/simple;
	bh=wk7zoBifaG1iZ81qUFGxn4M6C+L44kqLvZiJACaiqfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ/rz8KUwJVgHmft5ZUhTT4gSLv27/ajwZEQoQK1KRaQBmia8cbZKSodBkQ5MZuqCKmDhPQdmOoF8V3e3P3tgZOFI3ZcCBD+oUH+5dOFXnwl5a0xckI+PcieUnBrMy7IY7n+7w2qzFKEeaG1RJjmwka6bvvd5r1jluJyb0PkxJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC1V0WNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC1V0WNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0BF1F000E9;
	Mon, 17 Aug 2026 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977412;
	bh=IPqPJMzO1jl5kWvd3HwUM1oLXq+4xbjJdRgD+ZuFXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RC1V0WNV3jeqJVZKAf32bAWbXhLxSEmi3MRrcvEAoy0dKfwJZcyqjX0aVRzMWVOfi
	 BgL1CgtUOIQEO7vLGZsoyKZK08+++xi6eJM686ChZjC0T1gbC3zruXhuxkCStBiuFf
	 txNxdeSBfL/+3Iav7+vvN8ovBgM3Mvc43RMWOI94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 321/456] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Mon, 17 Aug 2026 15:31:51 +0200
Message-ID: <20260817132552.250244883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -616,6 +616,7 @@ static int dma_ioc0_map_pages(struct ps3
 
 fail_map:
 	for (iopage--; 0 <= iopage; iopage--) {
+		offset = (1 << r->page_size) * iopage;
 		lv1_put_iopte(0,
 			      c->bus_addr + offset,
 			      c->lpar_addr + offset,


