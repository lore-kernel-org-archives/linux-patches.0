Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC3A2210CA;
	Thu, 12 Dec 2024 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020714; cv=none; b=qUBEGOU/ecgoBzIkvQ77LCKlfFr+mNaCnNGoNP+mbWndt1iu7G79A75hOeYRcqFmhzaRfT7X6t+928A2m3RTo1wl8/O3OMP91Ku7Kcl7dhEnef7cjG9c4wfeSPH8vaugJFKKnB0Nk1MLlaMwnodF8x8I8EaAre+z8K49pNs37j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020714; c=relaxed/simple;
	bh=dmIxerM0iiNWUDWnlK6wA9mwh6wGLOztmvJhSZ3Z4VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euSnHsyja1YnIBpJGhbktGAJ/5m6hAP6QJKu3UF+bLAUHabo4CoMfWojP/98bEZwQRxRCMenQJ3UD40tj/n6wslP5SZ+aR+V2fO73O7aymdvWqSAE8h1MlLGXGHS1NsGW+AwB75lAbw4jMlxiehrQXfRU2lyzYWL8r2V3PPZepg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eC6LXFop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eC6LXFop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94325C4CECE;
	Thu, 12 Dec 2024 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020714;
	bh=dmIxerM0iiNWUDWnlK6wA9mwh6wGLOztmvJhSZ3Z4VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eC6LXFopzkT9B7r8MJjrT1xb+g6XBewf06QPj4L1dNBa6nzkpPaGsjCAMOAdcCSWl
	 Cz9Kl3385JT3DFNIdPFmrJcNmetDdP4TNE2g0DC8f8o/T9VUps9JtbUvEDoteEq8go
	 jF31wE3ADhNLSpwjmKlr+eIc8viqZ4ifzb3KQ7vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 540/772] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 15:58:05 +0100
Message-ID: <20241212144412.283077519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e2caf559d00a..d53076210f3aa 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -665,6 +665,10 @@ static int __init igb_init_module(void)
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



