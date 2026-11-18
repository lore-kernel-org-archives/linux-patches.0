Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023465;
	b=xZJ4QrESWjWWAMdXZTnVSAvFi/R0UpA5dZLXnSWoeYsP010s3qDee57z+yisIMK6MDcR
	 3ez753M8HXUREn070NRf2grh2GbszLMX/JxY2pL7vOnewIHogcc4k+tIFqDSGgUoIKSKe
	 hIuWWch4YflxlfBW3aHKjp1M1pE9qabotQ/q0zmyIVKvoeNczRWFlzMZmgmDBuaZZFyfU
	 sTiRqsptX7vginAxO60Ie6apq1Du7RIciCsW/nRSneYo2yBnccxPM0QoC7el5sYF+aSG6
	 unK3g/kDvR4FNF8DshyPtuHKCBwexF3CxdYd3W9dim7PGz/yx2YlZLVOI5nrHkJGKrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ENB93WajVG6PWUx9ZX5ngMPA6uprOoKB08TltHAff4=;
	b=Hdj5eYs26CaaC23ZmHfrM4T+/iH/wndPEmeLWyFtyMMWQh7BZGkLRDCvmMpYAcdlqdJl
	 dQSnHM9rm8oA3Na0/3Z9i+yqjdDA3X9WJcipY8xcRTx2MWOtGrEXyFshufc0k/EelHEO2
	 KGrLWjTRp7PmyEyMbJqxyoM71TvBokgM4MlKrZkPaeAt0k05KM4GNSDST2jjnzj6fE24c
	 yc9dCp06SZJQTZNXjVMRjrRbuRerGfRfZ11IRJ10HxHqYXvQo2o53AO9tX2ZH9v1gucLQ
	 yVR8l7yuyfSGKZhZGkxHkoaSyrpzgcCzClvwqMP1s8PnmKCCA3Nf7ljJcicTfkKZ6Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cY0CbsaY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D053A60A2600;
	Wed, 18 Nov 2026 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cY0CbsaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C401F000C4;
	Wed, 18 Nov 2026 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023465;
	bh=7ENB93WajVG6PWUx9ZX5ngMPA6uprOoKB08TltHAff4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cY0CbsaYQAuvUjmGJHaq8AcDzSc1TaepvUqRkug7rtVP0PNdENdkPXhvSgci4KDbO
	 WzInK0COOGTVVk5iVo6f7XalYgHYU1Okg7HM50hojsRR5or6ZjRalnoLwgXMXXkpzA
	 EOF5b5G2NSG5nTn8fd1VVuvaWN/Cok4CI2eYR8DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0342/2151] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:34:37 +0100
Message-ID: <20261118150134.563008987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cb105c8fdbb18..d0f9eb45750df 100644
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



