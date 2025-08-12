Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D655C2949E0;
	Tue, 12 Aug 2025 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025748; cv=none; b=EdanjpOW+CNkTb2BJUmtGYG79ILhjBPOcG5WXkVh7tojOD3AliWxFTIjJG02gRi1KTwn6E6DkOi4Q+iAESoValHzoia/6cAKu1CMQN4xcAyrbzmp5fh0pDi7GJz6wEPjX2UgmlLpP+muEerStBSSthskcUQdBJfcahA1USl2jjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025748; c=relaxed/simple;
	bh=qVMb/db35WLs2OKmPmnoCFxL02Z5j+Nav9MN7mT+LZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzfiV/LS1EwcrGHJSJYBiExUFBtWKGnuQqXOA4LCDA1yVonqkGTZgC5zifdLjPyDT6maZfeHy7uXV/62c634FK89l9+ZtWkeXUfszw1TthCp6wWb9F0coii5FOPb3gBozMjP8KYr0KfB+NvDerXwHoO24Y/aD5HUdgbsX09gjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS/eyyYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS/eyyYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4687BC4CEF0;
	Tue, 12 Aug 2025 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025748;
	bh=qVMb/db35WLs2OKmPmnoCFxL02Z5j+Nav9MN7mT+LZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pS/eyyYfgCkKIRBQHkpmqr7zgWUoZKNE8s1C1wqg5LL+2v+nK4ZpyFbZGD8hXsUF3
	 u3E9AqT1xrNU9C5NjOVXo1xeTX+hm8cjZhFBD6+94XW2gDkk+HrHnZ+bwub/oguxYr
	 1VJ7pgfMoWnp2OzOlRIfXqlS5E4UhSCO8weoGHl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 132/480] wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()
Date: Tue, 12 Aug 2025 19:45:40 +0200
Message-ID: <20250812174402.969967095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cf80c02a9fdb6c5bc8508beb6a0f6a1294fc32f6 ]

Preserve the error code if iwl_setup_deferred_work() fails.  The current
code returns ERR_PTR(0) (which is NULL) on this path.  I believe the
missing error code potentially leads to a use after free involving
debugfs.

Fixes: 90a0d9f33996 ("iwlwifi: Add missing check for alloc_ordered_workqueue")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/a7a1cd2c-ce01-461a-9afd-dbe535f8df01@sabinyo.mountain
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index cd20958fb91a..59c13c40bb83 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1468,7 +1468,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	if (iwl_setup_deferred_work(priv))
+	err = iwl_setup_deferred_work(priv);
+	if (err)
 		goto out_uninit_drv;
 
 	iwl_setup_rx_handlers(priv);
-- 
2.39.5



