Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE91474CC;
	Tue, 21 Jul 2026 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657456; cv=none; b=Ckoi7cqoNT/p8ce0qNpyxDjmJUCaTXm9G6uSBoxBvCCvRrpII7Kgo86AenAYy7gYMmDOLCz/WN73NKs+o18dPRIpdct/q2+SWpbDntMt0pqHnE1f1Xbw0b416UnhioTWN55/0VlskhAALkVBtbV+Vg9/E2fBbkkZHy4yPXk4H5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657456; c=relaxed/simple;
	bh=mc4fx0BuzeOCBvfo0GsKO+74iGkGh7Fkew+iZc6bWbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lz2ve5rRUILt9IXKDmi3siILCZhFqH5BO/uWYo50spL6b5UTwb/41s5UgUCeAMifUr6Zjn1Ig3GvqC/8ky5lEZReSVCdypE/r7XRk95kyF77HkHq61r3l5FGqqvCW4lNYS1I+uu6EWPPVPkRYF9MN9o2cVax35Q/VwY3hu4OstE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWUObYPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWUObYPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C8A1F000E9;
	Tue, 21 Jul 2026 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657455;
	bh=+DddYCcHKD5j76pFMCE9MuxR4pJbL30ZznjDIhv5uTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWUObYPJ9+161KGZ2JEWPXlAO51JgzvB/bRhxP6YoXtpzk7QWoBivzPIAxiYADiI2
	 yTK/dj1+vWpTkzo/ZmiL8v2XpAJGLmTe+t5WT/t6lLlruir1onVMB50feNo4C6HiZX
	 yzJMeQYNqyBHwvyFs1lfSPi3AWazD4BrdW5Sozfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0771/1611] perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()
Date: Tue, 21 Jul 2026 17:14:47 +0200
Message-ID: <20260721152532.727591522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 12a4390ba2d267..108b91844a2dee 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -991,6 +991,9 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



