Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D44188921;
	Tue, 10 Sep 2024 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962140; cv=none; b=dAYJ7Qp8nQJ1iTGbwI5JpmUDV/FKGSH+l6yQbkyYgBmMZKdFwryEya9opTxrlBAWK1GQbwRC1K8kmMdw0wabXzMuXfcFwNR9Z/MbqH1MjWfqaOdCH3nejKNHy+1KbfhbDeKIFjjq3614pSphoBfapr8eNhqwRe/PljC+erIlEwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962140; c=relaxed/simple;
	bh=i11TATC7Vhf/amBO+GNCm5LeIhAro8VxzA7fPy2isxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6oZrZIWz0HE5N4+EOkOa/VyB21e594NsgXxe+wOxh4aAiDOKg7fnLMfcWk5Ow0LdWnR6cJ+BrMZFECES7WQSVJ5NCbSydQP0Fa2g1BMjLJWjbm3MQLNyWg9K6NVdEzQeZW03C8UVcgSvwpKPycuDVcJk/bUGqW7oFUP3S8St2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/pX2I58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/pX2I58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92164C4CEC3;
	Tue, 10 Sep 2024 09:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962140;
	bh=i11TATC7Vhf/amBO+GNCm5LeIhAro8VxzA7fPy2isxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/pX2I58ojVui7GsPinR+r9/cl9PLKZSNc3V6DiX41QpPmPOYBsDcvpUE+DWQ60Iw
	 6dG8RsSjviRmTE5S0Rrv7QeROdDfwZXbAmWHXoETEocl5rATEaPie1N8e8Jps84Ybl
	 zWbYCk+T6itcww4FusEk2Jqu06AFovLEPfCfJJc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.10 308/375] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:31:45 +0200
Message-ID: <20240910092632.911004165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
@@ -1480,7 +1480,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1490,7 +1490,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


