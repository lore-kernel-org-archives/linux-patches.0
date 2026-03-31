Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF6B315D50;
	Tue, 31 Mar 2026 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976931; cv=none; b=mG9Ho6Za5w9HT4YGbQBjnAUK2WQU0By/NqrD0cKvB5VukA6M0vZLidPktZ3X8a1CzGjGyV/cqgX9eWSIa90eYroDgNhEilaZNRzMpansudyZ0RIyA+eMTHvGoVQre2fEZngW+HYDXSwF+veaPwfqqXdOnu4o6A6DP998rbioqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976931; c=relaxed/simple;
	bh=+7XuOqYPSJcBoAXcSiPuSx/tgXR+W6UWUlx4W60VVZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEDHxUcjwnO6VzOC5xIBKFXVsyamEbCmW0O3QFOWfAkbiGlEsOJoRvSp7pXkTisrtS2UgsJ9HQ8pPY+cfHJSZ9jGNmebHM8qLqgbb2RYec61kk82KzDMrTGI5rg5gTQNHYfW5xvNqEj26HADa/lheaPRF7PZFQDlxT+ybTGOPmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syKL6mbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syKL6mbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3633DC2BCB1;
	Tue, 31 Mar 2026 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976931;
	bh=+7XuOqYPSJcBoAXcSiPuSx/tgXR+W6UWUlx4W60VVZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syKL6mbIw20o3rPdielF0Zu0nqH92J4v7GHR5YluYpJS3Fm74xRox52j1WtV/ijlW
	 K7jyt/pXIsEHnQk8aqcqpq0qohZPnv7s9OhbfNhxwh15Z37WSQpy71vDdRxeD2ImGN
	 ez5ZCDGzcFSgjrvffRh9ZtqO3VwnPMy+kuFHgtZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/309] dmaengine: idxd: Fix possible invalid memory access after FLR
Date: Tue, 31 Mar 2026 18:23:07 +0200
Message-ID: <20260331161804.023121298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit d6077df7b75d26e4edf98983836c05d00ebabd8d ]

In the case that the first Function Level Reset (FLR) concludes
correctly, but in the second FLR the scratch area for the saved
configuration cannot be allocated, it's possible for a invalid memory
access to happen.

Always set the deallocated scratch area to NULL after FLR completes.

Fixes: 98d187a98903 ("dmaengine: idxd: Enable Function Level Reset (FLR) for halt")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-3-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 449424242631d..f2b37c63a964c 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1137,6 +1137,7 @@ static void idxd_reset_done(struct pci_dev *pdev)
 	}
 out:
 	kfree(idxd->idxd_saved);
+	idxd->idxd_saved = NULL;
 }
 
 static const struct pci_error_handlers idxd_error_handler = {
-- 
2.53.0



