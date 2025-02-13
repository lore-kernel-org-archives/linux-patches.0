Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED0226B091;
	Thu, 13 Feb 2025 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459786; cv=none; b=ixMpmXzPF4QHDPvY8oZN/QNf1/JTlvOlG77FgzUADxK3czrUEewe1sxgWXQlwrdyI7CbpscC+zHBsz+AW/F6+nyQc1xKFVwUaJV/64iwNEPjQaQ0cNUQ0T55YTX0ev3isoajX3O6eZI33uwwu4iHHxUD6qr9XkvaOqgvEpXKRNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459786; c=relaxed/simple;
	bh=Lgi2AXcQIGBCe3Gzz3B9eMFTFDbJK/+n7YaL/fG6xDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDXxeQuWVoskPebf2lge1bc6j1tQdEYQP4yjC0kt1sLMPji/Yn2FOFovI8/7/7AZjlFZX/6t0IB7Bg6Ju6gonldSBZX0at6P6H1E0XVf4hNwqGTLhkQRRsWqy2cgskOUfLzx7unVQ1bhj9q325ytCCi6AxfqV2NuAkGMfzFI06s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/3IRaYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/3IRaYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D5C4CED1;
	Thu, 13 Feb 2025 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459786;
	bh=Lgi2AXcQIGBCe3Gzz3B9eMFTFDbJK/+n7YaL/fG6xDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/3IRaYW2rogdJu7YDvA12tKnLeGH+73zs7/QA37oM7q7Id6pCziw5lIRQ2TrzZ6f
	 iqo2FzsU8gIY6xh9lZcbNRjC3/R9AglLO4KChfApQF7t6PVKg2RFMLTy3WXalFkHX4
	 xezRPw1Jhr8ccuasHZfNl9ZaCSiL0VHlqfiQQpVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Hebert <nhebert@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 364/443] media: venus: destroy hfi session after m2m_ctx release
Date: Thu, 13 Feb 2025 15:28:49 +0100
Message-ID: <20250213142454.657260680@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit df4ff47448fe0d392b29868e8398e3b0e587514d upstream.

This partially reverts commit that made hfi_session_destroy()
the first step of vdec/venc close().  The reason being is a
regression report when, supposedly, encode/decoder is closed
with still active streaming (no ->stop_streaming() call before
close()) and pending pkts, so isr_thread cannot find instance
and fails to process those pending pkts.  This was the idea
behind the original patch - make it impossible to use instance
under destruction, because this is racy, but apparently there
are uses cases that depend on that unsafe pattern.  Return to
the old (unsafe) behaviour for the time being (until a better
fix is found).

Fixes: 45b1a1b348ec ("media: venus: sync with threaded IRQ during inst destruction")
Cc: stable@vger.kernel.org
Reported-by: Nathan Hebert <nhebert@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 2d27c5167246..807487a1f536 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -506,18 +506,14 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 void venus_close_common(struct venus_inst *inst)
 {
 	/*
-	 * First, remove the inst from the ->instances list, so that
-	 * to_instance() will return NULL.
-	 */
-	hfi_session_destroy(inst);
-	/*
-	 * Second, make sure we don't have IRQ/IRQ-thread currently running
+	 * Make sure we don't have IRQ/IRQ-thread currently running
 	 * or pending execution, which would race with the inst destruction.
 	 */
 	synchronize_irq(inst->core->irq);
 
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
+	hfi_session_destroy(inst);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
-- 
2.48.1



