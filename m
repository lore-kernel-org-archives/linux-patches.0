Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216020;
	b=kpk5et239U/L7Q4nxfwknY4KNPPH7lozic/7nJqMDQDIa7242YoIqyzV20tVGvp+bzHm
	 jXo5dZ2EPeVKLOcwoiMxEtoC/YCkY7MAVrR4A1Wri4Z4qMgDd2y4aulEQRs7Acq+wi8Ch
	 31TerJBcKYfLE03EsTtt8WAcuk/kHMMw3AFCHaIhmPUMYAKqxifSe7J6ML0ADo2HVkDuC
	 +YCROYI3URQ06FGd0dHAC4BhodTj4BguswWbbs65w1LxnIhvN+iH2jzgOGGJMcACNCQOd
	 PkE94B73vQEUiJlTVbTUrNopwUnntDlb7LOAKso2rrQWbeFvb/40AtXb+gqhDoetXmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKEHDX8xADHCRGg6RhOR4sjb+z9OL7DgplCCCxu3KzU=;
	b=XtqiqG6SRwuDpk8bq7tXL3S2D7Ke2PepfGUqvvWAslvl2Zw9Zd1nW2pPiBniJPouIqZm
	 vx/yxbEYYUiLD0nHoWINJTwOUHuunGIzfIKr0Sc0ygYGaHWwvxIw/Rjtj9lgOsm55yvoP
	 s1Lonh+yTR5iew67gb0+ZIGv+VZSKiZnk2ejuJ4OpV5MlCqqF/EOJNWPAHdTaTaC4zlN8
	 mq5td65XRAAn6k+bQgVW6ztUPTo1TYzsqZfgn2RYRiUMalwt32Psql/jUpQ/9wd9G9AvP
	 Cu/RSHy9auf5ZIi6R+C0h/vxSzceth0HyFWHmV5e3+Yxat3HW3MqdD7zSDKDJMkPdjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3d9QAaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85947606A31A;
	Wed, 28 Oct 2026 19:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3d9QAaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09CA1F01825;
	Wed, 28 Oct 2026 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216020;
	bh=WKEHDX8xADHCRGg6RhOR4sjb+z9OL7DgplCCCxu3KzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3d9QAaRCE4KDN98koUb4qxStg5M4Y9QtQ67nu2BgVK2+D8WRFApTHq/O/vSuUMtm
	 rSmvjoFCzdC299YSz41IDAYUjeb4WrZr2t1tYlJYIfkuSxZHMn9YpQ5ke+DekFpAIL
	 xNyKN+i2N4pw1cVERBUq98WKRVK972sn7JHQ/zQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1369/1887] wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()
Date: Wed, 28 Oct 2026 17:57:45 +0100
Message-ID: <20261028170530.603055046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 67105abd6195a685a84dcb8a5daf54a1f4bfdb60 ]

In iwl_op_mode_dvm_start(), jumping to out_free_eeprom currently bypasses
the out_free_eeprom_blob label. Consequently, error paths triggered after
successfully parsing the EEPROM free priv->nvm_data but leak
priv->eeprom_blob.

Fix this memory leak by reordering the error handling labels so
that out_free_eeprom falls through to out_free_eeprom_blob.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have
supported Intel DVM wireless hardware and firmware to test with, no
runtime testing was able to be performed.

Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260624084404.570703-1-dawei.feng@seu.edu.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index b490a88b97ca7..68b253d9928ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1502,10 +1502,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv->workqueue = NULL;
 out_uninit_drv:
 	iwl_uninit_drv(priv);
-out_free_eeprom_blob:
-	kfree(priv->eeprom_blob);
 out_free_eeprom:
 	kfree(priv->nvm_data);
+out_free_eeprom_blob:
+	kfree(priv->eeprom_blob);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
-- 
2.53.0



