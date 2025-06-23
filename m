Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D760C2E0;
	Mon, 23 Jun 2025 22:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716821; cv=none; b=cJ1FYktg7KeJGWDIpmiXNpnnmMwcCRto/lKyGm/htnxq+J3CWVHBhIkJhNaYfg/BGvCa6f3q9bNo6l3fmFCP9DoJg78374cbZRSJh2bMOIJ5ui8vj/LlyidjvUmYaKWXg8cG1P/xEfWU7hx8TWcW4PVX23VbP0mkmcKjrKznbyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716821; c=relaxed/simple;
	bh=Nr4RfBOhlheR6jDZnzJvc+Kfsjgk09eJsbkkcxo+dlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oNM6en/Fxh1ErnvsHYUP7cKm1dMyL19zYJteWzW+Jyt/0ZXbMiIHc3KmIgqJBzMSQaX07/6ZBUr/Waffv8Emh+/l43gMeYuZFfr+x7ultU1bzIoT0+BO6654E2sObhm7PtX0qfa73r1CUklyUKPInBgLkvr8C3j0c7aF9/lAMiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvNgnQO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvNgnQO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527D7C4CEF2;
	Mon, 23 Jun 2025 22:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716820;
	bh=Nr4RfBOhlheR6jDZnzJvc+Kfsjgk09eJsbkkcxo+dlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvNgnQO9WizZ7qZrFEPfd+DM1pIsw6iND5sB7U4KeXPSAs6RQZtRAWwYrOgz4FUUC
	 fOKH5TeMWva1B5rkOB1Ed8jJG7lD/gvXEPGaOmfYDK1ShdjmuKRBiMhxpmNnsXPvpf
	 2zoH5JNeUl73TCvANk6dPxzBDOe5s0UphUUtPyAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/414] platform/x86/amd: pmf: Prevent amd_pmf_tee_deinit() from running twice
Date: Mon, 23 Jun 2025 15:07:07 +0200
Message-ID: <20250623130649.262525933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6bcc1d57f968..a9b195ec6f33f 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -422,12 +422,12 @@ static int amd_pmf_ta_open_session(struct tee_context *ctx, u32 *id, const uuid_
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
@@ -462,7 +462,9 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 	dev->tee_ctx = tee_client_open_context(NULL, amd_pmf_amdtee_ta_match, NULL, NULL);
 	if (IS_ERR(dev->tee_ctx)) {
 		dev_err(dev->dev, "Failed to open TEE context\n");
-		return PTR_ERR(dev->tee_ctx);
+		ret = PTR_ERR(dev->tee_ctx);
+		dev->tee_ctx = NULL;
+		return ret;
 	}
 
 	ret = amd_pmf_ta_open_session(dev->tee_ctx, &dev->session_id, uuid);
@@ -502,9 +504,12 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 
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



