Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4733248F6A;
	Tue, 11 Nov 2025 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824434; cv=none; b=AzbN2ZtEo1V0i7Dneowz82GWNhZZKCDLoXhfYF2Z9t/SQaFWDPEEx9Ka7EXoYQJ9jCH++8tn19BH/IzmGjdjqRxTIhQ8jmUPlXa269BFH7fH4ZQNwdr2l76de0Zl1DouTNYoXCAsVmBlVXaTy+KctDOSYlgIZ2m5MAQ4J8gIYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824434; c=relaxed/simple;
	bh=iNvOSYOODysKgMjmeYsKGzNNEOwiBYpXH5VITYBdD98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dl+pkNE2Yc1PGrA+9WaRp1oKazla/2/NftjFOn9lglmCjO+N2+HLz0+34yVW5GCXrrrtHkMsdhyTEcgbDyVxdeF4J+Jt4msSkRwXCYe9sEq4YrJkAT/8gXyE76lvKFgcqtagYnN2M5vrXt+bk1AOhLfwr9KUMAV0v7e6wEktoLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6KgdSAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6KgdSAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75926C113D0;
	Tue, 11 Nov 2025 01:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824433;
	bh=iNvOSYOODysKgMjmeYsKGzNNEOwiBYpXH5VITYBdD98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6KgdSAqdPKpyxbTd1D5rVGM721ieWaO265JSqQXd6LfIvMi5lQpA39H7dP92nPLR
	 owAe3Sg3zwPjGxz62HpDIRrmSu+y6pM8OgfBdbKJhWip71NwHYT8hqCtBbMz7ZRw83
	 IdZDY3NckAqUfsX2ndfGdQ7BxeefxjESnsK06I9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 494/849] scsi: ufs: host: mediatek: Fix unbalanced IRQ enable issue
Date: Tue, 11 Nov 2025 09:41:04 +0900
Message-ID: <20251111004548.380602646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 91cad911edd1612ed28f5cfb2d4c53a8824951a5 ]

Resolve the issue of unbalanced IRQ enablement by setting the
'is_mcq_intr_enabled' flag after the first successful IRQ enablement.
Ensure proper tracking of the IRQ state and prevent potential mismatches
in IRQ handling.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 188f90e468c41..055b24758ca3d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2111,6 +2111,7 @@ static int ufs_mtk_config_mcq_irq(struct ufs_hba *hba)
 			return ret;
 		}
 	}
+	host->is_mcq_intr_enabled = true;
 
 	return 0;
 }
-- 
2.51.0



