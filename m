Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D85B2FFDEA;
	Tue, 17 Mar 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767485; cv=none; b=kEn+bGPLQ2m2hCZ63QJuEpdPg0BSPYy+lBY7czji9F5xXiW4S78mSKqxt7DHHTbWf5WXhusLDv08KjFQi196F/s3byqua/H8mEVrL1FL+XQ+KQdV6gThKSJSWGZp8CO9QHAniI0a7HRSwks3sJqRHC/7jPnZqFnNf92Rl+GNZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767485; c=relaxed/simple;
	bh=jWqFCQxtn5lk3vGf81iQD4ZOkad1rPu1MvltSNxYfM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmY+U+p7gf+Knb5HhVq1XBjzVPqCY5Nd1ctBGIcw40x9zPd+lgZjHJKLv5as4zj/xEzgHjIofHSFA2nSlhFOlKstPVtNt0k5dqtTatTu9QeHkOA18vALrX4+CHwE6lvhEVOplDEK0oMJJIV/FAqhpkZ5zkVc9yB/TMiKMZ2kupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY+0zZ4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY+0zZ4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4B3C4CEF7;
	Tue, 17 Mar 2026 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767485;
	bh=jWqFCQxtn5lk3vGf81iQD4ZOkad1rPu1MvltSNxYfM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NY+0zZ4RkDSAo6cYTu9Cksbp/K85jjFGzePW6gznUBoTb+qV2DmouowPqKEZ7Pcxv
	 mvJ+F8PR+VzaZLi/8imPdapHUAs8FWHx5+9hS7zB5jNPrdajUazm5s6IbkX69mRw4w
	 /2R8xnc2KK5Xm4vSg8V4/aIjOJtnPftZGH93quEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/333] net/mana: Null service_wq on setup error to prevent double destroy
Date: Tue, 17 Mar 2026 17:32:05 +0100
Message-ID: <20260317163002.930258873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit 87c2302813abc55c46485711a678e3c312b00666 ]

In mana_gd_setup() error path, set gc->service_wq to NULL after
destroy_workqueue() to match the cleanup in mana_gd_cleanup().
This prevents a use-after-free if the workqueue pointer is checked
after a failed setup.

Fixes: f975a0955276 ("net: mana: Fix double destroy_workqueue on service rescan PCI path")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260309172443.688392-1-kotaranov@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e22a98a9c9856..962fdd29d6063 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1854,6 +1854,7 @@ static int mana_gd_setup(struct pci_dev *pdev)
 	mana_gd_remove_irqs(pdev);
 free_workqueue:
 	destroy_workqueue(gc->service_wq);
+	gc->service_wq = NULL;
 	dev_err(&pdev->dev, "%s failed (error %d)\n", __func__, err);
 	return err;
 }
-- 
2.51.0



