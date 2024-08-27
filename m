Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E0B1A0B13;
	Tue, 27 Aug 2024 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770060; cv=none; b=H5/Dt0Bqs9CD+kZLBjNzwaUMo6xHzBi7s6P3ld08i5M2eX4iWa3wdgLkPpA1zxGGIYjl2D3PFtUsYU/FoPA44oXCrBPvFk3eIwLHsAU9HNY4onOzFqXqx549EFJr4LBnvdZX75tHHLz4EdAcQtdFwpFbGVJR4BJYbjOU5BPN5uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770060; c=relaxed/simple;
	bh=131xuYtn3O2Mjh9RfGIhYDiEqt7wOnbAUCAx60N3npk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9UXTWsOtm5ZL7MrZDOhyMU5bKXdojXoWivoH6J2P5Lmfn4olixvYtNOAvHcWF24iqNBBLl20tLa61BjcKIyOrttiRew3wQs9QalZ7hFdq6dms74E1hen7KHAvYahLm48rvN7PivaSQRIMwdj2jQbkEnP65DoE0Ue8MRujSfu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPTjzY9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPTjzY9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FB5C61040;
	Tue, 27 Aug 2024 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770060;
	bh=131xuYtn3O2Mjh9RfGIhYDiEqt7wOnbAUCAx60N3npk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPTjzY9cuRxYN6s2182rzQ4hVwCuYRlQ9Qbj/TflFNuskFLb2QNmIWsHnLEInKgPC
	 C8TI9l/pfHloWcMorMZrjLBchvb6h4g79FsaqJ3OZQUaM8aG+ktDUuAxvgiTL6ihbw
	 5A9rIz8uPc0RuuBOyvd1hQLz0nGT0Gzw5NmUFU34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/341] media: s5p-mfc: Fix potential deadlock on condlock
Date: Tue, 27 Aug 2024 16:35:45 +0200
Message-ID: <20240827143847.750725773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 04d19e65137e3cd4a5004e624c85c762933d115c ]

As &dev->condlock is acquired under irq context along the following
call chain from s5p_mfc_irq(), other acquisition of the same lock
inside process context or softirq context should disable irq avoid double
lock. enc_post_frame_start() seems to be one such function that execute
under process context or softirq context.

<deadlock #1>

enc_post_frame_start()
--> clear_work_bit()
--> spin_loc(&dev->condlock)
<interrupt>
   --> s5p_mfc_irq()
   --> s5p_mfc_handle_frame()
   --> clear_work_bit()
   --> spin_lock(&dev->condlock)

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock.

To prevent the potential deadlock, the patch change clear_work_bit()
inside enc_post_frame_start() to clear_work_bit_irqsave().

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
index f62703cebb77c..4b4c129c09e70 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
@@ -1297,7 +1297,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	if (ctx->state == MFCINST_FINISHING && ctx->ref_queue_cnt == 0)
 		src_ready = false;
 	if (!src_ready || ctx->dst_queue_cnt == 0)
-		clear_work_bit(ctx);
+		clear_work_bit_irqsave(ctx);
 
 	return 0;
 }
-- 
2.43.0



