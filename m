Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023343D4EE;
	Tue, 21 Jul 2026 22:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671892; cv=none; b=lRbPEDMjNhSV14wIszIZ+lVuMFbC2N0gAsxIiW9AI6BBUrdwN27c0/+ECPWF+XzVJswYcnYqKtAY3S9xvJ8Uzg9Js4XpKtH6+3y+4JepPWSC/M1Hk6RMnbdjDLu+YKjfA2TURsa8oLJNFwV1ggNRvmLRkQpyHSepgK0lQGBxG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671892; c=relaxed/simple;
	bh=YTEmK9TpkDYLYQLjO/HsBOxGM6FiZoMORXlEkrbXXoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d+nLhteuxlTEOFxRV9g14PpkCLhoJ9lS5JYqOFmwj2CsYpuyOdaYLZIBX2+03y+bNd5m0eqU3y6DOSa55s/PM+i1zTyhNVtj6LGXNBonHode8mwjC1MQ/u428WNRT+4qFC/Ivbc4+L7KYZNDiG42xDxTaYtBKkWSgMHD/58YG5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1InXcz0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1InXcz0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871CD1F00A3D;
	Tue, 21 Jul 2026 22:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671891;
	bh=8gM1ZGhEfhCV72KOkLgtuYTBRsv3kflCN7SzWnt6nmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1InXcz0OJjEyhlFkdRjsxfXGIt8tln45jFkHEH1pj/qJSxJ7s4ttOXgJ+ZM8lM7Xo
	 OF7EEh4ojY5dDdvtULab30nHVe4ma1bnCQTRLrEhKNxt1g8qXMsLsvU/2kC++t7cZM
	 3GRe1oM1Ax26e63D6bkkS3SnzTZFs7KN1b/U0QPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/843] perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback
Date: Tue, 21 Jul 2026 17:20:54 +0200
Message-ID: <20260721152415.462313777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a9b6d8a551f2e..7029c71c57780a 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -691,8 +691,13 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



