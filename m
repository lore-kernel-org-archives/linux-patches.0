Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16301F03D9;
	Tue, 21 Jul 2026 22:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673855; cv=none; b=VnYpSrrQeHCluLACR7sJqCslVs+ABF+EGe6bqwCXXZ3APsCOYJUE8NDYhmtIM+FCmpqpyhWejDMVczaAJAVxfP8sCxt7qMj7n2PqOUdRJAchHYg4QPfiHzQAbhnFfWcQx+opnsrd4H9zyPlh8ylbfOygwGzjiq9KJCRJmKKWLW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673855; c=relaxed/simple;
	bh=jhP77jrQWzOPvkTLUP/yZUbnXWJUxk6UN1om6kXpszo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsYJX38wIHVKbiL6taNdq0zXO9gdFcRxbRwH1IqxpcM8GKg9HKtO2Eh4nH4N1n4pOZkG1fouYWWwjF3EGlaluYZ14LstHuY7XL/dgNUMD67iN3toTeFqI4KT/3Hxhv+Wzm4fD/XVzKEIDUXwm/yu6vwDhlZO2rz6ZHwxYaepzS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTuzvnSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTuzvnSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527B51F000E9;
	Tue, 21 Jul 2026 22:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673853;
	bh=HLo92n0O7W2X3vz0En325h29jpzody9WkkKjjs5Jc0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTuzvnSJxW/rfS85dgYcftq/r2Skf5Rw549i1FMOeX1miU5o3aaOp+Qb+i1nY+WyE
	 be7FaWHTAAhruvKoNg2olYYHLDisoNg3tO93aGLEJcHT913PqfKEpDHip9qZUPTFEs
	 2LzeZTUQ5Ew9GN4MPdNlkR2AwCoKCpn8F2jCIAVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/699] perf symbols: Add bounds checks to elf_read_build_id() note iteration
Date: Tue, 21 Jul 2026 17:21:20 +0200
Message-ID: <20260721152402.934040376@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bf11448eb4177d..627a6206f48221 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -535,10 +535,24 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
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



