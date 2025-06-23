Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A30248F63;
	Mon, 23 Jun 2025 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684469; cv=none; b=mnRxy+/5aNFFLbyUhZ8T31O4ku1EXPzj2T3HjAQoV/SA2SpqJBSLYKFjJrJ0XXGl9OjPORM4Ewzc17uY6e+zPFCWBNYyo/nst/dUhLPX4C3jWsGL+jBwbwQujMgT3EYFyF2xsHSxlrC0Ill8FpUWGW8Ddw+6YSzm0ufj1rAMFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684469; c=relaxed/simple;
	bh=QOAaV5ScG7y//eqjG5ltivFVfpBAJ0HtCmuzHXzzYtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF9zgG45IHjMcmlgvHnj/vJLyB5nXLolwMlhuYRbEMSp+HNIcAUl67lo9R4eSiLi2nzataQRGaulc7OT9w/I1F2iOp4z/F3uw90Ui8lkeCkGjkH30uLbG4ibfmYzFwFAGA+jvXvMmOkhgGze0gXZk7FHFgmkf2a2qdVJ84gZCUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3b9u1Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3b9u1Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB99C4CEEA;
	Mon, 23 Jun 2025 13:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684468;
	bh=QOAaV5ScG7y//eqjG5ltivFVfpBAJ0HtCmuzHXzzYtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3b9u1ZxXt4NNDpPOJ70muKSyGELizfaYOGmit1FJ+H7B5sf/tEnbAaC/RY0v0BnT
	 dbWONl5mIFCyw71La4GUramyFjk9bDFX7tpH7eRgen5dlz2wXPYLbvtOiFTxQJCsFZ
	 PSDtwdJZfbV5GIJqqUM9j21dm17NSFly3OBGyMWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 073/592] media: iris: fix error code in iris_load_fw_to_memory()
Date: Mon, 23 Jun 2025 15:00:31 +0200
Message-ID: <20250623130702.000752620@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit e68c3c50a736490d9c07888fe525718d16ff9e9c upstream.

Return -ENOMEM if memremap() fails.  Don't return success.

Fixes: d19b163356b8 ("media: iris: implement video firmware load/unload")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index 7c493b4a75db..f1b5cd56db32 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -53,8 +53,10 @@ static int iris_load_fw_to_memory(struct iris_core *core, const char *fw_name)
 	}
 
 	mem_virt = memremap(mem_phys, res_size, MEMREMAP_WC);
-	if (!mem_virt)
+	if (!mem_virt) {
+		ret = -ENOMEM;
 		goto err_release_fw;
+	}
 
 	ret = qcom_mdt_load(dev, firmware, fw_name,
 			    pas_id, mem_virt, mem_phys, res_size, NULL);
-- 
2.50.0



