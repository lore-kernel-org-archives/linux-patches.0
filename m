Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D99D2686BC;
	Tue,  8 Apr 2025 12:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114955; cv=none; b=FzdQsselV2DPFP+XuTBIJW4YgyOsJCDWtrBFPx6wMwWropXwVjCOgCU7lb7KBZPxxOTGMq6hxIZqOd0kA+ci0JKnyuZU8gO+6OVH8LZNHPzDI4ykvXNe+Mr2Yl4biMnIHfWhupDlcRZaq6WEijkmJCf3NvTAaQ0Xn9lZ1vywTeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114955; c=relaxed/simple;
	bh=M567oYxO7T98xYffFIW9+MVjP1f9SPjYNpMM4Jyychw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8lcoDEpFaeq6iz5u9qMimJu+HUqN/ctDAixi7BFN7RIUpy4xUM7yfuqzBe0T+6apEnEWfAHGg4f9GetFF7L1Cdi3ZskB8+oH2AqOMk5gozO7duEnWjJY/Huvv+iW8CizzurGeHFc6b+BLTdC+VwqH7iPv6f5V9XXHWCH/UTrfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHm8XSFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHm8XSFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3B5C4CEE5;
	Tue,  8 Apr 2025 12:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114955;
	bh=M567oYxO7T98xYffFIW9+MVjP1f9SPjYNpMM4Jyychw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHm8XSFdqu5D8i8Sl6YUshGwdKVg346muuQXZJDyr0hYTERmLo3lwAfoT8FT6OhjL
	 HrkJTkUnEb6VY9pypDB79Q+gnshsopSRWyQsgKdW/R4c65yVGJEHHwfrTGTZEVZuao
	 MzjwAm9/G4Z7HMQk/Xg2ws1aN7ySjg4rQV56pJUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 257/499] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:47:49 +0200
Message-ID: <20250408104857.619966265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 3de5a2bf5b4847f7a59a184568f969f8fe05d57f ]

To avoid a leak if we have the python object but then something happens
and we need to return the operation, decrement the offset of the newly
created object.

Fixes: 377f698db12150a1 ("perf python: Add struct evsel into struct pyrf_event")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-5-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 14d7347ac0f38..88404e5c462f6 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1011,6 +1011,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1022,9 +1023,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		/* Consume the even only after we parsed it out. */
 		perf_mmap__consume(&md->core);
 
-		if (err)
+		if (err) {
+			Py_DECREF(pyevent);
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
+		}
+
 		return pyevent;
 	}
 end:
-- 
2.39.5



