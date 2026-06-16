Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C366546AEE8;
	Tue, 16 Jun 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625899; cv=none; b=L84Nrks1sneFui/LrcAjwWVh6dbX3adK63KZV5nATYhHM6slB3t8Vkw51u/MoZ65gUOf1nFovDk1LDI4OaGP3+/4YLyyGY5MwvV9IEDLXZtIlX6XsWZ0BmDKhPO83WRJMfFSOjuDz4PYGYzXZMMEl4oDrA8JNN07N/AKpUMdrL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625899; c=relaxed/simple;
	bh=fhPTOnkufZOuzyhqiZy0GQXzts6G7BYk7jpA6jcm9tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9E85HwITnhf3UVe8YuSW8u06FRZ19DTYaxcpi2M4aAbB4FLLZs3p1AkKaETJ8zX2fKLgOfm2mMUz3w6+EWffMpo88cqP+XE/M7rx/IgIUM4xwXFMjfU4GYa+QseXktdNtpGD+FRK+bTQHh+HsCWOxhG03Fo3BqRgICChQugXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTkJxzX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTkJxzX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69711F000E9;
	Tue, 16 Jun 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625898;
	bh=uT2S7aurb8XCnybllwlZIT3SZ4Nv65KCZnUyfjPfo3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTkJxzX8YUzDfTGz5feS1G1uB5+23ubCI8muXO9QSsIx68gMtHfwojMnW0nFexhAa
	 eYiQeDOuTPXSuDm1Zgkz8U+sMVUHEzoouDMxaqOPCGLi7uso5DVLkui1HKYJzn5Umg
	 7rcFnl9qsFpl0Vq6T4dB3QLH222bWuGYB0T6Icc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 211/325] bnxt_en: Fix NULL pointer dereference
Date: Tue, 16 Jun 2026 20:30:07 +0530
Message-ID: <20260616145108.605354298@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5629,7 +5629,7 @@ static void bnxt_disable_int_sync(struct
 {
 	int i;
 
-	if (!bp->irq_tbl)
+	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
 	atomic_inc(&bp->intr_sem);


