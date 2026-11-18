Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039541;
	b=r712FH75J4Vkwuw0hiVfY2+6VQV1zQTKB9xMK81ZUWbhwyWe4yziRXIsJfV1UvZQ4vGa
	 SdoP1FliTFUrU4WalcAQr62Far7ed4OGxAqUsveQD7F6IQF/8LphdagPtaaibRqM2AKIT
	 7owGzmOeZvdGHzQS4UXGgHT+1HAgVXswSBl323Yg+2qXndVg74MZEFjD0EoGrCbXFmfdP
	 TUwEhZaB4/gXjaPd1ZouTO5Tx1dgVYwqt3rBVg6QmiRIn6cYV+oVag97yFq0WPBWyqLkX
	 9G2rJLSXxjbApGeaQqlEag8cGlyKfbt1dbO6eB833cUV7Mk//4tL9qA3zrha0aFBT+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oouwHh5SkIPYkDU/TcDlr4VyMCDBEKB7HoZ0m8MQjLM=;
	b=oC8O2En1xSnNK6C0dVQ3nqug7k98PmPGHmeHYpk98dT6a3z81zU7NbsfjdVP/Ik8UE55
	 5UJ7A5NDc2xUIWLhGa1KMjeXYDCczvx3ju8NZvWCp3zDm2yg46XJDl6ssBk9luDx+fjc/
	 EzoobJ+Y5M2WHDxqu7u7lho3WSJ31bLfpQU9GDkoNc2tBKhRlOPrfMlj8oxRsWgNJaBeZ
	 85jXmb+0bI7UNmisQL4p6s22dwEzS1LZBGtPtCs3ReH8GMeQu/1yKdS7vVc/MRCp498Sv
	 edlI3seI5F2nTtsmEzCL9fNjx8ajPlELT+kg9MAzGLTgNCsL/8ZF6bZBTp2oMewHN6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrAnuRvF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30151606A31C;
	Wed, 18 Nov 2026 22:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BrAnuRvF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB31F000C4;
	Wed, 18 Nov 2026 22:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039541;
	bh=oouwHh5SkIPYkDU/TcDlr4VyMCDBEKB7HoZ0m8MQjLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrAnuRvFzkNA1qvkpQGaC7o8AUyF93XW3dI5XM9anvbTdeLiq0LvPydYRPWNkH5/b
	 /bVFR+mpCEHV5sHdv/6Bmbgpbb25ZLpdY8uSR+GQbhaaGYo8OYPAYSoSptBAP83Gxi
	 gVpbM5bLzvVPLmnNjifD6rnCKfKi8YEvdeftddXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2135/3318] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:45:57 +0100
Message-ID: <20261118150426.115929922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit c94c746e6c80439a4a9a0e1e20f2dae62a4d57ef ]

The enqueue path reads the workqueue pointer before taking the event lock,
while the remove path clears that pointer and destroys the workqueue while
holding it. The enqueue can therefore reach queue_work() after the
workqueue is gone.

Move the check inside the lock.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-17-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 48dd77a91aa1d..b38f68ac20c49 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 {
 	unsigned long flags;
 
-	if (!mrioc->fwevt_worker_thread)
-		return;
-
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		return;
+	}
 	/* get fwevt reference count while adding it to fwevt_list */
 	mpi3mr_fwevt_get(fwevt);
 	INIT_LIST_HEAD(&fwevt->list);
-- 
2.53.0



