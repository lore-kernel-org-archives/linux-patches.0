Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE7F2EAE5;
	Thu, 12 Dec 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015783; cv=none; b=GNTD/YK3sLy83KuX7wU5R+LfgxzkvwLG0pholJvFbZfbSd8qjc0xIf7G0ocNZn+5h30sorW/pz+xZ1iCfP6GZ8ydpQtuSZxBOezO/lQoZ51fW+6GSRbcDWd/qjxvGCldeyabgqThZ0iCriJTLicG8jcxpV39leOrGR3GGcEiafQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015783; c=relaxed/simple;
	bh=FPEvEihsUPIm8uMIsObuWEntfsO1Byvzt82Vz8BNh54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3h/oIdJ3aJA/LxYe7f1cvBAs5tdMxnZLe2f5btkCBv3vHSFI+upNGMkgM3W8YGSe7l1jmJnTz+qUjVNq81zGJ4znd/PfHAe5kgHEMGvPCcsVgCma0e7j4zyo6sO2yBlT0/z6HmYxc0UyrIur4RP+h2p9vgt/x5M1f69G3bE0uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWW2YzKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWW2YzKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609AC4CED4;
	Thu, 12 Dec 2024 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015783;
	bh=FPEvEihsUPIm8uMIsObuWEntfsO1Byvzt82Vz8BNh54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWW2YzKDu1wJalhdGAtv+zOPKq06IQl+bSNubGaPo18/XNV2Q0roFXudrs5E9dOBF
	 hqNLn1qvypKchGeOsGFaa73hfTy6Q0ItwD46ICTURXtAtCPBVrwuwpY3DUIc9zhF4C
	 YyJFVmdKx351Js7rpSXF/DPNj+chW3zzb/Z2xGzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 044/466] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 15:53:33 +0100
Message-ID: <20241212144308.428482287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f1d0881687233..18284a838e242 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -637,6 +637,10 @@ static int __init igb_init_module(void)
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



