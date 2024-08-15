Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689119E7EF;
	Thu, 15 Aug 2024 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729444; cv=none; b=g5DeDP8SBKHYOkCtKtSt+MzALxSOWQ9r5gxVJjEfEVJBqrvLgIffvp0kuQ4LPSSNzfnwVYmx0dQ6zsgiMU/grvTgtBycqJHZ3KRM/c+BowvPyv9uOR9uxb8Efd1mO80VLR2XmycLi0f0Mfb9yDPoy3o0ZamB8Fr+aRubaZ0XSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729444; c=relaxed/simple;
	bh=layV2i5BZBXuI/A6bsstaNSZZUwB+zJeYEVxCmPXizo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0AtOoP2QmOlywT2Bq/pYo+NhjNButsxn3JNc/LJJu7v479ltcW7KoxJbzfaxq3QIUFkfCG2l1rAH+3NCHym8HJ14fCioj8DnyYLPrNZQpL2o6qCkpx0MdTealqvOhQlBU03eG9EYin5lUmjNJbKEgshIFsgHkFsiZzLWq5j3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4aL0fYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4aL0fYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B8DC4AF0D;
	Thu, 15 Aug 2024 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729443;
	bh=layV2i5BZBXuI/A6bsstaNSZZUwB+zJeYEVxCmPXizo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4aL0fYFo965KRt3VAeNWjcQfpzFlBOZCLl456UD9h24alUJHwPDMt3aiPsV2tecq
	 nkmbSm52xW1qHlh+0gWUqDSCamkXkaaaL3LWVekvl1qCbVH51Hhhru07Jl99a6LILi
	 NnXuuabSjAk3u/XQoCmijmrUhs+P9hT7CBt5PRYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/484] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Thu, 15 Aug 2024 15:18:46 +0200
Message-ID: <20240815131943.911587817@linuxfoundation.org>
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



