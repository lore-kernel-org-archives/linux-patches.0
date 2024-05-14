Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950722EF3;
	Tue, 14 May 2024 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682699; cv=none; b=T/0qKVxdpPV/VEZCfqVYOXzulZqpNrUWYCXMTwG8WLki5RVhxRvZXk0qM0wXf+5geTJVoyXVKK27spblBQbg5hGz9nR3wjNAuTJzTXfRAAzhO6Hn9z2k/an25JHDKeIIBdq6LWSM22G1eaFQpbhmjsSHyOsvFvWug4Ka1XJhjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682699; c=relaxed/simple;
	bh=i4GQL7vkrCAwrOzf1OlvTl/UWLklX/5TQPgpH1uO5Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRAZDzITe0ElbFGzcddOdqn262vU+yKSHNMoikpZGulzumnGdHFUD1hwG5QPbAJ1hOfpl1LCO2GGrfmUd7j+gZGbv+HKIZ7LnerMiDNGhNyi9F17svTutYfmXUTNEDMZ2nUZ8mWuno7MuRpzOmQW/XGqxrp+N5Yy4Q5DKhZuONI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nfg/cevx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nfg/cevx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6C8C2BD10;
	Tue, 14 May 2024 10:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682698;
	bh=i4GQL7vkrCAwrOzf1OlvTl/UWLklX/5TQPgpH1uO5Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nfg/cevxyxZTrJQ79024ZiNGgala6YucIqQZ/C2OVMIXlyXhDvHCKjxPlO22qND0e
	 K3f+T11D2g1sFzFHH312S+406BD1EQr3m1h6hXcR8HRNXMn3s/vblA6XjyQZJ4/phG
	 4bjAmu7C4PaQZcRCbyAABazZN/laZX3i2gk7xurU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 100/336] scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()
Date: Tue, 14 May 2024 12:15:04 +0200
Message-ID: <20240514101042.382511972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 128fc1bab5865..47218cf4d110d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2616,9 +2616,9 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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



