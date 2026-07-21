Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF0B3B1EFC;
	Tue, 21 Jul 2026 20:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666454; cv=none; b=mwo0vQsG4Y8V1+g8NX1s8cvboO+sXgwniUdBeIuYDlQssEMJkX5SMh2G8rLw7Z6gjPLfBCU2ZJ5CGwiL9Tm3pZFfBrPWg2ZV9TmJ+bedYM6leCS5l+8yfrq7zDYymzCDEVH3u58CDj4eDFWy7GcrFRGYzQxHrtCAhbj4U5AeaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666454; c=relaxed/simple;
	bh=1piupUUrDQsOFzhKXdd2hZ1Ff6jIPEGdFH2qeruWtCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kU82SC9eqLCvlB+ZNWUJ3+YFJn01e4CO9UZpuauaVGnCSzTOoY/e4NtqTRV1JChMyyFTo+25Hzr9WiGRkFi+btYyGtGxVMwIG798vawh6+1FwClF5l7DeZqBPkm3vng7eG9heFfLWgBsN5Lq+q57HROge8YiFFrb0wqxNe+Ek6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1H7Vo5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1H7Vo5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6CE1F00A3A;
	Tue, 21 Jul 2026 20:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666453;
	bh=wNsrfIZi5kDgcqmlxJUMlRZYNJk9u6iT4QsKH6Hnr8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1H7Vo5cDvZrvkYUJLxp+vBOtCnfSrQfGyRz/phxH++n5fU6FkYGCEc3x30GHxUVp
	 wH93reFPgbJKEB1Eu2Uz6HV71Dt5/tSVlYhl8q4x75MiYcc2vIZa4MiH4c9bjV3Zeo
	 zjLdqMPqoeY+OSYFmw+LgnUUURk2PnRsY2wYCJw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0687/1266] perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback
Date: Tue, 21 Jul 2026 17:18:44 +0200
Message-ID: <20260721152457.225095454@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83b76e88ed603e..4a2fb6e3d4ef38 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1059,8 +1059,13 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



