Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928653B7B70;
	Tue, 21 Jul 2026 20:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666531; cv=none; b=NcgJJ8FcfnaMI2HqZW+NU/Oi8joWzGezcSembVt1RLiIbyqThAjjxzD/euDqhHeTnm/yOZrlFj6WJWqiOLGvcrPBscf8ZA4NJ16xShvmlO/f60Vq4LgHYJgysKJUPggH4mjJwpsFiapKKHjjZ/2Sc7EWM7WQHQpIxs/K2I3uYT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666531; c=relaxed/simple;
	bh=/ATYRqJf345FgIgbmFR/ROF0sWu5rCLR8Yca+NXlKns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFpIRFOpcEYKK9n1+A4drVowag5+o04CiCZll5GbsQWspRIS2PBXwTMHDYbHgMrpz46eeKjr5XvIHQWX/KXzk2tDa4VT9I562P3ZsCwEXE4mh9ePe1dgddx5e4xUA2bYRRZQQyTvMluHzfjoo1OEhIL1SSl8xXjYRfo2CTI7Qp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1s94H0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1s94H0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049F11F000E9;
	Tue, 21 Jul 2026 20:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666530;
	bh=V2cAsw7vIWfbF63+A+gSe515DhxQqzYOhOEpo2wQABo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1s94H0+OYDD4MCSkL6oBOA1fF55546dghV3Ef9VrI2HiBCbrPjDDMWqpHV87EPsz
	 bZs74NdO83HXF0CJohuOAMl4S7ggdPRBRgyILeYcUBiZ24E+8/y+F0rVUEvB4FgafQ
	 /3BDDTHU+6Ior8imNASvw2AHKNPKld8Zb09AuNcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0691/1266] perf symbols: Add bounds checks to elf_read_build_id() note iteration
Date: Tue, 21 Jul 2026 17:18:48 +0200
Message-ID: <20260721152457.317184455@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a2fb6e3d4ef38..96bb84a8c5c2ed 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -908,10 +908,24 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
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



