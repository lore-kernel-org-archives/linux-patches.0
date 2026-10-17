Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DB339EF2C;
	Sat, 17 Oct 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259575; cv=none; b=evjP4Zpwq5Mva9aqurJwbpsDlqvnOgDr2bMx2qjxp853cvJZFCZkzpkvKMea6EdDyJ6QmmSSWNyUVDnHUmVzBETEyy8yRS1sLFaEFK2HZpvftHt7Vt1Phj2TDxCijPuixchTxVd/9SjV26egJkX+UshUAos2D3H2JaD+ZQWmdbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259575; c=relaxed/simple;
	bh=r96GrZGzajNAm+Rx30yZAK/DbUD1NpTJtGIJvpbTPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwMPmZt5H4isL4EXCCHFWSM58ZRCDvmZZaqn6j1YNDk18yy4oeMn/Y313XPxhb6kNGsYxjIwWaB0B74q1AElvRyY7AL0FUhu+68Q+6J5i5GP4+WwuAXjPtdE8v95saTF7jgp0Z+VW2iuXhuS3EhBdK6LtiSaVgFIlNii7UHQBeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0mO2+yB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0mO2+yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF11F000C4;
	Sat, 17 Oct 2026 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259574;
	bh=OSRp9GD5DMf+Zhvn0jeFBNfOB1FEaofqIck9fuql3eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0mO2+yBZebnXUqFFWzsPgjf/4SFfHPyXLZeDbKiTN3NP56Lqo8x3lulYGbcuo5nW
	 OD2WbK3jwgP7YZPD6EUdRuc4B6w8AZ54fL0vxujINjCOhgQ5dinRcFiiJ3tabwCJFa
	 7tpXpzI9Hok6Abxr6y/4u1cYVX9OAoOsE6E7GR5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1259/1674] wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()
Date: Sat, 17 Oct 2026 17:58:51 +0200
Message-ID: <20261017160503.457894761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9b2306520d12..73b1f5a9bde6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1514,10 +1514,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv->workqueue = NULL;
 out_uninit_drv:
 	iwl_uninit_drv(priv);
-out_free_eeprom_blob:
-	kfree(priv->eeprom_blob);
 out_free_eeprom:
 	kfree(priv->nvm_data);
+out_free_eeprom_blob:
+	kfree(priv->eeprom_blob);
 out_leave_trans:
 	iwl_trans_op_mode_leave(priv->trans);
 out_free_hw:
-- 
2.53.0



