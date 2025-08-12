Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED432F291B;
	Tue, 12 Aug 2025 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024221; cv=none; b=IOM6eXFNP6VxHMc4CDr6usx+Y2zTmObCi2DW3TIJ4Tp9YCrmUJloBdxrRt2VCPQ0gUii14CyDh52ltLVtE+4rUvhp4e2K3JMsHuMfah5FxeVOdOpiV9hJjOGrzj5cfK+PMozE7+Jy023hRPiabSU9phVQL7xdk9yCVzrLF9wr8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024221; c=relaxed/simple;
	bh=GrXUKaDnexGNPhnkTP2p/ooloyFRSsYnEpzynJlYavU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEELuOHUxRxZitPvkQW23Ay9p90+s+hObJ8gQ+vEXHYemUcWpQrSLWcxZdzBvY3QuGOvQorGbrJBq3e9p8PHWvLsExE4SqYbtXCtvOjWPQV8clR10a/yuHXKIx4LNjlFGHMqgTcNZL+8ei+zrPclg/XUlLuVaPZJ4JnoiK1cbGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjpoSZmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjpoSZmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700F8C4CEF0;
	Tue, 12 Aug 2025 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024220;
	bh=GrXUKaDnexGNPhnkTP2p/ooloyFRSsYnEpzynJlYavU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjpoSZmtdDBcxVW90+kN612pTv4q+LhPqYu+Q6jR2dDigJmqJRTMPQwX7yjJuMm37
	 j23KjqZsZumHgn7NJpdy584PUAVb5d4oxJ4lSiVkDRZPjRIGtGa0Kga5T9tx8jWAw6
	 PnjFXJp43zgupPCxTet/xBzA8Zd1STfYwX3YhNus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 308/627] crypto: ccp - Fix dereferencing uninitialized error pointer
Date: Tue, 12 Aug 2025 19:30:03 +0200
Message-ID: <20250812173431.025774193@linuxfoundation.org>
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

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 0fa766726c091ff0ec7d26874f6e4724d23ecb0e ]

Fix below smatch warnings:
drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked()
error: we previously assumed 'error' could be null

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3451bada884e..8fb94c5f006a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1276,9 +1276,11 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 
 static int __sev_platform_init_locked(int *error)
 {
-	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+	int rc, psp_ret, dfflush_error;
 	struct sev_device *sev;
 
+	psp_ret = dfflush_error = SEV_RET_NO_FW_CALL;
+
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
@@ -1320,10 +1322,10 @@ static int __sev_platform_init_locked(int *error)
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
-	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, &dfflush_error);
 	if (rc) {
 		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
-			*error, rc);
+			dfflush_error, rc);
 		return rc;
 	}
 
-- 
2.39.5



