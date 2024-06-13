Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16E620ED;
	Thu, 13 Jun 2024 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282383; cv=none; b=QyUMxovKzULXDAIhr5MEMAywAE7XQ9hk7b6YmTWAvWmBsep3YFDgS9F+l5uZ12IVfI0OO7Sf9EBTYwCLXI99TyPwMMfaF04w6AILNmchgkiGraXFmwJNGGz5uqhXRB9wg9AnxzRoNKALeldqZ5eungHujCi0/whyzo1YLkIdyVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282383; c=relaxed/simple;
	bh=TLyrtGJtkxFJ7OGhkviSRP+u8rTV9zAaOlkFQSIWMec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMJIo1aRglLGSgg+vb/vLOWlCdsKRrDpw/dQj8XCMAIobKek9LsUXZ1iH6KRATRg08jcQufA/os8rF3IiUBexSewMsNy++h5gq9G+6ZUTyPhpHZHle5R/8CxTRIUpY0bxU686UM68mwoVQxfhFSSzaaarGwlY/kxokr/N1+GjP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9+PxzoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9+PxzoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46155C2BBFC;
	Thu, 13 Jun 2024 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282383;
	bh=TLyrtGJtkxFJ7OGhkviSRP+u8rTV9zAaOlkFQSIWMec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9+PxzoDYOH9ffV1BjTmGzJxK63AmdzOTktIt3Sr+ucdLV4G1agRCPbEcniAkgyaO
	 0hZ95S9aAQuS8k60Ab5X6umxSoKEyAl17wK290wG9xwcp20TpaxgZPGAjaUxPUxl0t
	 s6c3SaseGUk2pEqZNlWMjUOUZW0LVqfrG8DAfNQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/402] um: Add winch to winch_handlers before registering winch IRQ
Date: Thu, 13 Jun 2024 13:33:36 +0200
Message-ID: <20240613113312.249390921@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 02b0befd67632..95ad6b190d1d1 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -673,24 +673,26 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_port *port,
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



