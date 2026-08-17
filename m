Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01295442B30;
	Mon, 17 Aug 2026 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979989; cv=none; b=awztiN1PzAqqNtiQAwPOMZfnxL9YzdxluzJHDyuAENclO3ShoSKKgsBdltMoBE/W66vMxr8RXPKFWtfSFI5mM2iRSPCAG3OXEVXPBTTvigqa8wB1194Cb1IdsP3i8ASEzlNXO3w9G5OJG8yK/1IWdZowLRIGvoszLJJxedA1/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979989; c=relaxed/simple;
	bh=sD/jkARI6GRfJagKxGjM1paMYjMBt6X14Wi5Ujd3lJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgOpOrhgmSTw90MkUuCyRZ2bSxV/1ScCPSmymVymDOuSl/EcuA9CEChXkmjO8zSx9W/knt44mNdBUcMMfDqLJQdYN8dd5X0nCAeLt3ldjaYKuQhsx71aeLC+0JqRHpRnBILbvot7x+fkwxvJ3GlDTUCvXwvqkBhjKIHfFjei1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S/5J1tK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S/5J1tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D9C1F000E9;
	Mon, 17 Aug 2026 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979985;
	bh=eVN0nk5We8x89O8mUcvUO1kHcFlI3nKDfSZIXyOEyco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2S/5J1tKVxEcjMgGRb5eiPyyWPSpFr4XtRuRvWvYNZU+iZ8OBfmb8hkXswO0xsKs5
	 D7XSsoR6JEdjvlBEvd0rRCaNgEDPqCl3IakeFhXzTjDV2B0P77wsLEBozGj+sVejg9
	 PkiaMQeHl69quws6Ga9b53r+VYCIiVv+5qZkXoOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 417/609] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Mon, 17 Aug 2026 15:31:53 +0200
Message-ID: <20260817132558.084720567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


