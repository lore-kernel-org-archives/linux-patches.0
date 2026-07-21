Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184AF46F4AB;
	Tue, 21 Jul 2026 19:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660558; cv=none; b=ovwm41yu5ty1Skyix9Uq4Rg3EjNmRSJZOdZsIrV+xEUFJM7cMIdeuPGVYA3yoPlDgMUE8jlkFoVQvwc0DLm3V1BH6XjEYifuwx2LfmKUc3Zic4CSO2sCP/r+tQQXjCC2KiAGAhE3I7gg3+J2aF7lrsynHOEz0N1ZLaK2giSOKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660558; c=relaxed/simple;
	bh=RA/cwT8wBtP3jjujrmVc9WvSmaZYO4X89AOiEDQPRso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccgr0jMxxhiLEMCRqqUHl99ofPoZrP+xQw6aWkPMxKsp/wR5q1FmNrzB5b3KySwr78RttdUw7ggrlOxHa7txb7/QFTpOrpNy84eyv+vVHQcFLJxyP3ToPjjQFihQL0ZC1D3gnFrl8R/8Ucrh2oQT9xhqGWYQ8LThdSTgb1afnks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iizYW8aT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iizYW8aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAD71F00A3D;
	Tue, 21 Jul 2026 19:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660555;
	bh=OT+IygCSQyFq7hgtirMNh5reLmwsf1Oh1Eo0S/zZTBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iizYW8aTa6j0jccjNk3Eop8Eqa9baIH94uD0J/lzHDfEYLJm7djeIVLOXsgewhH+S
	 FO2jU38S9mPQtJOX12OZYUqdr2hpGIW+MWZpgXukSDIJpLmFPuoFLEZJJzzpk1r+uV
	 hkkNMf3ud5rxLXn3wdmfmDmqv4Zz1zEkUdC4hkDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1025/2077] perf symbols: Add bounds checks to read_build_id() note iteration in minimal build
Date: Tue, 21 Jul 2026 17:11:38 +0200
Message-ID: <20260721152616.996328718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 52e582e316c48c53bb3082c29f7862ebc554087e ]

symbol-minimal.c's read_build_id() iterates ELF notes with the same
pattern as symbol-elf.c's elf_read_build_id(): pointer arithmetic
driven by n_namesz and n_descsz from 32-bit note header fields,
without validating that the name and desc fit within the note section
data.  A malformed ELF file with oversized note sizes causes
out-of-bounds reads past the section data buffer.

Add the same bounds check as the libelf path: validate namesz and
descsz individually against remaining data before advancing the
pointer, avoiding size_t overflow on 32-bit.

Fixes: b691f64360ecec49 ("perf symbols: Implement poor man's ELF parser")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 8221dc9868f7c9..091071d06416e2 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,3 +1,4 @@
+#include "debug.h"
 #include "dso.h"
 #include "symbol.h"
 #include "symsrc.h"
@@ -44,7 +45,7 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
 	ptr = note_data;
 	while ((ptr + sizeof(*nhdr)) < (note_data + note_len)) {
 		const char *name;
-		size_t namesz, descsz;
+		size_t namesz, descsz, remaining;
 
 		nhdr = ptr;
 		if (need_swap) {
@@ -56,6 +57,14 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
 		namesz = NOTE_ALIGN(nhdr->n_namesz);
 		descsz = NOTE_ALIGN(nhdr->n_descsz);
 
+		/* validate individually to avoid size_t overflow on 32-bit */
+		remaining = note_data + note_len - ptr - sizeof(*nhdr);
+		if (namesz > remaining || descsz > remaining - namesz) {
+			pr_warning("%s: oversized note: n_namesz=%u, n_descsz=%u\n",
+				   __func__, nhdr->n_namesz, nhdr->n_descsz);
+			break;
+		}
+
 		ptr += sizeof(*nhdr);
 		name = ptr;
 		ptr += namesz;
-- 
2.53.0



