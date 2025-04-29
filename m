Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53F24113C;
	Tue, 29 Apr 2025 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947197; cv=none; b=tiTPnGkWRGOYBQnYcVmZ4FhI9EfkVbWa7fA5Gz/7CR6I9HaFDMykUAfKFx7JyvenohThbzz1jUS8Bdd//fFmzh00s+S/L3f5DBLiVwSFVjg2MnHEX8DrGi5M4lmY/eLMoSNnQUAI/nMRayuQtINLzgfyQFkM5LB1P7546lgMa2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947197; c=relaxed/simple;
	bh=m8AmfNs6Kr6v+JhTcJCV3TULGj8Xp+hRgI/9Xbk8e0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbrouQdEoNWA95M44wDquEPxBDjmr2eRr0XoZdP28Ys6ku5kwcdJbbnmuMrNNSuO+AblcBj1vE66PtHuqGZ35K8w6yPhjvmCOIkE1VH1lpkQzXuXpc51Da5jVFhVPj9UTVHXUq+0lTEq+7wVaRvu0+Tueo4Q/sRQ0RXpKvq4s+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qp7ZZgdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qp7ZZgdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5DCC4CEE9;
	Tue, 29 Apr 2025 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947197;
	bh=m8AmfNs6Kr6v+JhTcJCV3TULGj8Xp+hRgI/9Xbk8e0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qp7ZZgdnSlbWwz6cY3GlQCU+FtqTrLlC2eWTY21+QnVvQBJTOOrOcRLUmw+TaTmvk
	 h/U++c79wmHVM8SDL47sHEyBHsMey3v8Hk5Oz2sttycpxrrgoOnyr0MBec3UQi5SUU
	 EyvgubGZRjwKVvmz3Y431FM3ETVj/OFHn+OX6IVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fritz Koenig <frkoenig@chromium.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/286] media: venus: hfi: Correct session init return error
Date: Tue, 29 Apr 2025 18:41:48 +0200
Message-ID: <20250429161116.351470831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit e922a33e0228fa314ffc4f70b3b9ffbc4aad1bbe ]

The hfi_session_init can be called many times and it returns
EINVAL when the session was already initialized. This error code
(EINVAL) is confusing for the callers. Change hfi_session_init to
return EALREADY error code when the session has been already
initialized.

Tested-by: Fritz Koenig <frkoenig@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi.c  | 2 +-
 drivers/media/platform/qcom/venus/vdec.c | 2 +-
 drivers/media/platform/qcom/venus/venc.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 17da555905e98..5fd53227c2c0b 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -212,7 +212,7 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
 	int ret;
 
 	if (inst->state != INST_UNINIT)
-		return -EINVAL;
+		return -EALREADY;
 
 	inst->hfi_codec = to_codec_type(pixfmt);
 	reinit_completion(&inst->done);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index d91030a134c0e..6e9b62645e917 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -768,7 +768,7 @@ static int vdec_session_init(struct venus_inst *inst)
 	int ret;
 
 	ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
-	if (ret == -EINVAL)
+	if (ret == -EALREADY)
 		return 0;
 	else if (ret)
 		return ret;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 18d20b4ca2cfd..9f1b02e31b98c 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -727,7 +727,7 @@ static int venc_init_session(struct venus_inst *inst)
 	int ret;
 
 	ret = hfi_session_init(inst, inst->fmt_cap->pixfmt);
-	if (ret == -EINVAL)
+	if (ret == -EALREADY)
 		return 0;
 	else if (ret)
 		return ret;
-- 
2.39.5



