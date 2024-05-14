Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B8413AD2F;
	Tue, 14 May 2024 11:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686312; cv=none; b=fSoapSOjrSgGnjA/VTpCFb/hsnIZKTq1cUKxmo2ZNjhj2wLKK2ZmucZwFd/sU+OHWlfsdJo8vO+9w4KLazMu+k8lmt1Wrgng/eQGsoSjrURBihd32TKX5xfaOitxeaHNoaxU/DRRwfV06HsDIRl/9NmxmLtxTjhWHsRe1pY99eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686312; c=relaxed/simple;
	bh=1OaHsLc7ozS7HZzK8w93htpPpmsXGtYzsYzTo3H/UPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4QVRb9JkHeDhXDcUws+qUXl+yLD2jjnN9H8xlxIdDU4cN/TqItTZN2EWUBwxcO9WHribz8xtmGCdOXq3I4UIbHzlfPk6lF9k75pTcsd10Q6+99h77rifmQ83penaiKm74Te2f3WisnguQjphpMBkeAsyxrCSunXru9BzDDYu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy3ETeOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy3ETeOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BDFC4AF0A;
	Tue, 14 May 2024 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686312;
	bh=1OaHsLc7ozS7HZzK8w93htpPpmsXGtYzsYzTo3H/UPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy3ETeOAnaNH5zWKP1+j5B1ad1PcVyqhE4nB9JLQKB2t7c+BFuDPcRn9Sq86yR0mH
	 Mfa1NTwl/jsRxLryvZo3Ux/Cmq11XNtDoQMLFbD9qpjqRxY+3v5qSZDo9fBuPyiKuY
	 /hKniEDdBYCIKzfpF1TDTmGnAXhYh12uRWoytlvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/236] scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()
Date: Tue, 14 May 2024 12:17:37 +0200
Message-ID: <20240514101023.978907299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 152245f7cacc7..7e9e0d969256a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2621,9 +2621,9 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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



