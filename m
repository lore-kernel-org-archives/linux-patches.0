Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922E728D827;
	Wed, 23 Apr 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421049; cv=none; b=JGlwZUm955yadjjDJL+kM3bJnWeiEYwglRUcYA5xxSNWhj8NnGlYhBL+AyMlMhHgf5qpuGq72huLD1RtaKrnC/It7vaxe8i6p8B5S+P3caZemjfGa7P+jdpuASigfW+mXuummcOcEVKErEFwXlo7JIhEjEXH7rnNSyAOFARIYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421049; c=relaxed/simple;
	bh=QidgjTNCuKF8K1sIjKJeRWB+2L3N/oi8ALe7rqIhNt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQUBLZ/cK0onFg3iBXPb1asJf2VVGc7pZ2dNXZHacoNxu+oTx4/vnnRzI12GAqLGl40LoF0gMDdyddRWMhpwx+jiRsaSLqUDEJrJFTJJE0PKtMVTS+lNHDB+GkHRV0KI0swkOZHzDN4G38bIyyFi85TKxmtuc1IwE8g63/YZXCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgHtXmyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgHtXmyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD0AC4CEE2;
	Wed, 23 Apr 2025 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421049;
	bh=QidgjTNCuKF8K1sIjKJeRWB+2L3N/oi8ALe7rqIhNt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgHtXmyolzU9MPtdLlypSnQ5oPBp/2FNL4xDCmhqHX2Tik6C5yqSuDUN7yeqQpgM0
	 wNc72sACGpPSo6bLCTp65Z6p4U/YX0Nz0e1FOZViqWL6eQJMo3TyhJ4J7CT3tNd1T7
	 y1WsBMg1AcCqpUaHkxPXtz4YYFeoIH8ugnFyrMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 123/393] media: venus: hfi: add a check to handle OOB in sfr region
Date: Wed, 23 Apr 2025 16:40:19 +0200
Message-ID: <20250423142648.444857743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit f4b211714bcc70effa60c34d9fa613d182e3ef1e upstream.

sfr->buf_size is in shared memory and can be modified by malicious user.
OOB write is possible when the size is made higher than actual sfr data
buffer. Cap the size to allocated size for such cases.

Cc: stable@vger.kernel.org
Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1035,18 +1035,26 @@ static void venus_sfr_print(struct venus
 {
 	struct device *dev = hdev->core->dev;
 	struct hfi_sfr *sfr = hdev->sfr.kva;
+	u32 size;
 	void *p;
 
 	if (!sfr)
 		return;
 
-	p = memchr(sfr->data, '\0', sfr->buf_size);
+	size = sfr->buf_size;
+	if (!size)
+		return;
+
+	if (size > ALIGNED_SFR_SIZE)
+		size = ALIGNED_SFR_SIZE;
+
+	p = memchr(sfr->data, '\0', size);
 	/*
 	 * SFR isn't guaranteed to be NULL terminated since SYS_ERROR indicates
 	 * that Venus is in the process of crashing.
 	 */
 	if (!p)
-		sfr->data[sfr->buf_size - 1] = '\0';
+		sfr->data[size - 1] = '\0';
 
 	dev_err_ratelimited(dev, "SFR message from FW: %s\n", sfr->data);
 }


