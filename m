Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048182;
	b=FK8ZFEsPmacEsBl2VMHp+2NpkZ++p4P4lDgw9smz55QBbrLRc9Lpi23nbnrN51I7MUTc
	 eOUbPKrFNqCdVQltw+gOeWE+6g8MMwEYngjDgmBsAXF9qOT5LKaR/xMcTVdYbJknrO+Yd
	 owS+tmbeSf7PNVsIYbhT+ht2vJH016SJi1junSr13y/Vmmb1cEdE0rRzNUHswt1q+lo8i
	 IGBaqdBAF3SZkO45AicbUGl/pQFx24pxhHm/FrIJHo/EfpzM5FcRIlLxR2D6KUkxmgpzz
	 t8g2sSEMAsRSPwvZjuuEYy3BhANsCPZA4+HZ9QZmCJs4xGPWpUVGIY1CVliGoNl6tbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gukJ7ygCLF0F1Axv00z1+dzZ8FUP8vmVm7m+PNvw7Pw=;
	b=Td7R3dgTEGRep/u44vQ8JNKNpLF1OsL/ls7C8d0qWoAj+QYwcRoFzphA3IKvMRuU8c0z
	 EqWZHcYGbfsv4rJ0QpSbzxbnvhk4+y6FQvlqJ3q0ecNCFbqN3cmzPkCA21ZOmFRB4/CAd
	 X4nX9ilrxItwVoAeXXZ8wemw02UJrmAQ7O/wHZHXV9p095d8LT3yalj6B3MvR7U9fl2ww
	 fhPkAr5QlAjOqB3+wnb22O6uN3k60ct6N9YpORFFirPbVt0IY6nds8TCGKco3JRJNcrHB
	 hhuTZKIBVuJhe+PnkcF+eWGJ7hWlb1WIR6B8RWPWP7S2Ic/SruKL75z8YvYAnNlk7Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rwGFVvW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31D606A31C;
	Thu, 19 Nov 2026 00:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rwGFVvW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ABA1F000C4;
	Thu, 19 Nov 2026 00:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048182;
	bh=gukJ7ygCLF0F1Axv00z1+dzZ8FUP8vmVm7m+PNvw7Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rwGFVvWongiqqCf8n2L2+Zlo4NN5eXB2W/SZlWC+9QmxlDqOQijpJAjLD5wMrrn4
	 3lYGyisTORps8M7P6pUL3fxgRXo98u9KWvOf0TnL7Cz5UZx84EnCweY3EKw/sng4a3
	 h9RR6nnFABjAzmtiXeUi+IZoFRtfU0Aofnv86QeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1864/2857] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118150308.348473090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a5360e29e106c..679c5518c5835 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -226,10 +226,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
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



