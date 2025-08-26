Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33976267386;
	Tue, 26 Aug 2025 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208272; cv=none; b=ukhmMXH38dgJF7LD6oW+Lie0aDf2FZ/+fy7c2xxXP8HQtYkrFgrxrrhRoKtWjU4XyPyEZC50FnLLT/ryN9zw+zkLvsxenqwInKIR2S7tbWmN7q4zcwz19XdBjTM9FWnURfstaosNJP1WnyqpLkqG2aDwzfr8xSr7YTyTt4B6J5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208272; c=relaxed/simple;
	bh=iHb8W5X+qlpMbJ39YeJTBxM7lS41xNLsM8GrH5+cbUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMF6zVGM+YW3tc25RvapUz+L4D09Oko7AZswmxPMnDBQ0fGcICNvyeugoJ9rWLnzM2hKL/b5DFcNHc3HPzJk4zgDrIxE12lqQGECJqUugdQBED3hxZigUExbKmFVV6/DahjYyp8zFHsGxgFLIgAB0KmJgWBLpTuizN2rDF51QbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIimbmZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIimbmZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAC8C4CEF1;
	Tue, 26 Aug 2025 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208272;
	bh=iHb8W5X+qlpMbJ39YeJTBxM7lS41xNLsM8GrH5+cbUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIimbmZlDRYBe4CaFCUNUYODPpMT3/EvQkw5UBfTzhaSBUXq7k5QKUTW1tHCYatnH
	 uEPbzLdfxmsXL8zBAAU86KqTUmIrkZ5TotEZdW/sAwZun7ehVjUGx8uUk8cjcWlvIZ
	 VNLf4RrQMqAClv3wxpTu1Q8FltYXXyA0VeLwlvzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 048/322] scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE
Date: Tue, 26 Aug 2025 13:07:43 +0200
Message-ID: <20250826110916.582117027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 01aad16c2257ab8ff33b152b972c9f2e1af47912 upstream.

On Google gs101, the number of UTP transfer request slots (nutrs) is 32,
and in this case the driver ends up programming the UTRL_NEXUS_TYPE
incorrectly as 0.

This is because the left hand side of the shift is 1, which is of type
int, i.e. 31 bits wide. Shifting by more than that width results in
undefined behaviour.

Fix this by switching to the BIT() macro, which applies correct type
casting as required. This ensures the correct value is written to
UTRL_NEXUS_TYPE (0xffffffff on gs101), and it also fixes a UBSAN shift
warning:

    UBSAN: shift-out-of-bounds in drivers/ufs/host/ufs-exynos.c:1113:21
    shift exponent 32 is too large for 32-bit type 'int'

For consistency, apply the same change to the nutmrs / UTMRL_NEXUS_TYPE
write.

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-exynos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1078,8 +1078,8 @@ static int exynos_ufs_post_link(struct u
 	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
 
 	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
-	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
-	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
 	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)


