Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CF11AD3F6;
	Mon, 14 Oct 2024 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919520; cv=none; b=MR/Sx0wY0NJvtM6RVUY4bq9N3kQE3B3rgb4LnB2d//Mf9N0tbdakZm312/Gk9OfAWf4GrIlt1Xiq5w9y2WbiwvcgKMrIh8tPacSq7ek6njZ5CSNTn6uDlvJC/Z2Bu/lcHSEGAiqpUPsNvx8NECXsjyUD5m3MEAtaSQoe7Grc3IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919520; c=relaxed/simple;
	bh=RSUZy5ktQcUw/AyNKiLs2eXy4B5oUkXSISe/g0XaoXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0X+jgsiMy3fpiFp8JYgwflrWfytHDPVnZ3IPh+9y/MP+APkVgTxaMrJFHkDiUnyBlnBHzeBd8857PCOzQMA11JcKhnSiluF2pSbONBNQh9mGcBLlonPN1vT+oHuG47+uVbdBQYDyfyS6JQebWvI9ucPH+N+xjhgMJFZWgwP+aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfDIGLOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfDIGLOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B451FC4CECF;
	Mon, 14 Oct 2024 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919520;
	bh=RSUZy5ktQcUw/AyNKiLs2eXy4B5oUkXSISe/g0XaoXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfDIGLOYUaTNcY8nfoygFiY+sUUQ/Fvti/s5kCSMoLbij3rgQmUMPV7LAIMnqBNLE
	 38EMtpV93h7S+ZtgMWoP70LIwxd/AhALzytT6HsAjTeGXPfLMmqAMN+N+TWLCcoPym
	 f1cIOPn/1rdLV5sc4Y18CAxHHnbCKN8YY329DfBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 628/798] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Mon, 14 Oct 2024 16:19:42 +0200
Message-ID: <20241014141242.710973038@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a5989d46c930..9ee25351cecac 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1494,7 +1494,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



