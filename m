Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3193935E1D8;
	Tue, 21 Jul 2026 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657334; cv=none; b=I8dfhCNXS71IqAiLsaqUT6ZxSrx6el52Tfg/wvGyvgYLAr3J4jFISMX5mYLvClHMiwESMVaKgb8bGtGI+PNBAl1xddB40K72orqoL/++KbVmJPGqQ/Bg2iKNX6GR5x87EBlgRMzLowKY0ujvQ3FXVBAuj5fy/STfTSWfcT9NLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657334; c=relaxed/simple;
	bh=nYzpTVN7ozZlikgemU8H4obdidDiN4RfRY1JVI4TC8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIKDIR/FUBaNd11RPVEwaqc7OsrmSCNKgIJNzix+6XaOXVfGREetmKjI793lVpvY4lOgnGnbOiFumFTUy24QPagiLY1rXlSmNy0K5Z6XfqHT7u9xjwy/4/y8RrBum3PEUB5WtdnyL24QYkUGR6Hu5BzAOsED3EEjuTuNNY5l38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTFuNnx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTFuNnx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786CC1F000E9;
	Tue, 21 Jul 2026 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657333;
	bh=3HoPT8dbgrEuNuhFjts9fkFToK7hhh6njSOeP3CcGl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTFuNnx676jANt/YNhUsEVLRogR5mUvUFFnhaBb7NxyC+BAr0nSAkRMo2LpexoS4Z
	 t2gdnjqVQP4bF//fyOWdAHzwr9n00WXMoSMqRDaVaY+4KcJVmoubMgYmxLf3MCLb14
	 3ur2NqyBv3hxeWuZxRg05rHUiJxUeBMP7mWkcs9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0725/1611] perf symbols: Add bounds checks to elf_read_build_id() note iteration
Date: Tue, 21 Jul 2026 17:14:01 +0200
Message-ID: <20260721152531.689421633@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit acc56d3941fc2997a5a21ea9233a8ac3d87c4f2f ]

elf_read_build_id() iterates ELF notes using pointer arithmetic
driven by n_namesz and n_descsz from the note headers.  Neither
the note header read nor the subsequent name/desc advances are
checked against the section boundary.  A malformed ELF file with
oversized note sizes causes out-of-bounds reads past the section
data buffer.

Add two bounds checks: verify the note header fits within the
remaining section data, and verify that namesz + descsz (after
alignment) fits before advancing the pointer.

Fixes: fd7a346ea292074e ("perf symbols: Filename__read_build_id should look at .notes section too")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index f96aec292ade23..107e10006cd1c7 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -836,10 +836,24 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 	ptr = data->d_buf;
 	while (ptr < (data->d_buf + data->d_size)) {
 		GElf_Nhdr *nhdr = ptr;
-		size_t namesz = NOTE_ALIGN(nhdr->n_namesz),
-		       descsz = NOTE_ALIGN(nhdr->n_descsz);
+		size_t namesz, descsz, remaining;
 		const char *name;
 
+		/* ensure the note header fits within the section */
+		if (ptr + sizeof(*nhdr) > data->d_buf + data->d_size)
+			break;
+
+		namesz = NOTE_ALIGN(nhdr->n_namesz);
+		descsz = NOTE_ALIGN(nhdr->n_descsz);
+
+		/* validate individually to avoid size_t overflow on 32-bit */
+		remaining = data->d_buf + data->d_size - ptr - sizeof(*nhdr);
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



