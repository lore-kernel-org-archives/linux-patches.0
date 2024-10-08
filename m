Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6B1DC759;
	Tue,  8 Oct 2024 12:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390971; cv=none; b=iM4E0uhZW5folIptk7QBSVAX1S4tHpBTXWlbwE3LCIAjmMQif+zLxFil9OSNTqqlMXRDYOVB8GveQcD+IS0wHnWJLqjsUebDLMfwG0RlB0OROBxL1pLCAB1FHRkVztH3gluUbI27Wyt6TajlOIcJHAZHYMwiexdgYJUwuACenP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390971; c=relaxed/simple;
	bh=B+/oFjOOv0SKlN+B6Um7S7QwiXFqZH1hYK3cZetM9Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6izSRv0xyuSvaZr1HQKYNu9xkv9+BBQgGgo9QJadB58/LrLWJp5HAb3vvjQ1sXF+8Y63deHo7Q55mV7TZ/WyyiwRbnxcPGGf1PdkAp8Pr1x9qaziYH2rTI2ofm/1Q2lv6hvVIs7wNOluay4qrQaTOEOxLu5HdGGei8gpitnReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlzOVyta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlzOVyta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E0C4CEC7;
	Tue,  8 Oct 2024 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390971;
	bh=B+/oFjOOv0SKlN+B6Um7S7QwiXFqZH1hYK3cZetM9Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlzOVytaMmR3u1kmHV03jXu18IgTkP06oago4M/l9Cl+pvl/vxBSDd3gm9pEa/0Qd
	 Sn34R3LbBMH2nomCBjGenuXXh6CIDCmbjiCSBcPsr1epE/6/SaJgwaIZBlJg6XIlw7
	 6cGWC43tMPzK3zrV6p1HrW75IOIEUFj7p5jU/HIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 450/482] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Tue,  8 Oct 2024 14:08:33 +0200
Message-ID: <20241008115706.228317559@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28c678c8daef3..3dd1f14643648 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1491,7 +1491,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



