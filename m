Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCCE1C6F76;
	Tue, 27 Aug 2024 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772163; cv=none; b=lIc+DO9y5Q74l1d1vTPaKZuJ/EUYe//AhZRM62er708YOutCnUPTkr+2h2eDK2yI7CUcXnX2UMcmkIV22BmHmckuIR+3g4NYWk3rP3aIwaNJchH4i1x2xoLDhiqEdPYtLGR1wxSGM8hUDL8sGxB+LAztL3PwaIBwIduXVsrFZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772163; c=relaxed/simple;
	bh=ZKmDLj6VYtqT9a2eLB5MS0yCko8AKToZWI665TNTsew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPtrxkuYKzghWK+NA3Yotk0TTcrh6MSd0BnlLSamH58XdQilbvmBmSEqPYygZVocqtfy6TQUCZdZUNngzNOsi74OLLJOXcYZu4lldYSFFdnPH1FQIvJYJop1bcbeark44sE/KFxGmpFnO6cyuwA/HudpKfmlvZ7bKpNumR43Wuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8zKwnVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8zKwnVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CC7C61042;
	Tue, 27 Aug 2024 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772163;
	bh=ZKmDLj6VYtqT9a2eLB5MS0yCko8AKToZWI665TNTsew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8zKwnVt6sqHMju9CWH68bFOtk5H2gQHilW1Qpp32RqQNRjRAkLJ/cPaYdMALAwS4
	 GrIqdkBH4/QbKnC+ZHOYgzifJchEPvxYw2EW7ct4j0hI++0oaI11CPXTXtdzMFwDkb
	 HfWrabcCupgzSDDqoSi6wUzevgFpTn4zUv8coUAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/321] media: s5p-mfc: Fix potential deadlock on condlock
Date: Tue, 27 Aug 2024 16:37:19 +0200
Message-ID: <20240827143843.230846415@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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



