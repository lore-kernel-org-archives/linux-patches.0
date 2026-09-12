Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492162DF156;
	Sat, 12 Sep 2026 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218430; cv=none; b=uNWnOB3MSovxYdAfQH57bhYyoHFBrNm+zBw/e/abX7Vy/cnMibZEL0BX9vRcu0tAB+0Vgqa8FS9GanYfIdsMPuR5lQ6XmRq/k72RFhhjxzkwUPJq7CbKJOhK98/IwPsnZwG/n/NbIVwFMaEK6XzG6deL8n/xR/Be5jNpKMv+PVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218430; c=relaxed/simple;
	bh=iIdOwcLmZmM/cIWsBuyXJg7Fgn2BdWScs+8vuRrhh1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvEVQbg3+tY2lSPPXm6bsHAYq0cwse1N8pDYqd1B8kiL6uHCrb2r2hrN9iUv+LFU4891Jyc8FvkWK0YlO/xf8SvsWkEAXPFAZOi63IWy3EXxdiEAmgQC9RZ023FGAjit1dAoVQGHuTS3I9yVDBqrhxYqBd2PGmzK4hX6y27cJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFX+nGxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFX+nGxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0E21F000FF;
	Sat, 12 Sep 2026 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218428;
	bh=m211MQ792qK8QOVeru3Sh7HBxfx+I7MWK4ovo8fSlas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AFX+nGxgdJfUfGs9zqHGs1XkUZOIzcGvcQeYZjlGfD9pmxjWH+TYsNmpchq38W+rc
	 Cp6HTOHJzF48UxwWric+8rW6RD0ShTAcThkx+pwOlNxeY3LdkHSN5PUy0Jh9C4KNX3
	 /arlXAd/UpfXsk1QupJxQe1s/E8Ct5s7LLfkyG3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1142/1376] perf dso: Guard against cache underflow on short reads in dso_cache__memcpy()
Date: Sat, 12 Sep 2026 08:59:28 +0200
Message-ID: <20260912065633.009436111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 266f3b0a3a54b..9de78061a3f26 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -939,7 +939,20 @@ static ssize_t dso_cache__memcpy(struct dso_cache *cache, u64 offset, u8 *data,
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



