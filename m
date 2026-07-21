Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B00439904;
	Tue, 21 Jul 2026 22:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671884; cv=none; b=AHzey1ZlYtAsOkOJEj568O1cNzZ/wSd02PPxfEdB/WGoxbd4sQ/cmG8Bq/k9TmZn3EtS5FU4dnOb54fGtEiX7E5nSGL6ZIu6Q5LZDKErJazmuIlFs8PXk2wFIyOjvEhESpB9ivWIHznfT/0FLkQNjBsuEfPSmfNKTR2JJsmcsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671884; c=relaxed/simple;
	bh=LN3X4ECugfNoYqrCt8bHXtnObardadc8G7J7H816uXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMpNhmfMjFqbYQ/Z5OLlrv1w50kFdrYAYiiGsD1jQJA9Cr+wXwIntCoQC/BYIPeb1Vm1pQUwPdawHtu4CUSqBgs8EDW9gZUqassXlruA2eEt9ymRLdecPqPwX3ovj7DypFxAlJSjH/C91VfjXjwgizcgAy5RpfbJDs5yQLJHk5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpDACNDv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpDACNDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFC61F000E9;
	Tue, 21 Jul 2026 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671883;
	bh=np43O/etOIdXEx62kQ2js1UbdlhVpqAbzNgemUcVa+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpDACNDvK6B32yIejF3dQrfux4stfJRAEUSkmRrJg2WPSPQZpwVG+vVdZnp+s1lOr
	 eV26uWhlzaK8LNBqiwzPWRqVUpKCJHHLTFjQi5MU1v1f7dHtbpFoCc8zdENy29YPsd
	 /48lV8MipXq4RowgUSuPuHLsBZeopShHVUdiqBMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/843] perf symbols: Bounds-check .gnu_debuglink section data
Date: Tue, 21 Jul 2026 17:20:51 +0200
Message-ID: <20260721152415.394683974@linuxfoundation.org>
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

[ Upstream commit 9c74f0aab398cb32ab250401f323c0fdc9a3a496 ]

filename__read_debuglink() copies .gnu_debuglink section data into a
caller-provided buffer via:

    strncpy(debuglink, data->d_buf, size);

where size is PATH_MAX.  If the ELF section is smaller than size and
lacks a null terminator, strncpy reads past data->d_buf into adjacent
memory.  A malformed ELF file can trigger this, potentially causing a
segfault or leaking heap data.

Additionally, strncpy does not guarantee null termination when the
source fills the buffer.

Replace with an explicit memcpy bounded by both the output buffer
size and the actual section data size (data->d_size), followed by
explicit null termination.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index e3ae6c30b6e74e..7a9b6d8a551f2e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -791,7 +791,14 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 		goto out_elf_end;
 
 	/* the start of this section is a zero-terminated string */
-	strncpy(debuglink, data->d_buf, size);
+	if (data->d_size > 0) {
+		size_t len = min(size - 1, data->d_size);
+
+		memcpy(debuglink, data->d_buf, len);
+		debuglink[len] = '\0';
+	} else {
+		debuglink[0] = '\0';
+	}
 
 	err = 0;
 
-- 
2.53.0



