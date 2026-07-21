Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA379346A0C;
	Tue, 21 Jul 2026 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666499; cv=none; b=TUZJz6SwfAjsPsmFPlYGsVHO1iDYoTvX6t8nj4XBHbeAB74cHFlcModmBYS0kev+AVMdUpujwCqaF28EUM74oNAwzZoriv9Td+kXPiyJ7Of8oZDEwyQfKHVrQYMzaOV1ytumVdOMhAtitquWnk8QtZyYe3hjZpBCVyvzKBDWYos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666499; c=relaxed/simple;
	bh=rUS45huvkBVDAdIGler0dYsvbH455wLXribhCTWt6XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ecwtV2p21eCzJm49cJ4L11KjwaxwPEop63d78LcMa6Lb/dNYKuEqcqiBV/ez4nj8n3cZiiX0693CACsINzcgmTF6CQnqf5CKzypUyzLxWM4MJfHbOdWbUfwuHfEKsH1wZ9jdrJi0o0+pUpgBOboIxCB4xhDLtLoySQXDKYvNQyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z46CI5Ub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z46CI5Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9751F000E9;
	Tue, 21 Jul 2026 20:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666498;
	bh=gzwum7MfHWF06vbruj2WdViYbppoAa3+9EMJACRdFQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z46CI5UbdCp/XROOFhhfI8W5xfT+2ZGkFm3TAF4n+tMk5C4ZrvtKLS24xGhvKRIXy
	 tEpaTTeWlybJLiBllJTkum7m5UE9pjDVZDPlx0C7SwuFBGQYoS+nCOh8Zz8F0gtf+5
	 +e5tYNdXG0Fs6jyslkdow3aCCzprnEDWoUETwh6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0707/1266] perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()
Date: Tue, 21 Jul 2026 17:19:04 +0200
Message-ID: <20260721152457.683244986@linuxfoundation.org>
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
index 96bb84a8c5c2ed..1729efd11ac5cf 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1091,6 +1091,9 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



