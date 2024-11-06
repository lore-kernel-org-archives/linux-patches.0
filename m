Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA871DED5F;
	Wed,  6 Nov 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895442; cv=none; b=vGN5VsqKGdbhj/hp9bMmUNoIG6dCiFVvFG4QJGybfYugxQMyGaGlMfRLTKm728Jyr08N/YGLYAs+O0eIP59DK9RdpQqPwjQR4QXmMSIXruFDuhtGpB7q3Trln5fJ9Y35eTEA789PBASEhVGC2zuFKpD+x+6ielN7TcCp0SkkFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895442; c=relaxed/simple;
	bh=OJWJThqya4GhS53vWJ+TDdJLYMjK0/CNLcFhnSs+GNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqCZCZY2MpyVxQo2ioFXogJF9AqI+dYfWO9TYAYqvejtEFwUPdDLHzdP3adQZB/ymyYfdjdvYm8sQM7NulqEbCLMoxVXbI43+QRRDwTvLwaxu7wpA4+3W++w7zmy5EDigjAokLn6fAl9kKHDlsOCoY1vGG+DtQZjMMoMfAHFt+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX+1Ufjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX+1Ufjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83ADC4CECD;
	Wed,  6 Nov 2024 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895442;
	bh=OJWJThqya4GhS53vWJ+TDdJLYMjK0/CNLcFhnSs+GNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX+1Ufjs0WGbFhzTRx699Wu1kiym59e71bzhOHq5Tq143RsetiWPph/y2bQyRlvmf
	 heMF6wvx5o/byDJKQR1/PRXsBlNPUr98YtmQpjXzfW6gouB5ntlKGEa7xPIXXvIhbC
	 RfigNg+WVoOEnNR8IVt4fFuJbFispUqGpJ2AizWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 220/350] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Wed,  6 Nov 2024 13:02:28 +0100
Message-ID: <20241106120326.433920602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3361da45e1db7..3ca91daddc9f5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1198,7 +1198,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



