Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D21D1E66;
	Wed,  2 Oct 2024 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877782; cv=none; b=TW81D2z7M+XzvI4RDlZMNePWOOrgl9tCeu3hpsyXHEUMUqSvZD1HQhKcPk/1Pl/Bt17QcIsXsHNEcU4PTXU/zsAlLweAwTT0qeKZxixrQjJ7nxlOPYboT5Q1OwWpC+LRiSwHYShvRsGXi+T4LuKKnqu4IVbm2N2BLzEfF/Ya2uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877782; c=relaxed/simple;
	bh=EEwXYWXMWpjmbRkaVsEmwC2gTCR5N/x4WTP+2ANGVfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbG0jX7i4ARG46e8cM1j/KJ5gY7RIVojNx/UPHc9Ni0WQbmhoNI++63EmRNOR8pAbr9qAyLBSXOCh4YL6dJ2Wa7Vpwjq3KBPP1vRKXN6w/A/vnTp2XknnwDkUBzUT4fhpzM1fr+Sa/qwl8g3XPQfriAWj2mNVc3SsudkNXIhGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No2TwwGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No2TwwGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D5C4CECD;
	Wed,  2 Oct 2024 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877782;
	bh=EEwXYWXMWpjmbRkaVsEmwC2gTCR5N/x4WTP+2ANGVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No2TwwGaYZk2wldLBvwmE6Ug6b3RLdwhsujviDcmSdWU1/F0uoM7PYlGhEvk+9Bc3
	 4ZtDCArBRRIRoWsiH6tB1t+R6nBQQYmQFgqK1JrrzkF6L7So/zKJaGFEYzrZOm53w/
	 uNAX/t1SC4K46Lnpgeb86+Uc1N24tC/Qwlfa6/pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 192/634] scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()
Date: Wed,  2 Oct 2024 14:54:52 +0200
Message-ID: <20241002125818.683518863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



