Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61A229B13;
	Mon, 23 Jun 2025 21:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715103; cv=none; b=PPTP6K6Vh+DCyfpG2WS9fa+NYXKMVxFU8AE6HaEg5jwz60h5dJ7FoRCGXHpwizus6f5Ml102slv3YL90R9uoKrJQ6qL1AAgXvV45ogM5Rt+2cfG1KbZV5YbNsRD5OR4aXUS6pzLbWsR58G/VBsPCkWIxoyRHQOB/uDbKQQbCVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715103; c=relaxed/simple;
	bh=M2The7Cf/qXkO6kcWxAflhhRAivz0/zG4C/gc8IRe7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfiufYYPcOP0UJTWGJCGCrFE759PbtbDz4jQ6fRTdU35kWUGsLk0GLyCQcg6u4z/iiikQXPyxLjYgT5JQddjmFe5rV4Y+LrLxga5FLvE8EajdG5pnI2m5Ochr/0XGpN9oVhvbh8banvhnHyVofhmdjul7nHx2GKDyXJx3zXcVSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4C66KwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4C66KwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868DEC4CEF4;
	Mon, 23 Jun 2025 21:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715103;
	bh=M2The7Cf/qXkO6kcWxAflhhRAivz0/zG4C/gc8IRe7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4C66KwLqYhcKWZXEL/Uf8hp3q7QrAoYufILm212QyvzvTRiGBRNxrCehYhSKttn7
	 UPHRAI1naczGDSkrwxU7KyKOS1X4+xK5d124OD203qLfEIwXmyJ01TS7yH30oM6MTE
	 +1kyZdzNRm+ZsMXL8UsuMIqqArdhbo99jV5YJZm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 437/592] platform/x86/amd: pmf: Prevent amd_pmf_tee_deinit() from running twice
Date: Mon, 23 Jun 2025 15:06:35 +0200
Message-ID: <20250623130710.828652229@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 93103d56650d7a38ed37ba4041578310f82776ae ]

If any of the tee init fails, pass up the errors and clear the tee_ctx
pointer. This will prevent cleaning up multiple times.

Fixes: ac052d8c08f9d ("platform/x86/amd/pmf: Add PMF TEE interface")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250512211154.2510397-3-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250522003457.1516679-3-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/tee-if.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 027e992b71472..76efce48a45ce 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -420,12 +420,12 @@ static int amd_pmf_ta_open_session(struct tee_context *ctx, u32 *id, const uuid_
 	rc = tee_client_open_session(ctx, &sess_arg, NULL);
 	if (rc < 0 || sess_arg.ret != 0) {
 		pr_err("Failed to open TEE session err:%#x, rc:%d\n", sess_arg.ret, rc);
-		return rc;
+		return rc ?: -EINVAL;
 	}
 
 	*id = sess_arg.session;
 
-	return rc;
+	return 0;
 }
 
 static int amd_pmf_register_input_device(struct amd_pmf_dev *dev)
@@ -460,7 +460,9 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 	dev->tee_ctx = tee_client_open_context(NULL, amd_pmf_amdtee_ta_match, NULL, NULL);
 	if (IS_ERR(dev->tee_ctx)) {
 		dev_err(dev->dev, "Failed to open TEE context\n");
-		return PTR_ERR(dev->tee_ctx);
+		ret = PTR_ERR(dev->tee_ctx);
+		dev->tee_ctx = NULL;
+		return ret;
 	}
 
 	ret = amd_pmf_ta_open_session(dev->tee_ctx, &dev->session_id, uuid);
@@ -500,9 +502,12 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 
 static void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
 {
+	if (!dev->tee_ctx)
+		return;
 	tee_shm_free(dev->fw_shm_pool);
 	tee_client_close_session(dev->tee_ctx, dev->session_id);
 	tee_client_close_context(dev->tee_ctx);
+	dev->tee_ctx = NULL;
 }
 
 int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
-- 
2.39.5



