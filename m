Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2CE1D4154;
	Tue, 15 Oct 2024 12:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993950; cv=none; b=DPfRgOEPsad9FKi4kxplA4H13wV9wjqLYFXh0Xzs/nWIieSY98nhhgRpPS94CKNepnxzwg/UJjA7tQwLUM2gP3yFqnGm6uOn1l3VOVNgPkDN9C5+FdKUqmhyeZD7L/3y9j23Mvc356AykI6wwfsyEvDdUUAZekUjqK7p/sCh8zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993950; c=relaxed/simple;
	bh=uuVn28vzPTHFOln+pbM764Wgsuw/96wiiRDpB93xSdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK91Xx8owKVPqFpDNHQLEioumFHTTyVHdfD7qdGu6jUvJ58+422l9TYTO2UgPtramDLc5e8QGOWeoy2AVRCdd2iVbzqUUq+bLclQ5DySuKcuuX5pz8okwmOUQoYz/tKeobfoS/wp8WORXP7DOwjYNCXK4tNwZEkASzG0U13bZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huAMknHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huAMknHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C94C4CECE;
	Tue, 15 Oct 2024 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993949;
	bh=uuVn28vzPTHFOln+pbM764Wgsuw/96wiiRDpB93xSdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huAMknHti3p4bFRLi5dP407H6TvZZbXqlI9riTubneD5lCzNDigDst+lf13/c8I0r
	 Ed5zER+OjNOgonAtF0DzSpxUcOCkBn5kJi+Wr/t+0DfuQHru0KD8gmfA+HGhPARLgU
	 tqJf+JjcscNYbfTi4BMkMGLmcsi2ULk/zZ7dnzpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/691] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Tue, 15 Oct 2024 13:28:31 +0200
Message-ID: <20241015112502.689570116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oleg Nesterov <oleg@redhat.com>

commit 34820304cc2cd1804ee1f8f3504ec77813d29c8e upstream.

xol_add_vma() maps the uninitialized page allocated by __create_xol_area()
into userspace. On some architectures (x86) this memory is readable even
without VM_READ, VM_EXEC results in the same pgprot_t as VM_EXEC|VM_READ,
although this doesn't really matter, debugger can read this memory anyway.

Link: https://lore.kernel.org/all/20240929162047.GA12611@redhat.com/

Reported-by: Will Deacon <will@kernel.org>
Fixes: d4b3b6384f98 ("uprobes/core: Allocate XOL slots for uprobes use")
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index aa9134cd5d00c..b37a6bde8a915 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1495,7 +1495,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



