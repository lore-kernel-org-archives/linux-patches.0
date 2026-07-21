Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF61CAA6D;
	Tue, 21 Jul 2026 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657453; cv=none; b=BW9U1xqn9ewdkHohOpPlJU4v8v71dYVHC/wK+itdrY4/H2UypMG7QiUzXfA52dUHc2jcf/UD1W1wwWp2AZzfcdZ62As4cZIQ6LXGYWC7gmqBMIlXT6ayVZu36Ln4GaX4aMo5l5C0wHT4284l8kyu0+N2gQlYDanBGEZKQjFCRp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657453; c=relaxed/simple;
	bh=2LO14Ql+BbRvyKg8Qr7A/C88rykveSsBD49clH8bdQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m49vbPeVTXgHHxOEI0YwnuD2l1/p2hPJ94i3NKF4ptdufFhdksoQuVtWY0gjm2ssA8yMcsIObtBXska9ZkuMoCqjVZiml8TSR3SESlTk0qaxPe/ZVyizKD+W2h9yraPllKL6fTWHI16IM9J/CepTYTtayBsMyW+/6wGgnuNJ75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuA3GvgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuA3GvgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88281F000E9;
	Tue, 21 Jul 2026 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657452;
	bh=LlWvjTAvx/vD5iVy6dHlPHTAPtBabEoCO1NuqMwKfgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuA3GvgJ154Flbz1qpFt2kmJIj0xfu6E2712TeypKX4RLTaAJaB+/E3U/mXiFLnME
	 3I3cGl+O0U8iodQRY31eScrVuaj5b2x+vs8S2pzL1OEQg5eWm3XuE/B4rlt6cqr63/
	 chFf+7S9zodlilDoAN++mSIWRBnj3bV/DvxeBAcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0770/1611] perf symbols: Validate p_filesz before use in filename__read_build_id()
Date: Tue, 21 Jul 2026 17:14:46 +0200
Message-ID: <20260721152532.705159815@linuxfoundation.org>
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

[ Upstream commit 2a3716544359d4312c81b0fa909a13301186da17 ]

filename__read_build_id() stores ELF p_filesz in a ssize_t variable.
A crafted 32-bit ELF with p_filesz = 0xFFFFFFFF produces ssize_t value
-1.  The comparison `p_filesz > buf_size` evaluates false because signed
-1 is less than any non-negative buf_size, so the realloc is skipped and
buf remains NULL.

The subsequent read(fd, NULL, -1) returns -1, which equals p_filesz,
passing the error check.  read_build_id() then dereferences the NULL
buffer.

Add an explicit check for p_filesz <= 0 before using the value,
catching both zero-length and sign-wrapped negative sizes from crafted
ELF files.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: ba0b7081f7a521d7 ("perf symbol-minimal: Fix ehdr reading in filename__read_build_id")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 39b806651b9258..aa931a0015c10b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -179,6 +179,9 @@ int filename__read_build_id(const char *filename, struct build_id *bid, bool blo
 			continue;
 
 		p_filesz = elf32 ? hdrs.phdr32[i].p_filesz : hdrs.phdr64[i].p_filesz;
+		/* ssize_t can go negative with crafted ELF p_filesz values */
+		if (p_filesz <= 0)
+			continue;
 		if (p_filesz > buf_size) {
 			void *tmp;
 
-- 
2.53.0



