Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C004142911;
	Thu, 13 Jun 2024 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278938; cv=none; b=Jxj1w9dzYHmUY7ZWOVN7XKhCk/JWQpRKu5Jy/gmH2ZfUzUTQOmjxL3DK720an7J0ECw+l8lTh/nnf/maX9BLBLIEuYOxvWYtV2anuIHRCBwsVjJdjW0nB7ArkuDBCnZJZiCtyvpUcQCsRULCTValR1S1TUkth1Icd+h9ufTAy7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278938; c=relaxed/simple;
	bh=G4PSJpONSoOPb0uUAPI9m2gkC+3DgjCBcl21cNQhrRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv9dPvsOxrP6ettOJu3E4uMrmFcKE7L0/3cQOn9j0Zg1WwCi4CQV7jBqDAq+1Y3wLNASiOxRjZdMWgY1CKbDClaLJ0fOuLjk4hMZbe4JfElW5XQVSFPuOdWq0MReKVSKxJe0m95cu3mv22AELVrCbmcOY3tixE+hR/zLE1hp1uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pT4v5Tkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT4v5Tkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9892AC2BBFC;
	Thu, 13 Jun 2024 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278938;
	bh=G4PSJpONSoOPb0uUAPI9m2gkC+3DgjCBcl21cNQhrRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT4v5TkxFj6p25nA8ZdfATG/fosKBUu/0AJBaXxv5o+orFNzAS58MHJPxwqD6kSWB
	 OMy5cpFlwt8Hry1hQ3a10/mmEyuehgpEkhbXKycq8spaBcOrQs24SwPeurzAVkQfI4
	 daVEs8Sapn0DYF6GXw0c8binMh2e5QU/TZiMfJ0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/213] um: Add winch to winch_handlers before registering winch IRQ
Date: Thu, 13 Jun 2024 13:32:41 +0200
Message-ID: <20240613113232.359932250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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
index 7e524efed5848..71e26488dfde2 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -683,24 +683,26 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_port *port,
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



