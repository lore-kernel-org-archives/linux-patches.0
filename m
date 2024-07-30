Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051DF1A6160;
	Tue, 30 Jul 2024 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356439; cv=none; b=M1m5wvQjTxvo328zHykiiXmI5hS5qVY1azsN3dSUCmy+lxN90mQB1AyZiuw+rhbb5NOgiVYdHehwaczdL3OrNIc+zpJodYxf7cfKJiwV8WKtwuesywpGDANDbJv6QGvhL4diq5O8aaKAB4GnrPfS00gIwiAUTAKkk5y5sGBBFfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356439; c=relaxed/simple;
	bh=1ZDErPhICpY4Lew8Ck9rO4e1hDenn88Xo+R7nPFIfXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3FirOmaqe60qhYcGhBv1UoB79GZvPTQLqUWHnPc0As79zdMlXXkDgwXCTW3qCvpGMjuDEegQk5STM8OpxVOtQKqIlpe0JHQaU5x+yZnH8DPqQo2XxycyG8ECtqJw9c/Cma7W63KWqD6A6sdG10zC1rytWfG00jtWC+YYNBzeyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQcEGtIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQcEGtIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AECC32782;
	Tue, 30 Jul 2024 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356438;
	bh=1ZDErPhICpY4Lew8Ck9rO4e1hDenn88Xo+R7nPFIfXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQcEGtIrsEvVZuaZCkKICYhWbZHW+/8isth7aXJCpsvRoNA9tQf3NXW0pAcZvniuD
	 P36zkec7c4FPm84Gte9Ifc+jOGxHOwXUgEJ/s5CjPWmqU4NucnSLrDu6O3VGqJB1Ph
	 W54V3PfD4WR3++mcekOn9YCgPx8dWBwrasGmmTWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/568] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Tue, 30 Jul 2024 17:44:15 +0200
Message-ID: <20240730151645.661268145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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



