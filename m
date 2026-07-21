Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0660E433BCA;
	Tue, 21 Jul 2026 22:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671908; cv=none; b=nU0jf+d2Gf/7D2A8m91A4O0rB3bbUn701MnC29TsYCkSUiM9bnKCMb+0k+HDR+lpIQptoY45b4WB2RF8oK5rSpZkjo5hOAdlneMkQAhsCwvlHchEKoI+2DJIidyu+BAAp9QbUOnMYXvnWjnmqla48rAFCoWF/F7vE7Y6CMA8Z6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671908; c=relaxed/simple;
	bh=KTu2imYI37fVcs42h5qVu8HTEK1m5klSO9+siMJrL2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikLByfYHps0U0lrQXrirY/oI+AKuG/nBuFiAPe4oH1tkAuqJ5qu32YtLspMXm1PRlw9vnXM5dN+rkDBEpHxeZJx7lwGC4roSQ1DlcVMlT4upl8xqHVLvxVMISS7lgT5ZAwTujNeGq0V9jeWfLPoryZNmjmG4sXZVdVp59Rh+N5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0XNOya/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0XNOya/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8881F00A3D;
	Tue, 21 Jul 2026 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671906;
	bh=6GaUHGEJQamteXEjT0xUTX2vfwvFrB2RFDdJJTfz2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0XNOya/M1If57c6oktzSPgtTBm/gN3JXynL/RpydJsETXBheYP+CBPQXminz0kCh
	 Wg0ylW0Uly+YEEXlR8LWgGFQd1VGlunwY66n2Ln7LvisdVISFpRPlsIWA3e1fLetZU
	 L5lJsmO2u9koiyd6HgSXKjzDKI7G7EZyjDU+B4c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/843] perf symbols: Add bounds checks to read_build_id() note iteration in minimal build
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152415.572605121@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f9eb0bee7f157a..cd3bef5644a0b6 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,3 +1,4 @@
+#include "debug.h"
 #include "dso.h"
 #include "symbol.h"
 #include "symsrc.h"
@@ -45,7 +46,7 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
 	ptr = note_data;
 	while (ptr < (note_data + note_len)) {
 		const char *name;
-		size_t namesz, descsz;
+		size_t namesz, descsz, remaining;
 
 		nhdr = ptr;
 		if (need_swap) {
@@ -57,6 +58,14 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
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



