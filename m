Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B96C196D8E;
	Thu,  6 Jun 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682984; cv=none; b=JKrJVVVmJ2QkSTVfOGAqzHwphlb6mckGyw+zHMkTA59nhGS02pg9+sC8TVPtGy5t5HXgUS3Qm04oZTRNaiPjbSkFNKcZ/etLadQl6D2tYZaGQSPAlU1bUP08A/UUrspXxLCs5ujGGPnC7t+JP0aU+78Nu/PZAsMFfJijQYZRNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682984; c=relaxed/simple;
	bh=djh8zsmRmDdsAL+1NnF+SG/NCn7q+ltNZom2ga5bMDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okqoQlbrG0XU1H38UrovhL0o9oYgRVr26kHwpaQ9u3uLzqJWHpq7qa0jOrjZcdwBnasjNfOBqU1EO1x12rwhKUyZhKWD86GzNIUK49BtStRyLNqXYkU7KZDD03MkrZkHKhP94n7axj0c32Xh1uWmgfWRIF+IfTr3QATMnSlUFi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zOMZiEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zOMZiEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B1AC2BD10;
	Thu,  6 Jun 2024 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682983;
	bh=djh8zsmRmDdsAL+1NnF+SG/NCn7q+ltNZom2ga5bMDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zOMZiEg3ihebnKVN7UaO3w5ysbycBOcDcn3PH4RoL81ELY+uMRq5R1FTz3WuIKES
	 oG3e/fnsmOJASPIotPrVThN0GIuAKx1UxSeFuLKJlowFWAbfbYqADb8DkLImUJZlD6
	 OrE4BSVqKlQ9adL2ID6qjb0vB/sXqeuN/PdQxFLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 168/374] um: Add winch to winch_handlers before registering winch IRQ
Date: Thu,  6 Jun 2024 16:02:27 +0200
Message-ID: <20240606131657.523805069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit a0fbbd36c156b9f7b2276871d499c9943dfe5101 ]

Registering a winch IRQ is racy, an interrupt may occur before the winch is
added to the winch_handlers list.

If that happens, register_winch_irq() adds to that list a winch that is
scheduled to be (or has already been) freed, causing a panic later in
winch_cleanup().

Avoid the race by adding the winch to the winch_handlers list before
registering the IRQ, and rolling back if um_request_irq() fails.

Fixes: 42a359e31a0e ("uml: SIGIO support cleanup")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/line.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index ffc5cb92fa367..d82bc3fdb86e7 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -676,24 +676,26 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_port *port,
 		goto cleanup;
 	}
 
-	*winch = ((struct winch) { .list  	= LIST_HEAD_INIT(winch->list),
-				   .fd  	= fd,
+	*winch = ((struct winch) { .fd  	= fd,
 				   .tty_fd 	= tty_fd,
 				   .pid  	= pid,
 				   .port 	= port,
 				   .stack	= stack });
 
+	spin_lock(&winch_handler_lock);
+	list_add(&winch->list, &winch_handlers);
+	spin_unlock(&winch_handler_lock);
+
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
 			   IRQF_SHARED, "winch", winch) < 0) {
 		printk(KERN_ERR "register_winch_irq - failed to register "
 		       "IRQ\n");
+		spin_lock(&winch_handler_lock);
+		list_del(&winch->list);
+		spin_unlock(&winch_handler_lock);
 		goto out_free;
 	}
 
-	spin_lock(&winch_handler_lock);
-	list_add(&winch->list, &winch_handlers);
-	spin_unlock(&winch_handler_lock);
-
 	return;
 
  out_free:
-- 
2.43.0



