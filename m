Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907E7DA6C;
	Thu, 15 Aug 2024 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732137; cv=none; b=TC2XkORazrRuGPjUwaFOERgHIC4Yg52HWNEJWatUpqlxZkXFohzfFc0AtRfkgWTwY17I67Rpd90NOwvDhfCR+MV123DiFNM9VLxzIl07rxJBW/RJo3wf1qDkhA64UhZ5xX+twxuv7bDLygeV6m6Tk2bsJjah3f8lvwlsusPXLPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732137; c=relaxed/simple;
	bh=61OaIru0US2jS67VE15cKMeiXqdjkyFhWQH7H6M5TuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnHhPnE5nsGWQMo8FRE0QDl9vRgMlJg82SYX7CzA8rjbJzA6sdMthOoZkM17y5jqjz5Yh6PuAttCvLtPBz7sNIYZFQlQ1Gh1apryx796Zokt09TNNW5OXiUbjAKe13UKqoPgvek+vUgmUBqWvQzShzpesBz0jsf3uaA6q9SsjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVJlj8th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVJlj8th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B970FC32786;
	Thu, 15 Aug 2024 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732137;
	bh=61OaIru0US2jS67VE15cKMeiXqdjkyFhWQH7H6M5TuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVJlj8thpiYCaPUn8DSEmqGboLr3QiA01VR3q7l47srXRDmHJFFL+Nvaq/FfAw8zS
	 dzd/r7y7vfUE4ilWofYTrICQP4e0VhW6aKmk9XzG+sOToW6CvUKzzzUqYokeN40/H6
	 yKOrUelxfcU3M6JngXPHk/K1E6181JxfJVVJJ/6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/352] perf: Fix perf_aux_size() for greater-than 32-bit size
Date: Thu, 15 Aug 2024 15:22:00 +0200
Message-ID: <20240815131921.327446276@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa23ffdaf819f..8e63cc2bd4f7d 100644
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



