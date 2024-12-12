Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDB1223C41;
	Thu, 12 Dec 2024 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025631; cv=none; b=rlwt8dXAuAg69OuwamClcWbLUi9KRMesdLxaLai4VO8n7usvJzvVTpGn5ZrYmjKqhxl3bOAqNepprDnC4Acpztjso3Oi5reA0c8jJBzaEoPoFf/pG7S9wOHoOXRmWmX4JlPyZk5k7eduV+aSDCS8upde2hsOV2BuMm/8i7e190Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025631; c=relaxed/simple;
	bh=/Zm0tJyXRW555mobqwIqe+ap9qTx076FvNDyR6BprCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbsY3h3UAZiIToc50kUk7sCbQ9MboX5zxwkq8krUGY6yqJpY/Sc2/g0rCPl5phN0faT+82VPO5N5mMdgl4+S9HoatohmfwYDE/l4JIM7C7eIvOFM89R0eso0MOBCjpgyeNDjd1zV2GBZRaWlFqFaeEKPC++bhiCNtwoaNr7a6Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0gRjWOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0gRjWOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46599C4CECE;
	Thu, 12 Dec 2024 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025631;
	bh=/Zm0tJyXRW555mobqwIqe+ap9qTx076FvNDyR6BprCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0gRjWOOiDSVoDRJCPViHPPiH8T4nx3kQbw+hjDn9lSD6aGfbp0ZtWQrKccajCoq9
	 4aUE8TnmR9XYFBHNvFLiL1qcjJnxRC4LtMWwPPFt4W4JKknugM8hdOu+twVh6B/01W
	 9C3sup8iiQsX3ss0AliPPcxAu5sn9e0gUeiiGv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.4 234/321] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 16:02:32 +0100
Message-ID: <20241212144239.215505650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 0566f83d206c7a864abcd741fe39d6e0ae5eef29 ]

The pci_register_driver() can fail and when this happened, the dca_notifier
needs to be unregistered, otherwise the dca_notifier can be called when
igb fails to install, resulting to invalid memory access.

Fixes: bbd98fe48a43 ("igb: Fix DCA errors and do not use context index for 82576")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 1e9967657248a..84de6bbace090 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -674,6 +674,10 @@ static int __init igb_init_module(void)
 	dca_register_notify(&dca_notifier);
 #endif
 	ret = pci_register_driver(&igb_driver);
+#ifdef CONFIG_IGB_DCA
+	if (ret)
+		dca_unregister_notify(&dca_notifier);
+#endif
 	return ret;
 }
 
-- 
2.43.0



