Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953984499B0;
	Thu, 30 Jul 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427423; cv=none; b=s0AythIiIu4GaJfLJSXvgurJuEJDfthoDT68ozlut9HM9dC8SD8d8GfIhxCSVgC3Gq1b0y+vpKKtM02dg0H5+wFB3mC88txlYz17G/rPDClbP8mAZziez9GuG2vwhQku6LKEIAhAZjqGUmh/dF6QBdY60DI1nlhkuoQsX9BRe/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427423; c=relaxed/simple;
	bh=XMhQcPR5KarEWQFVVxbh/HLAzXTxetV74AWZkgbQ2mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlpLUaLQcUGa/gymFCU5Q3XM/uGyCapCTSbtJp40mqhK9Z2+Hhlj0AoSGkrFoV1cS/jtzG/b0NDK4sYxYbWpOLwkoiYcBEwPGB789ojAuqnXH947eBzyVWpK21c8PBAm9TUb4S9Gv3Z2fXFuV9PhFlkNNW4c701R4ourvvSMB+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoovQ+eX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoovQ+eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B3E1F00A3E;
	Thu, 30 Jul 2026 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427422;
	bh=+L14pEAtxNhZ6MYHJOtrkpKVnTXP+YwkRmD4XcYjod4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoovQ+eXpu0y1rG7MKN/4JB/07MoWglSCro4opDvxPNODVzRkrD3HbF4tPXjkJHzP
	 lhsRns1YE/J0j9jHpqUgyzcGz4+w9fLVzBW+gX9wWZBNnI6suyD0+aGVpWWDZoycCc
	 87JhkeQBV/WYjAzHQK4+wWWxDyawiu7aWpEsK3zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sashiko-bot@kernel.org
Subject: [PATCH 6.6 164/484] pds_core: fix auxiliary device add/del races
Date: Thu, 30 Jul 2026 16:11:01 +0200
Message-ID: <20260730141427.031297705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit bfa33cd513c7ceb93c5a4c30e5662acd73c0a916 ]

Two paths add or delete the same slot (pf->vfs[vf_id].padev): a VF's
pdsc_reset_done() and the PF's devlink enable_vnet/disable_vnet handler.
They serialize on config_lock, but neither guards the slot under it
correctly.

add() registers and stores a new auxiliary device without first checking
the slot, so a second add of an already-populated slot leaks the first
device. del() makes that check outside config_lock, so two concurrent
dels can both pass it; the first clears the slot, and the second
dereferences a NULL pointer.

Check and update the slot under config_lock in both paths.

Fixes: b699bdc720c0 ("pds_core: specify auxiliary_device to be created")
Reported-by: sashiko-bot@kernel.org # Running on a local machine
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260714210745.1785625-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 889a18962270aa..7d7c87fe9e8f27 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -177,17 +177,21 @@ void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf,
 {
 	struct pds_auxiliary_dev *padev;
 
-	if (!*pd_ptr)
-		return;
-
 	mutex_lock(&pf->config_lock);
 
+	/* A concurrent del may have already torn this device down and
+	 * cleared it.
+	 */
 	padev = *pd_ptr;
+	if (!padev)
+		goto out_unlock;
+
 	pds_client_unregister(pf, padev->client_id);
 	auxiliary_device_delete(&padev->aux_dev);
 	auxiliary_device_uninit(&padev->aux_dev);
 	*pd_ptr = NULL;
 
+out_unlock:
 	mutex_unlock(&pf->config_lock);
 }
 
@@ -210,6 +214,13 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf,
 
 	mutex_lock(&pf->config_lock);
 
+	/* Nothing to do if the aux device is already present.  This also
+	 * guards against a second add overwriting *pd_ptr and leaking the
+	 * first, symmetric with the check in pdsc_auxbus_dev_del().
+	 */
+	if (*pd_ptr)
+		goto out_unlock;
+
 	mask = BIT_ULL(PDSC_S_FW_DEAD) |
 	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
 	if (cf->state & mask) {
-- 
2.53.0



