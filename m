Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959251DB92A;
	Tue, 12 Aug 2025 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023771; cv=none; b=s+XiLD2qRkSE7skqHS6g4EKgPyfa+cIycSfUYzDYOXbgYuKQuCnCVi42eifvcxeaYMuBK97HAmHR/sO97iFxZF8po/hiy6JSshG/ogcB3DXh8nA3cT6AXwHHUGPt1J4NVW/T6wMYpkZrTjOksDw0dMyRNy/o+7GBMzDsLnqLYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023771; c=relaxed/simple;
	bh=W/56mvw92a747GixckqX5N6NYoXWg7iRLFA6w4ijVIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koeJ+VszsTvRB1H2Tu7dOK0neGkJvumE4LQ4ddURR9HzWBKvV3ZO0gUDaYd3APCSNnNLr8fWBjfxHMENqqkkxIVi1Ul9Fng6a2BD/c6OP617mxG9UXrJhBMk3R0rrvAVvQoGLscxo7bvNivF5uKZulys8b30cjwzpvs3sm8OmlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I93IOBdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I93IOBdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDC7C4CEF0;
	Tue, 12 Aug 2025 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023771;
	bh=W/56mvw92a747GixckqX5N6NYoXWg7iRLFA6w4ijVIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I93IOBdmQkJnut+JprB4nhDqM+kGJY324E/ANHziAsbuN7K1U5mI751EyvK4NVrFs
	 CNWVF22KhcooOk24KDXCot8jENno1xJhzGO86GN3P5pz4ew96/8ag+IrqQEtch5R6L
	 bUoSMLXzPd5ZSKg5Ebog3p2w27cqz5j/BYooKgzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 177/627] wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()
Date: Tue, 12 Aug 2025 19:27:52 +0200
Message-ID: <20250812173426.009260138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e015b83bb6e9..2b4dbebc71c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1467,7 +1467,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
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



