Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662AA19048F;
	Tue, 10 Sep 2024 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963145; cv=none; b=sItXF1R74YtWaObwUaqSoLq+ocB6pXY4ouQpfkKUjG3b5UpUlfz9fFGDjFLNJyAS32++5wrZ3iCX2grZ0K4EauNPDEpIy7d8emsMkbEPPpmsCut/kyv11W+C3+apXyqwHaZzw0mK9mmDZbmP0BaYq31I9wcqIEDYMeWmDDaKhkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963145; c=relaxed/simple;
	bh=7k8gh0ndoholfzVqhTivi+4ZrrOLZraqJUDwuCWVnoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCiIt2moFiRLAUhQkqB1lhf+fxkgcI2PPTd0CKi9R2OeeZS2h1BydAQNz01TfcTsqOgdZExYxUOxIHLOvLEZAtkOI64xBcEPrrDTz76rAwQlm79bpY3QTJ2Fei0C4D0lEEeeyne7NBGzOzmiQh7I/fuOMDG8ER9gt/SZDaXr+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwWUo/17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwWUo/17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91059C4CECE;
	Tue, 10 Sep 2024 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963145;
	bh=7k8gh0ndoholfzVqhTivi+4ZrrOLZraqJUDwuCWVnoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwWUo/17WcTxMWChmb6lUKVRhIBNRi38J11jLMqMg56D6cZ805zL56VJDA9gZbyOi
	 CO1l5F6bVLPzMNZGGE4/Stg2uOd+kgzSeDlr576sovLMWiaZ7DRpt4JkzbugM25x8+
	 RJ0Wk8fLsV6DT9RpzZMzOXD+5jThVKXsjzeSgJ2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.1 151/192] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:32:55 +0200
Message-ID: <20240910092604.171895796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
@@ -1483,7 +1483,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1493,7 +1493,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


