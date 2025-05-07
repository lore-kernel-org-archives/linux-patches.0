Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC222116E9;
	Wed,  7 May 2025 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644113; cv=none; b=ZnhyYNJqK1ih/4bpabQko73ZllkQ69ZBQF1CEBkzu74woI07oyErGsWqkVzOE9VMNaSGqC9ticQpjqvJ/6w0gAXa0icOVd0yjygRdYSno3p6+Mo0MqnYtAY2nSMrv3jph8tv2jx6nXzjjwRKNr32wocS6Nk01Phl87QiqFCUanA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644113; c=relaxed/simple;
	bh=9RZ9t9C9+EjaDLEqSm7xZ6jVVVljjHzsnloH0Y30ju8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+3BmcARyCfHlvhyUhxFbWpbAu9GRjrJhQ5rtgS5Wkfs6YI/NOySVhXNbMAyTsS5MQFYBe8NHyKd1uz/v/2MlPCzctkoJsA9j43I3OjmJKyqYnf2XAyub7pkoVj/0MmcRER2Fj2poaww9ibPRG4v+AgcBBeNB5zzWPHUwWSL9N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEpXLb6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEpXLb6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF59C4CEE2;
	Wed,  7 May 2025 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644112;
	bh=9RZ9t9C9+EjaDLEqSm7xZ6jVVVljjHzsnloH0Y30ju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEpXLb6uZJ/To88/ySRVRDqJYTEtn7UMTKwQambFw2fzlteiufjgp0A+P0OS+e0ql
	 RFSyGBtXqiBnSN4rVn2SNoBr0KaCxJ/DhvOntYZfsczi+eqaEVn0mvVzvTN5GnOM8h
	 AbHigiOVx7uQy5ZsyiSSy9yORPiMoG29Hx7IPKYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 124/183] bnxt_en: call pci_alloc_irq_vectors() after bnxt_reserve_rings()
Date: Wed,  7 May 2025 20:39:29 +0200
Message-ID: <20250507183829.843428945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 1ae04e489dd757e1e61999362f33e7c554c3b9e3 ]

On some architectures (e.g. ARM), calling pci_alloc_irq_vectors()
will immediately cause the MSIX table to be written.  This will not
work if we haven't called bnxt_reserve_rings() to properly map
the MSIX table to the MSIX vectors reserved by FW.

Fix the FW error recovery path to delay the bnxt_init_int_mode() ->
pci_alloc_irq_vectors() call by removing it from bnxt_hwrm_if_change().
bnxt_request_irq() later in the code path will call it and by then the
MSIX table is properly mapped.

Fixes: 4343838ca5eb ("bnxt_en: Replace deprecated PCI MSIX APIs")
Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 174bb33432d13..a414d7d721b20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12172,13 +12172,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
 				return rc;
 			}
+			/* IRQ will be initialized later in bnxt_request_irq()*/
 			bnxt_clear_int_mode(bp);
-			rc = bnxt_init_int_mode(bp);
-			if (rc) {
-				clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
-				netdev_err(bp->dev, "init int mode failed\n");
-				return rc;
-			}
 		}
 		rc = bnxt_cancel_reservations(bp, fw_reset);
 	}
-- 
2.39.5



