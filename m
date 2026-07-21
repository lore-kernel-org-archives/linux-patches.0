Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7E635DA40;
	Tue, 21 Jul 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662640; cv=none; b=bQ308Y3aNLT/dTr3AXTdDyMCAtkz710u8ClaEN7htQJyg48V03XSLCucy4L6KwsLS9oYedpPUPuQwoSjDy7pLqHEewLmP4IG54oaiq3NdVq/Tjo8VCN4sTyWb/kItJiAQ5ENH919KmwDFm7q2/x2jzakrCubhZsbAeR1BW4Mudk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662640; c=relaxed/simple;
	bh=Qe5v9JBSgaAeEtwftXYZjzt9JDOBFtfDox3wq7v/rUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRgj+894z0ylAKy14xUPvpNes7U8pyzWjcVa8bdqZzhtutbEg8CBb3Lg7tYoOOFnS+yO9z3jTwkN6n/jsSiCFZLNKDyuoBvji2zOjlSzB19S/F74qu0Qx+pwuJFthfNVBcOzhehfS4iLOHdBbOWi/lfE9BPrUpTLs9BuxgZIEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtGkjY7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtGkjY7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA111F00A3A;
	Tue, 21 Jul 2026 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662639;
	bh=Skr1qOslZUexRx3ifAZJfzJuDHc5lFyIuEUqYjkpvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtGkjY7OZKvPQ2Vnn+CeEnu2d1pMkyJRYDksOud+8uTl4Yik5KeGWtfGSdMjb2Jb3
	 0SrcaOmCrZI7bQZ68PoxzL2ppRszfTax/ntT7P6AA7CqU61UWPG7g91kEbgMuIM8rh
	 T9HcGCS3GGwiJeWGHd2s4ikArtoDdpKlOsBl8eQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0522/1276] perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback
Date: Tue, 21 Jul 2026 17:16:05 +0200
Message-ID: <20260721152457.797147838@linuxfoundation.org>
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

[ Upstream commit 1b4e9fbdeabc549965e70ac0cd8095d57ff6df06 ]

When sysfs__read_build_id() matches NT_GNU_BUILD_ID with the right
namesz but the name content is not "GNU", it falls back to reading
descsz bytes into the stack buffer bf[BUFSIZ]:

    } else if (read(fd, bf, descsz) != (ssize_t)descsz)

Unlike the else branch which validates namesz + descsz against
sizeof(bf), this path passes descsz directly to read() without any
bounds check.  A crafted sysfs file with a large n_descsz overflows
the 8192-byte stack buffer.

Add a descsz > sizeof(bf) check before the read, breaking out of
the loop on oversized values.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 923e7d1d8aad8a..c7fcbb8fb644c3 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1060,8 +1060,13 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 					err = 0;
 					break;
 				}
-			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
-				break;
+			} else {
+				/* descsz from untrusted file — clamp to buffer */
+				if (descsz > sizeof(bf))
+					break;
+				if (read(fd, bf, descsz) != (ssize_t)descsz)
+					break;
+			}
 		} else {
 			size_t n;
 
-- 
2.53.0



