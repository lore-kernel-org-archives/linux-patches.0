Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D181B4F11;
	Mon, 14 Oct 2024 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917738; cv=none; b=qfYJXtGZMxWSwvItGYXElJ9P59Bzg6Qt7IenvEFHI0c2Gx8JBtSQa2XCRRcQ9SCVH0pmHWk32h1uTjGXJJfr5lA/jZFwVdtHBt2qM792QgF0M6Pl+704IcdTjpnCoKDtagfTsN8EiTQ4JPffb7GTLaoRKgs+KHTc/Fl4EztlQ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917738; c=relaxed/simple;
	bh=z7p1RMY5g5BBXH0NQVGpFGjBzOBysJ7lJRDzQIHzmB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zld6LpY4MYjRFf5FkfwfhyvrCCGBxX1Yn6GUIaOU8vnciCY9CVN2vtfMhhMaTgidT7qvqsRB8KFbrFqDUauMXKGsEoNav6H9g/X1ZMSlo1Doi+/TpPqNE/6UCXHIWDXleni+ffZbqNxo5qtSvxdzTMfVIF573GjeFBky5GQd90Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJNg+WsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJNg+WsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F3C4CEC3;
	Mon, 14 Oct 2024 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917738;
	bh=z7p1RMY5g5BBXH0NQVGpFGjBzOBysJ7lJRDzQIHzmB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJNg+WsAEEKyEw4ZKsWDk6bobv3L5OIHmDnSX2zLyJVeOLG42CS5UfwnQA9A2Zw9x
	 9JHo36MGPcMW6ikkEP9lw0F3cbZIlIKlPjpP7kN4lrshAe518pRDEiuZdDSf+Qbdld
	 bXPdKESxKc40vUNAY5QZ1lr9QiLIrKdYJS1iqmHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/798] scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()
Date: Mon, 14 Oct 2024 16:11:12 +0200
Message-ID: <20241014141222.557791251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2e4b02fad094976763af08fec2c620f4f8edd9ae ]

The kref_put() function will call nport->release if the refcount drops to
zero.  The nport->release release function is _efc_nport_free() which frees
"nport".  But then we dereference "nport" on the next line which is a use
after free.  Re-order these lines to avoid the use after free.

Fixes: fcd427303eb9 ("scsi: elx: libefc: SLI and FC PORT state machine interfaces")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efc_nport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
index 2e83a667901fe..1a7437f4328e8 100644
--- a/drivers/scsi/elx/libefc/efc_nport.c
+++ b/drivers/scsi/elx/libefc/efc_nport.c
@@ -705,9 +705,9 @@ efc_nport_vport_del(struct efc *efc, struct efc_domain *domain,
 	spin_lock_irqsave(&efc->lock, flags);
 	list_for_each_entry(nport, &domain->nport_list, list_entry) {
 		if (nport->wwpn == wwpn && nport->wwnn == wwnn) {
-			kref_put(&nport->ref, nport->release);
 			/* Shutdown this NPORT */
 			efc_sm_post_event(&nport->sm, EFC_EVT_SHUTDOWN, NULL);
+			kref_put(&nport->ref, nport->release);
 			break;
 		}
 	}
-- 
2.43.0



