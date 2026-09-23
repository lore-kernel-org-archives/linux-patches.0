Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B03538D81;
	Wed, 23 Sep 2026 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175261; cv=none; b=OeyQZudQLNBz7ODCRypHLmqes4dXt1SBmO+bKK+iyGokN+xjIQkYgOEJE1mF/ZiIcRTfCwS0PtSmh+inW/Opph2RevX2Ss6FWK+fxG56fUhnZGUtSUkOsSjephyKolHSQZ8+Wh0Tb3+sv2b0yF8hZ3/R6rU/sw3CPKOsYAXkBlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175261; c=relaxed/simple;
	bh=f4l1LqwsT6CYQmZ5jdD3Ozb8Vqc4wIbgN/PBLoTask8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKdvnV7C7vOidEDAzNuDTyvpRy2fl8NdsHusRFSStXnutVDz9BDr7S+1PoW5bDQAegxOJyMjKNTgEBTFElda4ZQALGCfMJ9NnLue1dAMLHt9thDd5OABl+0mxIbUVh8bk3vSOEc3pStyEAxRGtZiy7Mj8I+iT60F0TKDwBB1/wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnjztRUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnjztRUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC21F000FF;
	Wed, 23 Sep 2026 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175260;
	bh=y6gpF8aqwlALUpo/l9XeE0k/UhBZIq8xinSx73P21mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnjztRUM++7SRmdVhThtumZyCEeAitdL0AfFAf8MhMWdVPodDZcZAZamyFmM1TNb4
	 cwkm3tLhsl5V4dV71lnjTu1PNVOm+dSbrsbJwmfiLzci/jeBN00VUz+ZkBMEGdknqv
	 cfKuwxblpNRLrEwIDEzdlt+UowGHDHgGu5mln1hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/398] mm/vma: correctly unaccount on mmap_prepare() failure
Date: Wed, 23 Sep 2026 16:07:26 +0200
Message-ID: <20260923140653.089641432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

[ Upstream commit 6cc27d82196385fe06853319f74312a7d8019726 ]

__mmap_setup() accounts memory for relevant mappings via:

security_vm_enough_memory_mm()
  -> __vm_enough_memory()
    -> vm_acct_memory()

If __mmap_setup() fails, this indicates that this accounting did not take
place, and thus it's appropriate for __mmap_region() to jump to
abort_munmap.

However if call_mmap_prepare() fails, it also jumps there and any accounted
memory is not correctly unaccounted.

Fix this by handling each error separately.

Link: https://lore.kernel.org/20260902-fix-unaccount-mmap_prepare-v1-1-ea070189fdfb@kernel.org
Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2693,10 +2693,12 @@ static unsigned long __mmap_region(struc
 	map.check_ksm_early = can_set_ksm_flags_early(&map);
 
 	error = __mmap_prepare(&map, uf);
-	if (!error && have_mmap_prepare)
-		error = call_mmap_prepare(&map);
 	if (error)
 		goto abort_munmap;
+	if (have_mmap_prepare)
+		error = call_mmap_prepare(&map);
+	if (error)
+		goto unacct_error;
 
 	if (map.check_ksm_early)
 		update_ksm_flags(&map);


