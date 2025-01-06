Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A41DB92A;
	Mon,  6 Jan 2025 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178552; cv=none; b=fc4cU0IkAvSCDT685jFkuzU5YrC88Xf6xbtb9Lxs8UhbtxicHZ+rd8qde7VFnkx4nmJnSpA7zXHzvDAV2QXEwSwExdV+2VSFi39KxLkj0ZmoB90H3zfT6G6WBMwFzyFsarP26JkBLGhd3rbsuyNj+w/DSzZejJWpLykslhOkXao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178552; c=relaxed/simple;
	bh=XChnWrM18rg83wFGNbe/6GPuktgxMx4azPd3ZjbI9SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB4Y6CXuTcpJtktpy+TTQRoDKrBEMN+0TV1vtW/LSagcKtFjk1JeIGCPkSU/Bn6seBDjJzDum8sZ18x+oEdE2rVQWZyi+VlLE6RZcNSQ3JKNxoX5+dV6WVXTqw+Kd4b1e7BlZ70xtDf7SbPuooV4wPF2wo5QJf2mXYTO73uEGY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IadHdPe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IadHdPe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E04DC4CED2;
	Mon,  6 Jan 2025 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178552;
	bh=XChnWrM18rg83wFGNbe/6GPuktgxMx4azPd3ZjbI9SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IadHdPe3NI+aI9Wqo70cM1yh7oSuTZ1YJ/eW07Kx6P0r7xfWPJjBMEb6rix4MkhuA
	 fihFW9+egHJu/Ak6t2yxaNf7nADxuieifUpuvzO6yW8BzZc/Sitjzq910lRLF4v8un
	 FmTsMLYdnnVTOcAjUDmBNYrzSSvrXCpjcVWvMxhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/168] ionic: Fix netdev notifier unregister on failure
Date: Mon,  6 Jan 2025 16:15:26 +0100
Message-ID: <20250106151139.151182569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 9590d32e090ea2751e131ae5273859ca22f5ac14 ]

If register_netdev() fails, then the driver leaks the netdev notifier.
Fix this by calling ionic_lif_unregister() on register_netdev()
failure. This will also call ionic_lif_unregister_phc() if it has
already been registered.

Fixes: 30b87ab4c0b3 ("ionic: remove lif list concept")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 910d8973a4b0..cdc3c55fab6a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3514,8 +3514,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 	/* only register LIF0 for now */
 	err = register_netdev(lif->netdev);
 	if (err) {
-		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
-		ionic_lif_unregister_phc(lif);
+		dev_err(lif->ionic->dev, "Cannot register net device: %d, aborting\n", err);
+		ionic_lif_unregister(lif);
 		return err;
 	}
 
-- 
2.39.5



