Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B692E2F12;
	Tue, 15 Jul 2025 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585801; cv=none; b=D2Z2L9njCkqZMsFfOh2P+uj9A3zlubBvW96uCnv5ylo+P9+mBCHUZ+VE6f8GvRbBkV2Hd8tiR8eA8BeYvGvrC+NiEjP+xLGMGgktVcuEr8L1l+75EN3wjKwyRoWc2SFQ9voj3R8uvgk2T1okoM0UUqac40dp3GW+nB21QqiVefA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585801; c=relaxed/simple;
	bh=4tG8BeZJRwgc4srZfG2aBSDD6KCiTFGErMaEPLWniZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUWMO5RYPYHrMcFsqsQoPleNEYdOOQk+3Y0JzLn1Iudp00zX1lhk2LN/ca9tcMxcIEBley7OewYKsjEuuKp9ZrHkHny1mTpX2q2TtbqX6y3YtXHIZ9mCfQ44+0ltQziwnIi00Q76BX9+vJVNlxERuKcPBAiDS6zDPlxLk/HFwU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsXlqFLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsXlqFLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB3C4CEF1;
	Tue, 15 Jul 2025 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585801;
	bh=4tG8BeZJRwgc4srZfG2aBSDD6KCiTFGErMaEPLWniZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsXlqFLxNZsaKHOpa341zch3IgSKeo9q35JfYxAGDDMmtpfbUvuhH2PQo2JXZWtLH
	 d7CjeSHWRLVHyNJEK96CmKxfoCA8q0ZipNxNcHvYbYHtjCgjUfVLJc/aO2wNFadi1M
	 R3SXstEKVqbZql7MeJm8oJ1qnmBsU4Q1owM787aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/109] perf: Revert to requiring CAP_SYS_ADMIN for uprobes
Date: Tue, 15 Jul 2025 15:12:21 +0200
Message-ID: <20250715130759.090232478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ba677dbe77af5ffe6204e0f3f547f3ba059c6302 ]

Jann reports that uprobes can be used destructively when used in the
middle of an instruction. The kernel only verifies there is a valid
instruction at the requested offset, but due to variable instruction
length cannot determine if this is an instruction as seen by the
intended execution stream.

Additionally, Mark Rutland notes that on architectures that mix data
in the text segment (like arm64), a similar things can be done if the
data word is 'mistaken' for an instruction.

As such, require CAP_SYS_ADMIN for uprobes.

Fixes: c9e0924e5c2b ("perf/core: open access to probes for CAP_PERFMON privileged process")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5c6da8bd03b10..3a33d9c1b1b2b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10473,7 +10473,7 @@ static int perf_uprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_uprobe.type)
 		return -ENOENT;
 
-	if (!perfmon_capable())
+	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	/*
-- 
2.39.5



