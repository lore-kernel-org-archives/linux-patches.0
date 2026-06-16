Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B709A3BFE5A;
	Tue, 16 Jun 2026 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634180; cv=none; b=j7HCItM6dmSTXC77azUrDBetFUk6p/2OxSPcKChCBmbLbmOOnkw89gk2XBkwMlbXLQxkdoQfLkcBCFh6pnu80pnnpCTPR5I6S0newSnj2Gr4fVGcrQTWiWNbYIi81x5Q3DHUXHEuv5PCZ3zuOZ0IEBFOw1g+8TzNTOXfahuWM5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634180; c=relaxed/simple;
	bh=B8X0RYN0zkwEH8DaJ5KPBXqZPIKXoMc6c3Hye/NgSsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdhTOT4RyDXhn1siWx39fGYwDRHN7PGIV225PWtwvzs/+u9XY9SlezoMmpOPvv9gQ3XFxGm8zc9AO+1HZwf2W1AXX6mcYJrNPXvH9LS9Qwb5tXqUWRamUWDHz2fTcXrpZR/zX4Pz4Z5LyoQtIeZ3+5ea9vKs077ae40L4cPOI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwGHjSou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwGHjSou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37B41F000E9;
	Tue, 16 Jun 2026 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634179;
	bh=9KE3xr4d5/hcbPE5ebiZwvFAbNq/02uyvrqOnRQAnbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwGHjSouzBrjKCOwG78OCEAdlJ7iojAu+V4oyvhgzWXJBbx0kyV6Ai0mECDucFmtx
	 BbXUGT8GlgjhnDfJ2elVVsL7LY8/va0HteDl+H2Q1whPKCfmi9v0ZuvzAHGpxNNFhx
	 3dmuGLYuTcPxEcS9yggwJjsXAPE1F3kq1pTNL/hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 217/411] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:27:35 +0530
Message-ID: <20260616145112.315965493@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Meyer <kyle.meyer@hpe.com>

commit d930276f2cddd0b7294cac7a8fe7b877f6d9e08d upstream.

PCIe errors detected by a Root Port or Downstream Port cause error
recovery services to run on all subordinate devices regardless of
administrative state.

The .error_detected() callback, bnxt_io_error_detected(), disables
and synchronizes IRQs via bnxt_disable_int_sync(), which calls
bnxt_cp_num_to_irq_num() to map completion rings to IRQs using
bp->bnapi.

Since bp->bnapi is allocated on NIC open and freed on NIC close, PCIe
error recovery on a closed NIC can dereference a NULL pointer.

Check if bp->bnapi is NULL before disabling and synchronizing IRQs.

Fixes: e5811b8c09df ("bnxt_en: Add IRQ remapping logic.")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/aiNM1CY2-StPilxW@hpe.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4552,7 +4552,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


