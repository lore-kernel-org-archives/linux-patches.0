Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363343C1400;
	Tue, 21 Jul 2026 22:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673892; cv=none; b=SlH18YCBDPTbTvK1G3apeXXN7LEMtP/8pvoO3uhUSj7qr/L/3OLD8a03+0n0Mjg7gJvzfgiZy9ae8c2XIrU9xP2tKy5LdGNupOdZUqsLqE6EHchzDINcAzmfIxbAod2Uy6QIeIxZRGWuU9gydktr+s5cT/ZJFhUGMiirwEi15SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673892; c=relaxed/simple;
	bh=yxyIbB3n0iuOlY9cXyUFseyk3rCVHID/2wNx8sBsnQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYLX1x81ZjnXdWSz27j9d8We3DsbNO3+1xl1da1wWw+4z3oQvqWymwwdY2INBjfJYg5EoeDA8SZHoPpU1cLwDRtHphTlFwr7FcmZfSr9a9bxoJDTl/U589zhG1wQAbbou4+J9/7sgPcDFsYi+U/xAu9mvnM2WMrSX1AXSfJfD2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg8DWZwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg8DWZwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC721F000E9;
	Tue, 21 Jul 2026 22:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673890;
	bh=7eFUCMz/Mm4c/Cix0rARbxgUonn17IAowcafuuTjI2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg8DWZwTWbOhxha6NTp76HACC4DktlEkpBpxjje9+hxuv+GKau95lYlrQcedXOSny
	 BaJe3kD1S0CusWU4s7jffW1izPnM+yVs5EunX/HPkzuMucyjdlMf6K/dQxg3T8e1cV
	 uIlu20Tvl7XwNsGNdo6Pght441S95NjAARlFd8EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/699] perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()
Date: Tue, 21 Jul 2026 17:21:33 +0200
Message-ID: <20260721152403.227278967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 063c647b24f640657d6d9e2e90d620ea3ee19ae6 ]

sysfs__read_build_id() iterates ELF note headers from sysfs files in a
while(1) loop.  If the file contains a zero-filled note header (both
n_namesz and n_descsz are 0), the code computes n = namesz + descsz = 0
and calls read(fd, bf, 0).  read() with count 0 returns 0, which
matches the expected (ssize_t)n value, so the error check passes and
the loop repeats — reading the same zero bytes and spinning forever.

This can happen with corrupted or zero-padded sysfs pseudo-files.

Add a check for n == 0 before the read, since no valid ELF note has
both name and description of zero length.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: f1617b40596cb341 ("perf symbols: Record the build_ids of kernel modules too")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 627a6206f48221..8dd0f3a50a5b14 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -685,6 +685,9 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 			} else {
 				n = namesz + descsz;
 			}
+			/* no valid note has both namesz and descsz zero */
+			if (n == 0)
+				break;
 			if (read(fd, bf, n) != (ssize_t)n)
 				break;
 		}
-- 
2.53.0



