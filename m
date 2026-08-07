Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400147CA8C;
	Fri,  7 Aug 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117397; cv=none; b=Ngu1pF21sqFrzYDGY1klmx7Zbx2V1VfHuXSNf2Yeajmqyt/DiscphlHAOi12RyEMbY4NhO+RRprjUawJU2fn4avF3sM/FiyPY19R9Sl7WwMCJpeUlVFvFUNgzNLpMhNJOhP1HD9Aioh26pqN+OOBkGDp68g+ujfZAKPyW09hGDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117397; c=relaxed/simple;
	bh=6sQDTrXXkfZt2H9K1Ge/KiOuY04+nNXLzl9Mf2cgqGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2uENpjKWUlcmTcucBok1un78XE38BKAMkwCXuIWirUGSQJbY7UPtgUAZ8PhL5imSktsHMuyawg5thRRC8rxRVXt1CVQyyLPrsyW8STOR5jrCRVlhN9DN0An3X97aQkf2HMzxmv9pGXlUx5kjdlccI3FbW+ZGtp6Ms2ruZrPE6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qn+2pNzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qn+2pNzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A12C1F000E9;
	Fri,  7 Aug 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117395;
	bh=PcX3VZi6PRJRGv3UlrpNCN7yRvZVwjaqfwmcokyiHQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qn+2pNzIKCWInuq4EREshyUh6VvFxsJrXb50r/I8/uVg9in0rA0Zr5aF0Mt/CVJot
	 9ZvbhE5gTjQWnb+W+a4U0EOOhcItiCbNEEcJRxkKqpSzVlLw8+RLEkyEwWdm61syKy
	 JWgu/JH8vzHSx/d01I+DxVpQyGuxCGbPteM9K0T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 302/438] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Fri,  7 Aug 2026 16:38:18 +0200
Message-ID: <20260807143434.410047511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


