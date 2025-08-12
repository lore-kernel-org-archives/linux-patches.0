Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637B72D8363;
	Tue, 12 Aug 2025 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022641; cv=none; b=TfpvN96gQhHi35x8w+NXvlht/QyE5RgZp6Fw8d/zFBHjkkD5+IUlcfFai3AMd+siiWVFAdi/Nw0WTrCSxjK6bj58B1vaR3zFfE4hvHDaeanqKPasii96K7yfkDIVRfnXxXRhhNQbr/ZLofEmyzmGYexa4JyD7KsqI4aTQFFXABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022641; c=relaxed/simple;
	bh=0Lu8Ye09aw7r5XnC9vyzWgmQyJ5L1Jc4+PnkVE+yGqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbcO17F/jxQDfcQQxB8oqdnj46av4Gwinb6BBugIZtA8WTW397PmzmDxEGh/48GrLFvD1/L1EOp3k6B+vlROD0XyF0vIqcCEtl0Km7PrB7UO2V3325XM9gQKIf+nB3ArvmOPr+RwO5eswXkaM6b84di3AJSQo1ZUuOzvl8MsEDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVXp0LCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVXp0LCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56EAC4CEF0;
	Tue, 12 Aug 2025 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022641;
	bh=0Lu8Ye09aw7r5XnC9vyzWgmQyJ5L1Jc4+PnkVE+yGqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVXp0LCh9EEhnnBdeO9mb9gkfjZgDcF1RIbccD/qEtj9gjNpa/jz1FBAhytxwhs4+
	 6mEtLqqBXnFXYuMfznxeeweQJAF6sBPnBIOEfoeRHUzaGp1kN2ZvauwcQTAw4xWNJ1
	 lkgM9zc5Zaz/+Z7TI+mm5ELGMk5oVYuUt72278Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/369] perf sched: Use RC_CHK_EQUAL() to compare pointers
Date: Tue, 12 Aug 2025 19:27:59 +0200
Message-ID: <20250812173021.617601213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 686747ae4cad..6e9c22c1c29d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -999,7 +999,7 @@ thread_atoms_search(struct rb_root_cached *root, struct thread *thread,
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



