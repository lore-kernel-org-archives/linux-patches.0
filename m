Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3357A305E2D;
	Tue, 12 Aug 2025 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026300; cv=none; b=NIZK+aw0dIiWr/K0uojp5gQUmG4kaLeijuErkaxDFXbPK+FAZxHNcQZkIT5XxukMcBFQul2OVmXZ3JyI1ctT/sdCRf+9YfROWzu5rG0Un6pIAb444io7T0LMNN+OWKiq6AJhymJkzSLAS8HNzSfVnqdtPxTBuBUZ3v+FxtY7qik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026300; c=relaxed/simple;
	bh=6eY/4UnxAuq8BZEu/GiegN8C0jckrrh+z61Pv8+9dv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuBaFQ1aEWS8WpKh0JnCi9monzAvhEa6JKCETaPCcRO1icBUOHwg9pj/+K4md7d6+gAN+JIZUM/Wkp3wOCuzA4C2yQ1rzRGXyxR7be0Dt2HtbD1KJ9LcrVk8NO/9QzKkPnNWSrtJQs4we6Ujut65A+Bt5M3NJyZuo939wAMONM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cp3tAOVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cp3tAOVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BBFC4CEF0;
	Tue, 12 Aug 2025 19:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026300;
	bh=6eY/4UnxAuq8BZEu/GiegN8C0jckrrh+z61Pv8+9dv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cp3tAOVlIfoldhEDWT5z1oS4hTnfuNAvkZZxjSYsN+T6ZEJg1TwnFc9L7XyxLPIw1
	 BcuZigwTePIyIroB9HqpQGjSaJ7tBQFIt/gZFW4yIBeIcBuLDfJU8lsNW3Tckd46LN
	 JlBrTSDgy76vRBnXD1gUqzMm3ZofS80CBcDwkpu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 263/480] perf sched: Use RC_CHK_EQUAL() to compare pointers
Date: Tue, 12 Aug 2025 19:47:51 +0200
Message-ID: <20250812174408.287858194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7a4002ec9e0fced907179da94f67c3082d7b4162 ]

So that it can check two pointers to the same object properly when
REFCNT_CHECKING is on.

Fixes: 78c32f4cb12f9430 ("libperf rc_check: Add RC_CHK_EQUAL")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-7-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a6eb0462dd5b..087d4eaba5f7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -994,7 +994,7 @@ thread_atoms_search(struct rb_root_cached *root, struct thread *thread,
 		else if (cmp < 0)
 			node = node->rb_right;
 		else {
-			BUG_ON(thread != atoms->thread);
+			BUG_ON(!RC_CHK_EQUAL(thread, atoms->thread));
 			return atoms;
 		}
 	}
-- 
2.39.5



