Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E5D2CA9;
	Tue, 12 Aug 2025 18:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024397; cv=none; b=G+3bEs4Ga7VX6un2DyHeJpfAUq+XCfnqpBMmoJuSd8xPR1L1UWFUxxP+RqoMa5AF4oH8DAuAplh/mbruxNYxEehwon6EHitXr9i5cV7CkKwhmv+EYHPj//f2K3tONFqb0eQ6yv3GfG/Zg2b7IZQFiiuxr4u+o9ytEuDNvBWq3og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024397; c=relaxed/simple;
	bh=x3LmZTwpm12jzBZ3aQpXc956aQyqQ9moOvMUttc5ON0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsrpIeH9ek2WYyNBXgpu4y1rvl3s87V2zyDXYhLWh3gysLF1zD4ZBsWXR4ZmJPJzbeasOwWlrKtnRvetogX6MZY+PNAaBQv0Didpqevye+45hfwV88wiGxYicYf6dLKqj3oxE7EaLM9FIlzt5J/L/raUBjaDBCMYHBqj63lNpK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJUT4E1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJUT4E1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181EFC4CEF0;
	Tue, 12 Aug 2025 18:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024397;
	bh=x3LmZTwpm12jzBZ3aQpXc956aQyqQ9moOvMUttc5ON0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJUT4E1RLAOaeD6r45UeKBZyo7982JkCWvBV3wHJ0I9hc/Uw4hLAe9M8zJfTyQbtm
	 l+m863BeRCMUUOaPzkbXmZzxBg2t6PSJwyaYQpsYErEW2oLZD21UOHE/AZckG/5Pz9
	 fF6Y9L8miydVoJy6oAtzWpoYDYiMqpRXjK0RjCGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 362/627] perf sched: Use RC_CHK_EQUAL() to compare pointers
Date: Tue, 12 Aug 2025 19:30:57 +0200
Message-ID: <20250812173433.062136598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



