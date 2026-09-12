Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0284345EB9;
	Sat, 12 Sep 2026 19:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239718; cv=none; b=S+NUiCuOkk5GinogiZV03uxrS6+3pabg5/+bqp5CvI9TdBasS6Gh+/u0Wh8KRIBu8igJxganfZIUYGhYLYXRYH8HokubVTi3pA6RNTpNOYh6qoDtCn8pu0LgF1tisFMvt1gWAvqDKSuW5f+doeecAEGs1M3xrrApBFXKNa6w3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239718; c=relaxed/simple;
	bh=f+KJ9yuQesyhC4BNxBml9umao99m7pQGaHbF1807GgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPGfBH8tIYaaZlf35Jrw2w6uTkRDSJdKlp671/7I7hewYmS+p3vqs+5Jcd39LUfirwE/kBB8wnmMLS89HQYcAzd9LEsqZBknDNIzbgI31y2rb+H65qQzTYX8fRjWsxdmMq+AxxvEalMSPDL2STWRr75m7o0XUtaYAcCHFTL5kQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPHMuz5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPHMuz5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB961F000FF;
	Sat, 12 Sep 2026 19:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239717;
	bh=3zX+UjbLdIvbSdABrx6HZI5ARIZAd5gpm5AZPyT9rm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPHMuz5VffgIGvJnZYKqGqk1yiwxuzaxC2/VJK6P5ygMbY0zY1U2ckbe/S43+eX5p
	 Oe2l+RmXjhanUY3i9gdiBoHtQ9Dg/rsa7BN7zljTOROhtu0Sm1aZEAXu0bmhs9JMy7
	 2SB17ryCDGg2PKcaPPJ1Zyii/OERNVivPiGCZxNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 678/935] perf thread-stack: Fix heap buffer overflow on branch stack wrap copy
Date: Sat, 12 Sep 2026 09:01:48 +0200
Message-ID: <20260912065542.392077759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ab9c84d1cd59e6b3b73de34982a35a76e3a9b032 ]

thread_stack__br_sample() copies the wrap-around portion of the branch
stack ring buffer with:

  nr = min(ts->br_stack_pos, sz);
  memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);

'nr' is correctly bounded to min(br_stack_pos, sz) but the memcpy uses
the unbounded ts->br_stack_pos directly.  When br_stack_pos exceeds
the remaining destination space 'sz', this writes past the destination
buffer.

Use 'nr' (the bounded value) in the memcpy size, matching the pattern
of the first memcpy in the same function.

Fixes: 86d67180b920 ("perf thread-stack: Add branch stack support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread-stack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
index 1b992bbba4e8e..b1766d62eb718 100644
--- a/tools/perf/util/thread-stack.c
+++ b/tools/perf/util/thread-stack.c
@@ -641,7 +641,7 @@ void thread_stack__br_sample(struct thread *thread, int cpu,
 		sz -= nr;
 		be = &dst->entries[nr];
 		nr = min(ts->br_stack_pos, sz);
-		memcpy(be, &src->entries[0], bsz * ts->br_stack_pos);
+		memcpy(be, &src->entries[0], bsz * nr);
 	}
 }
 
-- 
2.53.0



