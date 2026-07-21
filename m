Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A042B3B9D9D;
	Tue, 21 Jul 2026 22:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671944; cv=none; b=GZS3ZFe9ny5MyIO748XOjjwXTZFDKzmsHhL7m0ZKP02uVS0g9QFP5nhHrzhegCRxe1TdJVmY3qVMRLg4DlAeKgVcjeoKAb3/YNuF0E7RyGbPM2227xso8kkQJFw/9IV3pJddmXB5Bl2PXIk0pg/nsbkJcf8vjFS8RzzrHiWvnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671944; c=relaxed/simple;
	bh=pxw4agxpG5m/lV127hMz6/d6lB4GFIWtNwI2HlNoefk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Prq1FCdJQv5lIhhCucUzx0Ug6/OwnkRyfKzVfT3zsKt0Ktj13ugQsYX55V218KN5541YgKkVr3i+hOBw0JW9nrb/DuDGDtPUo9mrcntzFQnkILGeBhKODSEG8OsWgy1aYNeayKItXkK5pkklvZNs8xS2HDDOVjPLej2SA5CBZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRBuFo0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRBuFo0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C2C1F000E9;
	Tue, 21 Jul 2026 22:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671941;
	bh=g0kaRpOFRmLXv3vyJs1YFGqLFSBaNq2GQl17pKIILEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRBuFo0Vbk7uz1BmPphc2OpozpASYn8Rg41UMeJK/+VtYtaU7qFXXvqW/o+Iv7Pnz
	 cgfkbj8icTPulPX7VOcjycrq/CbFnBuGRh5kqTAGWuX2lfFTZyIFQNocy/86ysR0mF
	 FoVcfaKm0RqSCZe6IrkL6zojNrwhoHXDK58KSHE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/843] perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()
Date: Tue, 21 Jul 2026 17:21:11 +0200
Message-ID: <20260721152415.842000798@linuxfoundation.org>
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
index d3bfa278df8141..fffe097fba9eda 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -723,6 +723,9 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
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



