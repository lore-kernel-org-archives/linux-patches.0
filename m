Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F22341AA1;
	Tue, 26 Aug 2025 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218286; cv=none; b=f5XGqab+QFBraRJZJIuTEM3AwZEe4MWb408m8izGre9MUUdkpR0eH3CwTChn/UdVHt7lgJXZuVKI24G4N1cBFiBSLnETdvhcdYwe1rKHAuY0WXTnAD+MIT+kZmsH3vboNta5v9bPQod//5YtYuWVH9/0pVxG/233cu4+txbd6d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218286; c=relaxed/simple;
	bh=ygYvH+ixK7d5pHIMs1JwqpPlt/5uqHdfzZ3a3P9kxWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPbaoqss/lSehUtf5kGVdunK+gilcPB/hNf4hsbIG1plrOLM2TDBQTTssQ640eOFpML1At8wUY0CeCDO+FlX+7yAetwrLkOvV8yE/yEUW7z96Fk8iJJJ1bMBUrr85hRdkPhhEcLyFuQQfRiARhHskiBU3YD4x5Fsrmtx+OS57cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gES7wj5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gES7wj5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34507C4CEF1;
	Tue, 26 Aug 2025 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218286;
	bh=ygYvH+ixK7d5pHIMs1JwqpPlt/5uqHdfzZ3a3P9kxWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gES7wj5DuTfn+TFxkIs598BiNmyuNZGWmRCcWVHRqrFeZ89B6PPlAJWG4TFw6PZ98
	 aKKHWkLZsGJ2/s8j8kdYwEckBTCG2byGOodIlXVXKv3bdsnRXmhRvEU4qDxmyz8sSd
	 286WHnd4e6e66VhecOHyAuXRkj7a7zCcIrfiNhvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 464/523] scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE
Date: Tue, 26 Aug 2025 13:11:14 +0200
Message-ID: <20250826110935.890760758@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 01aad16c2257ab8ff33b152b972c9f2e1af47912 ]

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
[ Adjusted path from drivers/ufs/host to drivers/scsi/ufs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-exynos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -850,8 +850,8 @@ static int exynos_ufs_post_link(struct u
 	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
 	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
 	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
-	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
-	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
+	hci_writel(ufs, BIT(hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
 	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)


