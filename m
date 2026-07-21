Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D9D46C4BC;
	Tue, 21 Jul 2026 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660348; cv=none; b=XrB3lYPfcKtxBF+Z9fqRjrhG/U7EKwUTNIh700c+e4XBFm9jr3GtZobiomBBUyMR/PkOmpvNXLS6169KXiWecayoD3UqBMCz2Bmhv8ekOku97QWJFnDDDjqhp2rn0EmFpG16Z2zm6tb/HipbWqLc4Mmhyh55WIDHQJxVypCtBtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660348; c=relaxed/simple;
	bh=dKSy1TVC0LzjwWfLApvY47Y5/BmGYAHz2Cmymqx8pLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XArt32f1IpaQuvSww7Fi6x6filuCAPD91cVfQfQD/MnbLKo///LwhInr0lQH40nBRzjM+8uAOfsVDVWDQLxjRg+76OKwbfNdruOGinB/N7DJGPRDa8GMKM0uCKWxk2dp2KhESeOCFzuk4yKqW9t8EFBUFJa8q+lqgwYmQ43yA/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWds/+wQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWds/+wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD451F00A3A;
	Tue, 21 Jul 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660345;
	bh=8mtYq7HGSZepy+BgoerW2FBEzFErvvyIOG3aRYzicnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWds/+wQR7U0XBAx7T9BV3/G7wi/iIv0NLM/YqMjIwiElBcLFuBOoafUjgu+g4aND
	 MWrl8uUMzNBSHYdsH7PHupgJfdbX/fEuGXFaUKxn0arGIOcrMXF06+WlqtilWXPBBm
	 pGHhs4Xwp0tt1QWEl41ADZsCUx8gSNlj5KeaQBwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0945/2077] perf sched: Fix thread reference leak in idle hist processing
Date: Tue, 21 Jul 2026 17:10:18 +0200
Message-ID: <20260721152615.108053623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 662d56d48e527ee21a0b03082ee318258a6f7919 ]

timehist_sched_change_event() sets itr->last_thread to NULL at the end
of idle hist processing without calling thread__put() first.  The
thread reference was acquired via thread__get() in timehist_get_thread()
(line 2581), so every idle context switch leaks a thread reference when
--idle-hist is active.

Use thread__zput() to properly release the reference before clearing
the pointer.

Fixes: 5d8f17fb5822 ("perf sched timehist: Add -I/--idle-hist option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9ea3416f30ac6d..7222fe428e7fa7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2942,7 +2942,7 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
 			if (itr->cursor.nr)
 				callchain_append(&itr->callchain, &itr->cursor, t - tprev);
 
-			itr->last_thread = NULL;
+			thread__zput(itr->last_thread);
 		}
 
 		if (!sched->summary_only)
-- 
2.53.0



