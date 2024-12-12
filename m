Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7821660B;
	Thu, 12 Dec 2024 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024569; cv=none; b=PJp4M8exNnHriNZSlV/5jBOeEnMN5jC5VIZTmFinkbk+5eax2jm4pmDizw+eX8iExX6fR2rJUTj2Kt38nxOEszEeyz00kt+I4Kdz20cmbPyOUo80/lOvF6YOjQIH/QKIzEr+sV3qIjHAT/mJPRX7X0B0CYBKsCRs8sOo/iB5joE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024569; c=relaxed/simple;
	bh=341aEGF+F8lH+/C8i8/DKbhrOwuqmzCS532CuikGd2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbVgnsoF/0FUvv4FYXLuAg4EVPTOiOZDowBNu6NKgsWasympI7nZR2v2gFAH3UK4+jP0ehbcrx1vOi40uUtSVyVnD0gPe1mFaKEpq3HBvSvgnOeGcVOQDZZx8ZSiSS/AHyA5TtSk2MLEnt5yz7hE8gj71XaGbvvM3k85tfvMzpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrnsIth+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrnsIth+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6FDC4CED0;
	Thu, 12 Dec 2024 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024568;
	bh=341aEGF+F8lH+/C8i8/DKbhrOwuqmzCS532CuikGd2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrnsIth+ZDZ9Ri3dka4zPJV5KuQefnwWq8IW4ygQBm223F3pRlwBzwHl0YpY3VArB
	 A74kAuViQ1pflF7VyWPgTFFNHKX5LAigiHlW4XysvU+6W/r1ZNDkl71RTGnpt67aV5
	 NOt+4FDUHJFWaP554eWojfiy607sitpmcdAfx4lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.10 339/459] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 16:01:17 +0100
Message-ID: <20241212144307.053988148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 17cdda3fe415a..7b89dadd41baf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -666,6 +666,10 @@ static int __init igb_init_module(void)
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



