Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706EA1F428D;
	Wed,  6 Nov 2024 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898582; cv=none; b=rb9xnm7xYVJfHgaTdr4849MEnH585OW90RD3xivXGo+/XlA+OgJ9BhrT4aoCL58vMwx6vfDfdRRMKIiUZt+tkpDktjoK/qW5d6/dLDdnO/kol8GudOOKNOB9QBKEWqde0tzrVVdW/bqJq3QTjxkQWlFjxlsOvFLYjwlDu16Txw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898582; c=relaxed/simple;
	bh=HLiBmV89hXGC1vFZL3ZP2NW51M4avfjVbkVDxV4IL/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axz+/ZWUWs091IvmfsQQYpOf4/8oHTQHGlU2wmOpBGJ/Tyfu+jFtvxbGKFb13TX4M5xYZ0ASFutqxAmKiCm8j9e1UZghLU68eZd67YVJ+o7W3CKBcX9E68AO4RKf/6vQofgm/A7jwtaAIbDgM3v8Zpde6xPtGWH6mPdjWwx6kGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHz8kHLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHz8kHLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A9AC4CECD;
	Wed,  6 Nov 2024 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898582;
	bh=HLiBmV89hXGC1vFZL3ZP2NW51M4avfjVbkVDxV4IL/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHz8kHLmR1wWroiPCCBLKBvQarUVswXxQsiw1SIATLB61WilMWv6Mfojzoj8snqUF
	 FchMkAHUn0w+fupt5f2UGtT2tWmZdC/7seyZG2GB0rHzo9vNXouRvE9cm4FRsrkREv
	 V70IebvAMHaEhRuvZ/Lzp/kibcdUIjXiAappEkkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 286/462] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Wed,  6 Nov 2024 13:02:59 +0100
Message-ID: <20241106120338.589145385@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c812575f04619..6285674412f25 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1502,7 +1502,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



