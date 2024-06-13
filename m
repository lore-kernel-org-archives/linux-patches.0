Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43A1474B8;
	Thu, 13 Jun 2024 12:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280057; cv=none; b=A9XNNyj4TF2ujE9Vm97t9SklNKkyGOgNO9RdsPHcY6eThNVff3uaj+ezdx0g1LkS4x2q6cpuQWu+yXZCQ5ZlMLcIw8+Ur40t1Uf78rLLO22zk/9XI92HI6MLYp6PkxDWbLEeakj/CtvZsXRIB6Zu+daRedxxWiuuytNQfYBZ4SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280057; c=relaxed/simple;
	bh=JTZ9cUSjDtFBhPDLJpTgRxAhXFuBEdQ9fbhogA9oLEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuK8+ItktsuH52ZViFJQrUYFAPD5KnB/jJS1RB8jevqN+Wf7788g0f0M75JiBTvQNoa+Qm2aVsBhh7mdIdTUNupN0YJewMR8k2KwTWL+xtHXHl2zQiDlpZ5+5swNJetwzzgEv2a1sCzTAHZSaYBW0K2YHeHtnHxVobPlW1jK7nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpvNkeWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpvNkeWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6BAC2BBFC;
	Thu, 13 Jun 2024 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280056;
	bh=JTZ9cUSjDtFBhPDLJpTgRxAhXFuBEdQ9fbhogA9oLEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpvNkeWTi7iqc0BJuJN09WTBjjxs3lxheAZ26NIpYoHF7hUKGuZh0/1ndVk/mza48
	 o9wn9fIa48pjhF9DdJiorczDlqVvoyGnmPDTtAxHa/lXM9369dNL6OQ1P1ZEcCt1Jw
	 XOK6teEXp4odIgjQRs9yynaPu9qNNhr+3s335HzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/202] um: Add winch to winch_handlers before registering winch IRQ
Date: Thu, 13 Jun 2024 13:33:46 +0200
Message-ID: <20240613113232.702137212@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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
index 4f2a4ac8a82bb..d6a78c3548a55 100644
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



