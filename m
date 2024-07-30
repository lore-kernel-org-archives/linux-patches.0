Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77641A6195;
	Tue, 30 Jul 2024 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357206; cv=none; b=KZKP+fmbt0S5AmL0B9hbi3oiqWCu7iXQDSuglxr0rJrdyia4sByG/t6VZdAHjrJwJ5sTa/LaCsU/KhoTvUnKuAD08mROAxxdEli6Npw19XP3U1FsynJURJE7c/fD7Qiv+uiuhKKiBfAJwGSqJqXboaGylS4AzvVI/nCTxR3vLB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357206; c=relaxed/simple;
	bh=nO0oqTKwu3YIwxEjdAkFz9eg6CwbYjeP2He3iX5WPyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kf53muhu/zwUZ20BTl8KcMF2r1pg4uWxinBbPpJctoEbUpRnsYZjQ0iM7l6KTUMYSpL3F0LOdfegoPkWyV9+Kfmw7P/ene6ZA78gnxWinLkgTt6cYGg3Y82NwzY8x7owGfyZ0QIcbqsd4/752fIl+Wo12+h4pmhJhCZQiW6hQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9NDiIil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9NDiIil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E89C32782;
	Tue, 30 Jul 2024 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357206;
	bh=nO0oqTKwu3YIwxEjdAkFz9eg6CwbYjeP2He3iX5WPyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9NDiIiliVkJZEJtHfmbq9FaMvuk2wuJMN6i7b80lmBnhOOE/OZfJ/OFCkYxQBOUH
	 /Lrb0+nGYJWKlwJFa9Vt1ImPWbUkQ+uZQ7JuvMvLA1It27yESD9/9JDsorD83UPDmm
	 C+MxRv4omVEVeJVZtKQqn18ABFVmaP9jkMGZiAfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 223/809] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Tue, 30 Jul 2024 17:41:39 +0200
Message-ID: <20240730151733.417989059@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 3df94a5b1078dfe2b0c03f027d018800faf44c82 ]

perf_buffer->aux_nr_pages uses a 32-bit type, so a cast is needed to
calculate a 64-bit size.

Fixes: 45bfb2e50471 ("perf: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-5-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 5150d5f84c033..386d21c7edfa0 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -128,7 +128,7 @@ static inline unsigned long perf_data_size(struct perf_buffer *rb)
 
 static inline unsigned long perf_aux_size(struct perf_buffer *rb)
 {
-	return rb->aux_nr_pages << PAGE_SHIFT;
+	return (unsigned long)rb->aux_nr_pages << PAGE_SHIFT;
 }
 
 #define __DEFINE_OUTPUT_COPY_BODY(advance_buf, memcpy_func, ...)	\
-- 
2.43.0



rt_streaming(struct vb2_queue *q, unsigned int count)
 	dev_dbg(ctx->mxc_jpeg->dev, "Start streaming ctx=%p", ctx);
 	q_data->sequence = 0;
 
+	if (V4L2_TYPE_IS_CAPTURE(q->type))
+		ctx->need_initial_source_change_evt = false;
+
 	ret = pm_runtime_resume_and_get(ctx->mxc_jpeg->dev);
 	if (ret < 0) {
 		dev_err(ctx->mxc_jpeg->dev, "Failed to power up jpeg\n");
-- 
2.43.0



