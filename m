Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C2F359A9B;
	Sat, 17 Oct 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254919; cv=none; b=DoKIpDN6JgbrbLpCctSp+EW9+pdgki7TA0j9Q0QCMLHBgq/KnA2md8EA2tp/uNArr8rOLPW9ufdvGzPDyj2rLC0GXI9sShvE/V+qnYaSjavJT4FNmxjOOJnA4fIXCV2yGIW+CvyIlPBvKc5P0g2YaTueS7r6iTeu8S8F8+8D3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254919; c=relaxed/simple;
	bh=r8IfDCBeu6z14UCmQ7OAOGxcaauIc0HCky3H4CltI50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIyqA6eW+zuDlaciLAZl1R5PeZqR1XRLyFWZJaXkK0qwJPngBnA5ajOE1KTXDnfLMcMzsGIfT3MjE+dWF5v+JFLq1G89tcMTDvnPEYHJVjIhvew9hOXGp3iAE/sfd84qPciBr2iph0tMDalL8OUqABINe1xS18SUYY+nahCVFiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtOZoTa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtOZoTa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16141F000C4;
	Sat, 17 Oct 2026 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254918;
	bh=bIB3EOVk8zaE1cLBbtYonPnQOrVeTFufPFnCJKC3SXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtOZoTa4QElLtmej/wthZdgk6ZdeydZ08ifrev1wSX+1G+t2QoRMkdZt0mc/j8st8
	 AVUP7M4p+NCwbHpc8PY1tLsLFLY6+d/RKwDlov/k6uK+MjLd+uOJspG8/mb9aA0qXq
	 UfA9S+I+Ujmw+RG15j4qsYZnH/rJZ8P3NMixE8HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 562/869] wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()
Date: Sat, 17 Oct 2026 17:56:43 +0200
Message-ID: <20261017160051.484437029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ee8f588465e61..e9b1a1b09eb29 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1512,10 +1512,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
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



