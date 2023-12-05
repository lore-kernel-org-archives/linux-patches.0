Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC86AC2;
	Tue,  5 Dec 2023 03:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0g5nc5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45266C433C8;
	Tue,  5 Dec 2023 03:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746431;
	bh=fpHF8jxcQGZUG9t//osuCngrsbiOkYc007i+R2fc0qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0g5nc5bGJN5mataqphm+DC/qYh/auAEoVwKVbyBtNJv6EXC3tA1Dmeu2rwrLRpXX
	 kZso8kvAplrZCAotuBAM30/gA6E98Cm9JJVIbVbDkDWVAJwOBhp0RXnL+N0aS36wGD
	 vD9OV0Rfc84VEpuiOPp38LWV/pxvfhD3Q2HmtP4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 021/134] net: libwx: fix memory leak on msix entry
Date: Tue,  5 Dec 2023 12:14:53 +0900
Message-ID: <20231205031536.694759135@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 91fdb30ddfdb651509914d3ed0a0302712540fed upstream.

Since pci_free_irq_vectors() set pdev->msix_enabled as 0 in the
calling of pci_msix_shutdown(), wx->msix_entries is never freed.
Reordering the lines to fix the memory leak.

Cc: stable@vger.kernel.org
Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20231128095928.1083292-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1965,11 +1965,11 @@ void wx_reset_interrupt_capability(struc
 	if (!pdev->msi_enabled && !pdev->msix_enabled)
 		return;
 
-	pci_free_irq_vectors(wx->pdev);
 	if (pdev->msix_enabled) {
 		kfree(wx->msix_entries);
 		wx->msix_entries = NULL;
 	}
+	pci_free_irq_vectors(wx->pdev);
 }
 EXPORT_SYMBOL(wx_reset_interrupt_capability);
 


