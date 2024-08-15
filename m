Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE747DA9E;
	Thu, 15 Aug 2024 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729691; cv=none; b=Acr77imwr/CcjlzFRYm3vb0HoAeWRXP3etytlhPOoztyBh8TGTfZA2a7r5m4VDMeLKBfDya1xiwPUABYT5cNFu9T5tE0+pF+4keeFczttYVQaKA1bWuUeTkpzPCskKd0xU9tiKlA25R4o+ukXKq7sDKtRE67O4iWxgsUQy7gngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729691; c=relaxed/simple;
	bh=s1K92oVAKyub6guzqx7gTZ6FFDqznpR1Lnu5nqV8MCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmzFENzGAHN/O3EkKBIm0kPgQsNlwaji5S1T7McSx7QnE3VM61LR9rasoPUzBP2rHrZ2BF4GqYQkOASFOqbZb+RybKDB6F3hx9gtUpED/ur2s9XHlJs0oTKF5+oZGgYSJ4Ff0jw+s3SiTYfp8Os/uswHsb8kquEOIDn5fJa0a18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQ2S8RNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQ2S8RNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A83BC32786;
	Thu, 15 Aug 2024 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729691;
	bh=s1K92oVAKyub6guzqx7gTZ6FFDqznpR1Lnu5nqV8MCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ2S8RNy7QzvC7F11RZO1Xva93IlVxwqXM0e10tNbOJjspqgpdAVdaou11Lr+nihc
	 nNXQqeLJ8WgmJ7Zoq4eit5KdR9lTEfknHGvMvYHDFovwoVO3ewJhlVYZhcWOQXL+Hl
	 Jjamj8RWvFr8elVlFDDMK3dtT9rdhTLEbetvEZnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 178/484] media: venus: fix use after free in vdec_close
Date: Thu, 15 Aug 2024 15:20:36 +0200
Message-ID: <20240815131948.293509479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit a0157b5aa34eb43ec4c5510f9c260bbb03be937e upstream.

There appears to be a possible use after free with vdec_close().
The firmware will add buffer release work to the work queue through
HFI callbacks as a normal part of decoding. Randomly closing the
decoder device from userspace during normal decoding can incur
a read after free for inst.

Fix it by cancelling the work in vdec_close.

Cc: stable@vger.kernel.org
Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/vdec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1632,6 +1632,7 @@ static int vdec_close(struct file *file)
 
 	vdec_pm_get(inst);
 
+	cancel_work_sync(&inst->delayed_process_work);
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);


