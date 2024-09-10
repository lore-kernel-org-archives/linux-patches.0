Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF82192D97;
	Tue, 10 Sep 2024 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963822; cv=none; b=QzTXiCjvTqJri9XjrrDEjSTo1wRjTM+RH6B58YuvMOTVDwWkwH4JPV6M9Dc6oeuuC0D90k0TsU1/9/OwXbfzhACm3ZbUoyKlON1DsheC+E95MBFd7XdP3reuSE17A7G6JAdtVtZ6rXxt37s2LLtymSVDgLWjW06oorgwGkQ7bYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963822; c=relaxed/simple;
	bh=uAUr/oj1dyGEY8k0HFL/Kp3lRtbUsOzYFW3U0kp2/6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJyCXBjyWG63bV8jc1jpLITCPqCDuKX3UWblZD/RsIxRpgpJ89BTiIaQu+i0e9guSfwNDXSqz7NM4glFtABTqvkXNw+BG45a09Si1jbxwEwMp3TO/M87g4zMD3EVtlLp/Lu1/zUAvz34n49iKz2W8sxwpeLhskSNplfoQ5vx7f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppXKzHcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppXKzHcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C16C4CEC3;
	Tue, 10 Sep 2024 10:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963822;
	bh=uAUr/oj1dyGEY8k0HFL/Kp3lRtbUsOzYFW3U0kp2/6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppXKzHcRM4tMdG80Q0kx9DleEomOgKDsTskTVPperzJFX0jXKpRkQBnWgfqgzWILE
	 r7pKoJ7rOGTzMmlLFe1SynrH1NAixQZscmMzppEhnQhgwqA/veco0avffk1SZqxC4G
	 nGSG8LVgtlIPZXkNb49+4UT3cbIWoXEhqGCvX2os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5.15 189/214] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:33:31 +0200
Message-ID: <20240910092606.358679695@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit e240b0fde52f33670d1336697c22d90a4fe33c84 upstream.

To prevent unitialized members, use kzalloc to allocate
the xol area.

Fixes: b059a453b1cf1 ("x86/vdso: Add mremap hook to vm_special_mapping")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20240903102313.3402529-1-svens@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1484,7 +1484,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1494,7 +1494,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


