Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054905;
	b=jk+kaGTc9XgHfctoqEi1Jdw1JQcBynAcazfNuCwZu/86BQCncSD+qm9emWbLh9KU7Mqk
	 DTOvCMFTV5Dcl5n1IBLofE4i4cx0y8J+bQYp7agYFluBLiGJlAWRaVIa848gDbKXZcKei
	 XEkLOwH0buzsaXZOFISKIj0Zki672YA6S9sllBWNCS76PSMo89zArg8oHQ+kMnWQ29YES
	 sUG178KTUZFh1inWZN5z1uj7zcD71TENVFjPXGRF8E3kHikllG3ldvF6H9yVpiYyhwOBY
	 1kk0JxmIOqTgW4u90Ey3MbCRjRyddM72XCutYpKqsn5oQcWlR3b/9by9rrbJx6WYTyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E50hegVyVY0qXnOpHbQzyaHyg9nkUE5kIw451BhpS/U=;
	b=I+Ecaspmc+lo73NdGZ6NRUJRKRaQVJqPiiLyC8lAoMarRmSDOb5+vhjkxak4MyAg3UBt
	 C1myuXtdYmMdeNMt8LH01SGrnoTYVpjS4pQRJvPNdOtu+wPt8kfNioysYq7Uu1+nzHtYf
	 b9TnHce0ASOzQlgKlx0oO6C6heBFZr7F+dtcaCSKNW7zxUcEpL1GXvsiyBJt8nfaWyRGK
	 IhNg47hCR3cf/6lWlgxfKVSPpxIWui6SDbGlkoe2XIlotgfZKgTX1EjY9NW5g1yt7orWM
	 KAKgBccZ6OviX//HtIzej15oZrPSapGUTPU55E/YLB9Ga/LsvnB5vjOtx4FNW25jSMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw5Kjy4f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92EA606A325;
	Thu, 19 Nov 2026 02:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw5Kjy4f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0531F000C5;
	Thu, 19 Nov 2026 02:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054904;
	bh=E50hegVyVY0qXnOpHbQzyaHyg9nkUE5kIw451BhpS/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw5Kjy4fwlJp4V7u6Eccn5dOJYEK5rPY/U3uITdQ56m3+RfRR7HbHEvMt0+qYWJXh
	 +SlSTLtPL2gx9dV5AoCFFLi6PGRsSfKTA+FLi1vQdDF/fm7idlbJGqkNg3jpcyrWx8
	 /wGHTXDGXId7FdRhnTR5i5LGFX3/k0bADIKLRZuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1441/2214] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:51:57 +0100
Message-ID: <20261118150108.784491437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5a3ddd3b2b83..669f943b4f02f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -211,10 +211,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
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



