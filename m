Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C177F1B2188;
	Tue, 15 Oct 2024 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998260; cv=none; b=MgMTT/ZNUEhBdd2cshlRrTZYYliNyzSR0H83/N9vG5dryUZ6vUXVJGve0Cwf12pM8SEYeUCzJvK03XMqZ5V2CjitNQLgvdWRiKHr8udILFxQfbRwXOC8xXxvNnuKLFgEkg1dRAdLakkZdvqALyBsZcEz1J0V25jwA3wqNOeYCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998260; c=relaxed/simple;
	bh=TY+7pv9FHz5UxNaMRs1Qxe+WLJmP0AEAD8WZAuAgZrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkY5Of9LN0mI9W93xMV1BMe+fj5WR/mdy7n1xe+bOTEBM/YWrjUlrKrLpqf2JJz4PCwc14xJ5aqZephxkZWvbEBY8yVlwfkonkbgjqRSsD5OGDizJBkCxazjpEtp7VbnvdBsv5Vfwb0f9ki+JgyLvpck+v61zcjBhz+cbu6nuLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcNn8bxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcNn8bxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF69C4CEC6;
	Tue, 15 Oct 2024 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998260;
	bh=TY+7pv9FHz5UxNaMRs1Qxe+WLJmP0AEAD8WZAuAgZrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcNn8bxWIvxW7JdZEU2J4mq3KtOL7ga+ZvuqofbkONllN+MFS7evcdh+fjfbhhOZa
	 i4lAMCDcWsxFxNNxanx2CTa1ii3UtrrSmGbBizkyP8unxodbHXDZe/K6kYUD7sIn3D
	 aMCKGMq/2quV8I0hq3dpCbRjBfmHUK83BjayFNcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/518] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Tue, 15 Oct 2024 14:45:29 +0200
Message-ID: <20241015123933.396990402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e91d6aac9855c..1ea2c1f311261 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1496,7 +1496,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



