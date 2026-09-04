Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EBA3451AB;
	Fri,  4 Sep 2026 06:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501764; cv=none; b=hylnuQQgYf02DWG4xIq826HXqdEqHtdNlR6wB3y+c9pE1aF2JXTQnJcO3Gk9ErxhwD9EeleXudGjpdsFWSuExBjj7cjfFyYf9PQrC0htPvexLYOisk88O/lfJplenx7fBTVaJREIVyp6Nj+jnZDXkR9jGSBE+k0nCUhy86krdyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501764; c=relaxed/simple;
	bh=mxA4IwF5TGMOTk6zLaPhkwjxx2vK+zA+azGa5J9gEJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZx//LY0TEwgVoIqL86xSlvw1Fk8e+fTHrqJHud9Na/fQE1A8Q46RuGLZADRUpDk2tX0B131tYi9UdZm4/iZsBwoTxN/u3RSTdzygN+KjCFC9E4TdtmCnY6Bk20VGsZ/3O4KEIMTO5bsAor7o29uwXoe0kQ+yuxdf2ut+tc4MgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyT8KqkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyT8KqkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B3D1F00A3D;
	Fri,  4 Sep 2026 06:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501763;
	bh=OeC3yODhhdyoIv6YqWOKYPHzjtgFI4o/Oh4xrL9xZdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyT8KqkXodzp1tOeazb5rW+6iPws9MlLfmIzh2n85LNBV5L0bh2WgEb+jjiJslfFC
	 +7+Lj6rxb9qghB/tU0M5i0AhYM4Uvn7v9GRqKqjbb2DGPY1uTrgwA+6Rh4qOICFz86
	 n5jtfdPVj61owftZo4KmLHHkcVOhYNFlMyPmdE8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 523/552] wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()
Date: Fri,  4 Sep 2026 07:01:20 +0200
Message-ID: <20260904045802.485120517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


