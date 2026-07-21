Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1D46EF88;
	Tue, 21 Jul 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662505; cv=none; b=e7x9yUCD0++ZH4Jt/JRi8N7ssramPg4KSprZgJ6zkCqBL3m3oxXLy1FBGSYPxr6lc+e2eIhtCiaETSYMTbYSPTuICCknRtEobUqM9UC2XccWTFspGZhHR9MO35tVYpmc6rB4GZawAkw+6+Gmc8ELZT43P8tCKdCPKQpo7PD3X38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662505; c=relaxed/simple;
	bh=+GK8CYdb2I6jfbdT84M51PE0aULtLaOZViMYXQaxajA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTZHqKBVSXrHY+4paLy7ipUSJxbwWib6iMdwNT+L6xsslNcx8KowC9D/mMs7VY6O6z0Aq9NhiQijHqDtslmB47qILQftnpvdmovOhdFwmq6ypO1sLnVVa9Sg9xb0DXB4UBovQ7lkkgDBHdTInpz6fUphJNXf3nl3rtVBhX2NaWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7pPaPBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7pPaPBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B501C1F000E9;
	Tue, 21 Jul 2026 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662504;
	bh=lMaI8EEQNU08F1plnbMA/K7rfZ9sZ4YOxQ9lEnjhQd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7pPaPBw1dTLog89Kq4Hb6I7mfpzATLvFo+7RhYvFFnNIiQU6I/XDXMTk02SpndcZ
	 OwDOFBjRRlogigwG60CgnNuazJZkMwwviSo4Zy9bstdRgDdVbkNuipqrSVLHJCDtMF
	 aYXYnq3LMCpAGokH2hLHRTqNxDQj49lhI5/7HxeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0471/1276] perf sched: Use thread__put() in free_idle_threads()
Date: Tue, 21 Jul 2026 17:15:14 +0200
Message-ID: <20260721152456.646587146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a99d6394cd48fed75b1d24733d5afe6837a61a3f ]

free_idle_threads() calls thread__delete() directly instead of
thread__put(), bypassing the reference counting lifecycle.  Under
REFCNT_CHECKING builds, this leaks the pointer handle since
thread__delete() frees the object without going through the refcount
wrapper.

The idle threads are created via thread__new() (refcount=1) in
get_idle_thread().  Callers get additional references via thread__get()
which they release with thread__put().  free_idle_threads() drops the
base reference — thread__put() is the correct call, matching the
thread__new() acquisition.

Fixes: 49394a2a24c7 ("perf sched timehist: Introduce timehist command")
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
index f3a03be9471aa0..8eb5c880a5b605 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2489,7 +2489,7 @@ static void free_idle_threads(void)
 			if (itr)
 				thread__put(itr->last_thread);
 
-			thread__delete(idle);
+			thread__put(idle);
 		}
 	}
 
-- 
2.53.0



