Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B189286B5;
	Fri, 24 Nov 2023 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxzGvnuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F82C433C7;
	Fri, 24 Nov 2023 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852051;
	bh=yaBbWOcUsJVt6MUaahE8AFQBevo0YWRGDRsidVJw5jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxzGvnuZwH9aw9JBOUSitJ630aFiTow4PVER4E8Y9L2RdX95sYVu7jF+8rfmJmlEZ
	 CxDVMmhJKyOEKcQvzzM280A0DQNhwNkqrPVJ6nuNjNBRDXrXeHaSg/pWUiptsB9u6T
	 5Tnr7kdWGnB9HuLGFYhgXpSLLywkgk65hn+2YF6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 201/372] KEYS: trusted: tee: Refactor register SHM usage
Date: Fri, 24 Nov 2023 17:49:48 +0000
Message-ID: <20231124172017.157792662@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Garg <sumit.garg@linaro.org>

commit c745cd1718b7825d69315fe7127e2e289e617598 upstream.

The OP-TEE driver using the old SMC based ABI permits overlapping shared
buffers, but with the new FF-A based ABI each physical page may only
be registered once.

As the key and blob buffer are allocated adjancently, there is no need
for redundant register shared memory invocation. Also, it is incompatibile
with FF-A based ABI limitation. So refactor register shared memory
implementation to use only single invocation to register both key and blob
buffers.

[jarkko: Added cc to stable.]
Cc: stable@vger.kernel.org # v5.16+
Fixes: 4615e5a34b95 ("optee: add FF-A support")
Reported-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Tested-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tee.c |   64 +++++++++----------------------
 1 file changed, 20 insertions(+), 44 deletions(-)

--- a/security/keys/trusted-keys/trusted_tee.c
+++ b/security/keys/trusted-keys/trusted_tee.c
@@ -65,24 +65,16 @@ static int trusted_tee_seal(struct trust
 	int ret;
 	struct tee_ioctl_invoke_arg inv_arg;
 	struct tee_param param[4];
-	struct tee_shm *reg_shm_in = NULL, *reg_shm_out = NULL;
+	struct tee_shm *reg_shm = NULL;
 
 	memset(&inv_arg, 0, sizeof(inv_arg));
 	memset(&param, 0, sizeof(param));
 
-	reg_shm_in = tee_shm_register_kernel_buf(pvt_data.ctx, p->key,
-						 p->key_len);
-	if (IS_ERR(reg_shm_in)) {
-		dev_err(pvt_data.dev, "key shm register failed\n");
-		return PTR_ERR(reg_shm_in);
-	}
-
-	reg_shm_out = tee_shm_register_kernel_buf(pvt_data.ctx, p->blob,
-						  sizeof(p->blob));
-	if (IS_ERR(reg_shm_out)) {
-		dev_err(pvt_data.dev, "blob shm register failed\n");
-		ret = PTR_ERR(reg_shm_out);
-		goto out;
+	reg_shm = tee_shm_register_kernel_buf(pvt_data.ctx, p->key,
+					      sizeof(p->key) + sizeof(p->blob));
+	if (IS_ERR(reg_shm)) {
+		dev_err(pvt_data.dev, "shm register failed\n");
+		return PTR_ERR(reg_shm);
 	}
 
 	inv_arg.func = TA_CMD_SEAL;
@@ -90,13 +82,13 @@ static int trusted_tee_seal(struct trust
 	inv_arg.num_params = 4;
 
 	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT;
-	param[0].u.memref.shm = reg_shm_in;
+	param[0].u.memref.shm = reg_shm;
 	param[0].u.memref.size = p->key_len;
 	param[0].u.memref.shm_offs = 0;
 	param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
-	param[1].u.memref.shm = reg_shm_out;
+	param[1].u.memref.shm = reg_shm;
 	param[1].u.memref.size = sizeof(p->blob);
-	param[1].u.memref.shm_offs = 0;
+	param[1].u.memref.shm_offs = sizeof(p->key);
 
 	ret = tee_client_invoke_func(pvt_data.ctx, &inv_arg, param);
 	if ((ret < 0) || (inv_arg.ret != 0)) {
@@ -107,11 +99,7 @@ static int trusted_tee_seal(struct trust
 		p->blob_len = param[1].u.memref.size;
 	}
 
-out:
-	if (reg_shm_out)
-		tee_shm_free(reg_shm_out);
-	if (reg_shm_in)
-		tee_shm_free(reg_shm_in);
+	tee_shm_free(reg_shm);
 
 	return ret;
 }
@@ -124,24 +112,16 @@ static int trusted_tee_unseal(struct tru
 	int ret;
 	struct tee_ioctl_invoke_arg inv_arg;
 	struct tee_param param[4];
-	struct tee_shm *reg_shm_in = NULL, *reg_shm_out = NULL;
+	struct tee_shm *reg_shm = NULL;
 
 	memset(&inv_arg, 0, sizeof(inv_arg));
 	memset(&param, 0, sizeof(param));
 
-	reg_shm_in = tee_shm_register_kernel_buf(pvt_data.ctx, p->blob,
-						 p->blob_len);
-	if (IS_ERR(reg_shm_in)) {
-		dev_err(pvt_data.dev, "blob shm register failed\n");
-		return PTR_ERR(reg_shm_in);
-	}
-
-	reg_shm_out = tee_shm_register_kernel_buf(pvt_data.ctx, p->key,
-						  sizeof(p->key));
-	if (IS_ERR(reg_shm_out)) {
-		dev_err(pvt_data.dev, "key shm register failed\n");
-		ret = PTR_ERR(reg_shm_out);
-		goto out;
+	reg_shm = tee_shm_register_kernel_buf(pvt_data.ctx, p->key,
+					      sizeof(p->key) + sizeof(p->blob));
+	if (IS_ERR(reg_shm)) {
+		dev_err(pvt_data.dev, "shm register failed\n");
+		return PTR_ERR(reg_shm);
 	}
 
 	inv_arg.func = TA_CMD_UNSEAL;
@@ -149,11 +129,11 @@ static int trusted_tee_unseal(struct tru
 	inv_arg.num_params = 4;
 
 	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT;
-	param[0].u.memref.shm = reg_shm_in;
+	param[0].u.memref.shm = reg_shm;
 	param[0].u.memref.size = p->blob_len;
-	param[0].u.memref.shm_offs = 0;
+	param[0].u.memref.shm_offs = sizeof(p->key);
 	param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
-	param[1].u.memref.shm = reg_shm_out;
+	param[1].u.memref.shm = reg_shm;
 	param[1].u.memref.size = sizeof(p->key);
 	param[1].u.memref.shm_offs = 0;
 
@@ -166,11 +146,7 @@ static int trusted_tee_unseal(struct tru
 		p->key_len = param[1].u.memref.size;
 	}
 
-out:
-	if (reg_shm_out)
-		tee_shm_free(reg_shm_out);
-	if (reg_shm_in)
-		tee_shm_free(reg_shm_in);
+	tee_shm_free(reg_shm);
 
 	return ret;
 }


