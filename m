Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBD93D0D1;
	Tue, 14 May 2024 11:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687670; cv=none; b=Q0sdskbM6LH9KWdHkHFhje/qDYAm7JD6YNbUlUYVM3C9Qm+MtXY8T3wKuj4/oxwz2Ju3vKBbMECD47P99AYBaZAy3xPVtwHADbOyNUMEEK5MCvyH9LL4Tq87oWmckdxeBBNXY5eQrvcBoKIxQ1cpaB99hsk/D2B8NbN7sVLWnsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687670; c=relaxed/simple;
	bh=OXZp7gphLIsxa10iCGPlH0b688joRudC1aTw8oexigE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJbPHnAKXkilkh3arJ1WyzIZgqLltGA3FtuBYNiseyz3UrmvMv6XBa+WRiya866BMlH6wibYkJN4nzFAVupdZQ4zuxO+V4SuMAkG/et01GvRh8WRwkq1REkyo3U1lZmrk5KUabiDqgZYwdB8XFtgCwXtastysLue7Wn243LVEm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFue4NoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFue4NoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C7DC2BD10;
	Tue, 14 May 2024 11:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687670;
	bh=OXZp7gphLIsxa10iCGPlH0b688joRudC1aTw8oexigE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFue4NoJVPnbvlkgk4W8PT35FQB8mFK/xC9pFjqI11VZ6HJKAQv0Pemnhb7U+1K1Y
	 lrxUXZOdoXrd9JNyqMuQ/x0i7YMyKch62ICMrA0PwVECTkiKnNas8nPEFqpoxiOYxb
	 pOqHPYUBDsujesfrWSnnhpsp2RwVmdyd+d0gh0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/168] scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()
Date: Tue, 14 May 2024 12:19:22 +0200
Message-ID: <20240514101009.114885778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit d11272be497e48a8e8f980470eb6b70e92eed0ce ]

The ndlp object update in lpfc_nvme_unregister_port() should be protected
by the ndlp lock rather than hbalock.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 4e0c0b273e5fe..2ff8ace6f78f2 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2539,9 +2539,9 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		/* No concern about the role change on the nvme remoteport.
 		 * The transport will update it.
 		 */
-		spin_lock_irq(&vport->phba->hbalock);
+		spin_lock_irq(&ndlp->lock);
 		ndlp->fc4_xpt_flags |= NVME_XPT_UNREG_WAIT;
-		spin_unlock_irq(&vport->phba->hbalock);
+		spin_unlock_irq(&ndlp->lock);
 
 		/* Don't let the host nvme transport keep sending keep-alives
 		 * on this remoteport. Vport is unloading, no recovery. The
-- 
2.43.0



