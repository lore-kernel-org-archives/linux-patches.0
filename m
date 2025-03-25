Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BE91DD9D3;
	Tue, 25 Mar 2025 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905977; cv=none; b=drD0wYaOA1I8fOfsM6rCnBMqGXv8i8ngcaUSWADfQtVM1e1Ef7YG+FdxRjb4jEVu4LjqJHN5kTybbydirzxConLqfFJSsFsoA8ERQgSP02cX6pK0nptpmZ3lDH1xzqhhioi7fTH+/I4jjprTwLDPkyX1cvgNVyk6+9hn1UX0PJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905977; c=relaxed/simple;
	bh=UOlK1dwEYbAsTvd8h58a3NRFPm5SO6iFwz/928wcZJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt6yAFhUqCsL8tymNaqAb0Vhmil8bRnCtWllb0SvnwWVkSMWhZh2A+P8lKlJmFpWjndPiIeHkWiso7wF3ZWK7RWTXV9YRY0ELWUNhfLRViIZp7y9y6jxHIxrDFkcNb31RVDwTMt6KRLAP3VnBaEmbxAOB4SneKD3kpxVCE1h9Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzjMCTrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzjMCTrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4516C4CEE4;
	Tue, 25 Mar 2025 12:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905976;
	bh=UOlK1dwEYbAsTvd8h58a3NRFPm5SO6iFwz/928wcZJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzjMCTrGDki9aGT0hgjz0Pa+Ux9vQXegMKdoZ4zbuTKMQJKD3FX1Zy8ArllV3Bvsy
	 UCLYWTNefx4evDUBb+OGPlPnl2uFjKDAdhOfTzK7qczpG1goU0L0xVqp6DOdYAlb+a
	 GVUMkP2d3zpAGPKDgZCzE0q1Fyu4mHS9lGo6FqsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: [PATCH 6.13 068/119] accel/qaic: Fix integer overflow in qaic_validate_req()
Date: Tue, 25 Mar 2025 08:22:06 -0400
Message-ID: <20250325122150.793415561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 67d15c7aa0864dfd82325c7e7e7d8548b5224c7b upstream.

These are u64 variables that come from the user via
qaic_attach_slice_bo_ioctl().  Use check_add_overflow() to ensure that
the math doesn't have an integer wrapping bug.

Cc: stable@vger.kernel.org
Fixes: ff13be830333 ("accel/qaic: Add datapath")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/176388fa-40fe-4cb4-9aeb-2c91c22130bd@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/qaic/qaic_data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -557,6 +557,7 @@ static bool invalid_sem(struct qaic_sem
 static int qaic_validate_req(struct qaic_device *qdev, struct qaic_attach_slice_entry *slice_ent,
 			     u32 count, u64 total_size)
 {
+	u64 total;
 	int i;
 
 	for (i = 0; i < count; i++) {
@@ -566,7 +567,8 @@ static int qaic_validate_req(struct qaic
 		      invalid_sem(&slice_ent[i].sem2) || invalid_sem(&slice_ent[i].sem3))
 			return -EINVAL;
 
-		if (slice_ent[i].offset + slice_ent[i].size > total_size)
+		if (check_add_overflow(slice_ent[i].offset, slice_ent[i].size, &total) ||
+		    total > total_size)
 			return -EINVAL;
 	}
 


