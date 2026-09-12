Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93D3AFD15;
	Sat, 12 Sep 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203758; cv=none; b=Ds2FN/gZ4x1qj8dy0JhCXS4CMKcR8JhnFKTZzFVC8C1vPgT3nim1Spa7fQa71mJZMT3knN0T7r3tonhLCfNY8nsb3tJW6AsWbCpYDW8jzlBRDD32lQ+h3vBHSKFhCLE2oSrQqO96GtvXrfVRNew2+5Z50IV8O4TEC+llcoX09us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203758; c=relaxed/simple;
	bh=o7O9IorgzD7uAFQrGUfaZCKyqopS8nRpUl2/o7ZqoKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zn3f9aanIdBQfDoUjS5zkrRFB+ojjKpuZb0HHr/B+tM9JPnBG7J/sWr6q2Wag65NmaP2Ue2d0Ax6E3b9G0Q444irtsZnBQ10GYL5nCkW/EeGODEH9q0Y8gWpJoV0ufk9RrO4dv7cgwR5ODgsmBALeyKA4V7xXORte9NO5m6aNmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukLAItxF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukLAItxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537C81F000FF;
	Sat, 12 Sep 2026 09:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203757;
	bh=5I39VWYSWqSupmZrOuJrhreDzu+f/6TeskLfZZ2aZlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukLAItxF6GCJe0ahF0MUdOp0VKgZMj8AzQ9XmcRaWmfbowXseUEH6c8amx1z3CSuq
	 gEiEvIODBBEdPZCEP/iFl6jNjrxL8mG7QySZne9AmzfQRPTgd0t4thMGBrkojGXxO3
	 3OTE828mD4acBov0QCpnB0qOBGAr0OEa+EbLIX10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1474/1815] perf dso: Guard against cache underflow on short reads in dso_cache__memcpy()
Date: Sat, 12 Sep 2026 08:53:44 +0200
Message-ID: <20260912065723.612865973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 390a9461cd73bdd13acc0f6d763618ae1ff8fa17 ]

dso_cache__memcpy() computes cache_offset = offset - cache->offset,
then cache_size = min(cache->size - cache_offset, size).  The RB tree
lookup in __dso_cache__find() matches using the full
DSO__DATA_CACHE_SIZE window, but cache->size reflects the actual pread
return value from dso_cache__populate().

A short pread (e.g. near end-of-file) makes cache->size smaller than
DSO__DATA_CACHE_SIZE.  If a subsequent access targets an offset past
cache->offset + cache->size but within the DSO__DATA_CACHE_SIZE
window, the cache entry is found but cache_offset exceeds cache->size.
Since both are u64, the subtraction cache->size - cache_offset wraps
to a large value, min() selects the caller's size, and memcpy reads
out of bounds.

Return 0 for an offset past the valid cached data.  For a regular
file a short pread only happens at end-of-file, so 0 is what a direct
pread() at that offset would return: cached_io() stops its read loop
as on EOF.  Re-reading from the backing file would not help — a
second pread at the same offset returns the same short count.

Fixes: 366df72657e0 ("perf dso: Refactor dso_cache__read()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 60aa77f797851..4dd64069c4348 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1014,7 +1014,20 @@ static ssize_t dso_cache__memcpy(struct dso_cache *cache, u64 offset, u8 *data,
 				 u64 size, bool out)
 {
 	u64 cache_offset = offset - cache->offset;
-	u64 cache_size   = min(cache->size - cache_offset, size);
+	u64 cache_size;
+
+	/*
+	 * The RB tree matches using DSO__DATA_CACHE_SIZE, but a short
+	 * pread may leave cache->size smaller.  For a regular file a
+	 * short pread only happens at end-of-file, so an offset past
+	 * the valid data is EOF: return 0, matching what a direct
+	 * pread() at that offset would return, and cached_io() then
+	 * stops its read loop.
+	 */
+	if (cache_offset >= cache->size)
+		return 0;
+
+	cache_size = min(cache->size - cache_offset, size);
 
 	if (out)
 		memcpy(data, cache->data + cache_offset, cache_size);
-- 
2.53.0



