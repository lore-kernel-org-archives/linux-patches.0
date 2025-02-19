Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE8C1EA7DA;
	Wed, 19 Feb 2025 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956971; cv=none; b=GJ+6Y76PI1qOqLmo6LjhOQ8+5ibxzfiapiJUQoJQuFI0QY5AN9S6i0kzNEreiVgU7NWfN6TkQks4yBPAXBzTO/b5WaWU7xkzDBvshuaNS/n5iaNZJgCAtF6vGPd2Un55RGkfsB/7zZJuECg/O+/iZNg1ziNhSApVNFG3WlgCZGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956971; c=relaxed/simple;
	bh=FU64sOC9gfmrhw4pMkfPu/48o62cJvtz3O9/mZcpRbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSA3LyHi6Cl7kDTszdtUC6E1qLK4xhmtiX074j+OCVy4j9smCopvtsvUEKoPn+cUw6wD01w+/ePSEQ8st4b1k166sTgq+BB2KHVKgZ8D0SXqzftZtElzbeQ1+4EefmZbvv/HyEcAI/YQO/7swT/S34bWOzmCB/rziIqVWs2t06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZQvCgGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZQvCgGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D6C4CED1;
	Wed, 19 Feb 2025 09:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956970;
	bh=FU64sOC9gfmrhw4pMkfPu/48o62cJvtz3O9/mZcpRbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZQvCgGxyfbQ982ACE5BE9XpHO7umDtkHkayHcxmOI/xiIc3kcOoWsabvba1htjEV
	 qYmLcHxBSdxN3PioD/Oj6LLQdR8ODnpO5r87ez7OwkXlSRr7o+h9Z4LiIUchTIBTO5
	 JVUogpmX6ckSQdKVF9tAe6Vy5kQPRrFkAPQFuCvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.1 364/578] perf bench: Fix undefined behavior in cmpworker()
Date: Wed, 19 Feb 2025 09:26:08 +0100
Message-ID: <20250219082707.338091795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 62892e77b8a64b9dc0e1da75980aa145347b6820 upstream.

The comparison function cmpworker() violates the C standard's
requirements for qsort() comparison functions, which mandate symmetry
and transitivity:

Symmetry: If x < y, then y > x.
Transitivity: If x < y and y < z, then x < z.

In its current implementation, cmpworker() incorrectly returns 0 when
w1->tid < w2->tid, which breaks both symmetry and transitivity. This
violation causes undefined behavior, potentially leading to issues such
as memory corruption in glibc [1].

Fix the issue by returning -1 when w1->tid < w2->tid, ensuring
compliance with the C standard and preventing undefined behavior.

Link: https://www.qualys.com/2024/01/30/qsort.txt [1]
Fixes: 121dd9ea0116 ("perf bench: Add epoll parallel epoll_wait benchmark")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250116110842.4087530-1-visitorckw@gmail.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/bench/epoll-wait.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/perf/bench/epoll-wait.c
+++ b/tools/perf/bench/epoll-wait.c
@@ -420,7 +420,12 @@ static int cmpworker(const void *p1, con
 
 	struct worker *w1 = (struct worker *) p1;
 	struct worker *w2 = (struct worker *) p2;
-	return w1->tid > w2->tid;
+
+	if (w1->tid > w2->tid)
+		return 1;
+	if (w1->tid < w2->tid)
+		return -1;
+	return 0;
 }
 
 int bench_epoll_wait(int argc, const char **argv)


