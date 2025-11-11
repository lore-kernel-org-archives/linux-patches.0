Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA52534AB13;
	Tue, 11 Nov 2025 01:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823782; cv=none; b=Ez2piUxETqnffFBfQgDMka0WqEeTbfeDK/KR8uxlveq8ueXwd1BzN9QLTWGW9FDLFMUQQKu4GUW+oum1+29F2QQ1uZ4Xpe+5PEBtzst4IQtMAmn/ivdikVk0nG2r16X7sKLNfM88XnfPx4D0eRBiVAh1sHOp+LmJ8J9LTDfuMdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823782; c=relaxed/simple;
	bh=2HIbG3zJlE1mEKeWcwwR8jyTfh45LfAo8GjCW5qGRI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXvihRTV6MlZHM5xdQGIbKhSM6aEvNNNWObxpqG+M8+wnh84L/2H54goKuwFyDvXc5ilqFMtbOs6KZpKFSGDLZ5AGqeh+8bMUkAiWNdcw7oAUSCX+I1atCiAo02mXLopAmY4H0oBQaTzA+mC/HKW7AytmPHkmbi9pEXXVIE6sdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07ge5BU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07ge5BU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B7CC4CEFB;
	Tue, 11 Nov 2025 01:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823781;
	bh=2HIbG3zJlE1mEKeWcwwR8jyTfh45LfAo8GjCW5qGRI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07ge5BU5zvYZDBuMmEhFEw9fjr+eDrKpZGYBe4L8k5/aCrh4EyMgMCiQ0qydeXmwF
	 Netj721rO6x276x4ynQ+J0AmNWW2T0r9yN/+ibTbiYh+PqFEj0twfT3YdepKnze03y
	 VJcUiEkoH8SwUoHeOfHeZRAkfYwjAqRv++8Bv7Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/565] scsi: ufs: host: mediatek: Fix unbalanced IRQ enable issue
Date: Tue, 11 Nov 2025 09:42:59 +0900
Message-ID: <20251111004534.151799567@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d7664f5b72a5..5cb3af17aec47 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1846,6 +1846,7 @@ static int ufs_mtk_config_mcq_irq(struct ufs_hba *hba)
 			return ret;
 		}
 	}
+	host->is_mcq_intr_enabled = true;
 
 	return 0;
 }
-- 
2.51.0



