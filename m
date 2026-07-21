Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9CB3B42EF;
	Tue, 21 Jul 2026 20:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666447; cv=none; b=hjrB8kvXzak3MyorTCFg6AD3Yugd5/AUPLVZ9DUmb2D1H1OC2swPXNhRkq5Um4mQpMTdMqzdaA9B9R0CqBJzmqR8gAOdR5tmkeLjflIYNAwsuErw2gly5+xZuHLK6K5SXWHNcPzJWD2/cG5s/ZvEhxepgVQ8v92XxTUZSE9/tSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666447; c=relaxed/simple;
	bh=5NYxaCfUoPeL+XYLVfkI+Ciz1rP1dt8nvMx1irXB6TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSMFIbT9wMTZ8bHAy755bPmzHB93e1P00XAbEROyfld+8BJFFbi7yakqg512wpKhLx3BUxw5tDA8j43wL7pI5LZ3Meb5+28h1M71X3mpkLhwiT/Pt4aCzfaDx9+V45pwiUFoh9ZACWobCWhKSVZHOttbqEzRJdnkvYF0SHF57+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iqLoEXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iqLoEXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5898A1F000E9;
	Tue, 21 Jul 2026 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666445;
	bh=lEuf9EzqA1af1eN9tX4WtxgrpvN6Srm2poOhNvec+9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iqLoEXZQxiyvq4GKWmbybd+xvtYVL85wl7vvotBHDNw+zzmA1GMaLB8u8THT1fjj
	 w91Xk0IRoe3BbupLO1s2my8BEE7vvlc58CkUC+dm3XuCzKnvartFU1Wxwy87Zzxj4r
	 ofbdwY5szpbAGrO7LJki+/uL7gDAbu5FYf0LsiRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0684/1266] perf symbols: Bounds-check .gnu_debuglink section data
Date: Tue, 21 Jul 2026 17:18:41 +0200
Message-ID: <20260721152457.159419141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9c74f0aab398cb32ab250401f323c0fdc9a3a496 ]

filename__read_debuglink() copies .gnu_debuglink section data into a
caller-provided buffer via:

    strncpy(debuglink, data->d_buf, size);

where size is PATH_MAX.  If the ELF section is smaller than size and
lacks a null terminator, strncpy reads past data->d_buf into adjacent
memory.  A malformed ELF file can trigger this, potentially causing a
segfault or leaking heap data.

Additionally, strncpy does not guarantee null termination when the
source fills the buffer.

Replace with an explicit memcpy bounded by both the output buffer
size and the actual section data size (data->d_size), followed by
explicit null termination.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 0f5f60bc4180bf..83b76e88ed603e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1159,7 +1159,14 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 		goto out_elf_end;
 
 	/* the start of this section is a zero-terminated string */
-	strncpy(debuglink, data->d_buf, size);
+	if (data->d_size > 0) {
+		size_t len = min(size - 1, data->d_size);
+
+		memcpy(debuglink, data->d_buf, len);
+		debuglink[len] = '\0';
+	} else {
+		debuglink[0] = '\0';
+	}
 
 	err = 0;
 
-- 
2.53.0



