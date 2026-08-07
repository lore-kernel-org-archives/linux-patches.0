Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E555537F334;
	Fri,  7 Aug 2026 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116154; cv=none; b=pMLH7qNy4kxwlq8HnqTTNloupTwoVt2Zhs5PfHbshm8Xwi21zZMwmj9Qvj4Hv0wVN5uQNeoUPBdhXBtrdH+GT+SzaRzQP9zcDqiF6ZBmMKDpcziAhOcckd3qpLq2Syz2cjasLU5jbMz/OjlxEiWoPt5gydlBmquYKZfh4tmN0fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116154; c=relaxed/simple;
	bh=WmEdaxCYHcCyGqapyFM9S2b1uxwemXAerS7pMuP3MEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg4TnVSD3v3tS8ruvwairWX7r7SqIBZW66OQfJ7/kGxbbUphjd3CG4dQKBTwIPq4qetbmv/bqZbyHJwayPvgQKEwvlZsmHctIuFBJ9/DYx0cOgQaNkhRBx7T5g8K0iScfg1VJ6sPvaabh7cMqmtsx2+5lyNi/lyVM90q2EXu+qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iALp4JSW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iALp4JSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8441F00A3A;
	Fri,  7 Aug 2026 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116152;
	bh=QnuzQfGCvtYWoc1yqy58VZ4PEL88C94KwdftVxPu2os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iALp4JSW/kaRfdndbI6hYs4Uc/FXIjEUj/HKrbcbO0vXghV5Oafkr88EFlag3TawQ
	 i6e0E4LumoizFvkbqm7rMMqbqGSX/QnihG8QMVpwSEFHcOhKnivHRW1iwgEfEbWIWD
	 R+hkQ51VojlCbnoJpTv565qTmzHfP69k3U7ZlurY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 132/261] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Fri,  7 Aug 2026 16:38:09 +0200
Message-ID: <20260807143418.213425721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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


