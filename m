Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A203815E1;
	Fri,  4 Sep 2026 05:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500179; cv=none; b=GwtYXggtGzVRoV67qBK+KpIWJMCbTybEMYJj5QVgOgalkMOMjqooeCWnhZ751nT618lzmYZR/jPh+UEO3FWH/0OPO15cZJkZ9EUzHwhU+HfD+KZkLTVyvtP7A1L1aN/r3hRxahUrcFcspUPLUQ0fdID8wXj0SO/Qvmk60g2LXug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500179; c=relaxed/simple;
	bh=e28MQ73Lxs+FatWcbzzVVWM56C8nkA3+WJo4wJRkkU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgWes8p7o71c9evkl9YsdHXQQ5BpWxII8Dn62nP4x31GS3m/WPe5W1elYY2qR17Oulmvfo18xo6+nxhofQwKNATjtZyKjkz4CR7slrS3JWt0hL+K1oxhr8fEfufZq0NkVUFHO1zhl6EBVayms2HUwziNJRUFkG/dQUGhiQ0pv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ+Mu2gZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ+Mu2gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249A81F00A3D;
	Fri,  4 Sep 2026 05:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500177;
	bh=OpS8/74wLQTOSRxOsWrKCQuhgch9yPBzb7odPBZtvx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ+Mu2gZj+86p3Mcat3iXGJEcCAYD5IdwqWc4BVKjDAeqEcfaDJhzHYnIH7tA9gi5
	 ST3jL/KLY4w73rZ6JwPqvm2iZ1AbxhrSrc8Y0G4VYNEqiD45qmnSztlBSimd6zi7xD
	 XjnOjVSOgXlZh3y/gTLVt4ANfQELjy4EoZ08UMok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 7.2 676/713] wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()
Date: Fri,  4 Sep 2026 07:00:44 +0200
Message-ID: <20260904045818.988593079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 67105abd6195a685a84dcb8a5daf54a1f4bfdb60 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1511,10 +1511,10 @@ out_destroy_workqueue:
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


