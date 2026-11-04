Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829503;
	b=ut1X11vMPE59A48zGirg5Jt8UPaRwZ/x1JiXDbDyuTA0Lp8nc+1mTOZf1yel+Kef2IIb
	 q9EQzVxMjAuB5r9zhpgPkIbQwwlxKeSd4scoxH6iMxni1H8yYyjshz3U++SX56uuOd0i8
	 UUmfdHsjvOSc/TmusGX45elqlMZIn1OFqRTpm3V4jKv/g89W9XUK0S45Re5poy5mJfujr
	 f7jO+kqyLUuH4dHhkpkMFkVwhbNkBOMxusSBSYtHceBGGDmT4dWOjmw0g4uD09WMtjPg6
	 m506/GwXfqZo0sobQw2Zdgmh3jKJWskQbfnJA1hmtu82ub/UzneRpqLJnG3cQGteqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4iOC6zPIY0V6OfUe1SQBE44qXIjtBa/luGKoSx7cWw=;
	b=SWGfD2iem/21x2Jxhs1sR6SaqFgdLdSmdf3E9dInsLY0Si3ryM+gMSDzUKW2fpPxUefe
	 XR3t1DfXCNkvzWZBPxx0PNtFFYXjoBzSBaebpeBOuRJNwRKwyA7AoaWnHe9ozAQ4GrETm
	 /jTIKajkHjYofD5KivC0t/jfFkVQOa+4Hz1KcPd5ph5FW8ofiLf0wptOs2EsR67lO3t5r
	 igGdey8J9YiEcz/hN79CLzsAhZRNJQoO5KwYwUvoTeNR6+0RlszSiBKyTyZqVR434iQQE
	 C+3lFGOgjNmwUR08yQAl0iRzYUdHQwITHCqtuQz9/pEc+IVM2DYs42rDdY9QL034VIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dojSIA8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406BC606A844;
	Wed,  4 Nov 2026 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dojSIA8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53FB1F000C1;
	Wed,  4 Nov 2026 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829503;
	bh=B4iOC6zPIY0V6OfUe1SQBE44qXIjtBa/luGKoSx7cWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dojSIA8xvTfckIwYij0pNg3P9SH5JsyQKNwSRxenyhGUMxKvImEeOpKTOFaRt8OGU
	 wNWkHuZYurQaVrl6Zt3sX+vQioGZdoxtYX5M/NENQ8RdApIOeaHU9eDW5Wzpf/bkK6
	 wwJkvt7x9DTeaJw/EM0gtAm4wlhUZnDIdd1CDLTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0165/1005] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Wed,  4 Nov 2026 15:58:18 -0500
Message-ID: <20261104211048.385177430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index f0f195207fca9..dcb396ab51eb1 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0



