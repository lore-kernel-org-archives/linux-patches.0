Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E257332913;
	Tue, 21 Jul 2026 19:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660765; cv=none; b=j/YwPfWRhgY7iPLBA1eMmViXnoBO6qhG2HY42pb1xbIsuXA3EnHoYs8omPMCQgZiQUGqsPFfYo+TBoKZr8myqRLvmlOOBTgoODMiah64yVtf2f86NJiLdLqBEz7h5BmhBroKtPuA2E9nWwTLMfdOx0YzFavvbfrke9kSlUnVzcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660765; c=relaxed/simple;
	bh=jQM79zNu1gB4Trr/tMwaJslkcYHToAw9NXDWF7INMC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvQGozOxmtISfpgmrWwUa2rC73C6sNe7t5Gp7ua5UPCLp0ojmLVz5KntEZDj79NsnJ5U95MHkg0UTq/zNgsAk7WT2N1Xpa1CF931/VaJdU/fTDOKfEC+cEZxVuO5HQmgIIvVouIlBLazhjC/P9zV7SuVNvDCN6e0IH69KDe7Efs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4OoJs67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4OoJs67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DF71F000E9;
	Tue, 21 Jul 2026 19:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660764;
	bh=JXjdgee49WHRKg/3l6PpS+v5D1HwaoaZBVF8ljpVpk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4OoJs67Sn9oeG9sUbDiz5qoqJUNfUH0b0PO4+hrfla1bZe2AOC/paKJCczrCuizb
	 0VBV8CHEw81OnH3EZK8/HtDnVv5pkiUAtuHk0+juSTznMGC2Ec72peywlwlW5vw09z
	 zOTU8Z10boAJcn4ffO5HrUTg1VmiSqf/+zXf5lRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1101/2077] perf dso: Set standard errno on decompression failure
Date: Tue, 21 Jul 2026 17:12:54 +0200
Message-ID: <20260721152618.786954040@linuxfoundation.org>
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

[ Upstream commit 1a5f9334a45a6b0c1cd7341cc72a3b87adad1d27 ]

dso__get_filename() sets errno to a negative custom DSO_LOAD_ERRNO
value when kernel module decompression fails:

  errno = *dso__load_errno(dso);  /* e.g. -9996 */

The caller __open_dso() then computes fd = -errno, producing a large
positive value (9996) that looks like a valid file descriptor.  This
can cause close_data_fd() to close an unrelated fd used by another
subsystem.

Set errno to EIO instead.  The detailed error code is already stored
in dso__load_errno(dso) for diagnostic messages.

Fixes: 1d6b3c9ba756a513 ("perf tools: Decompress kernel module when reading DSO data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3547cbd5ca8d23..170637a9b8e0ab 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -600,7 +600,13 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
 		size_t len = sizeof(newpath);
 
 		if (dso__decompress_kmodule_path(dso, name, newpath, len) < 0) {
-			errno = *dso__load_errno(dso);
+			/*
+			 * Use a standard errno value, not the negative custom
+			 * DSO_LOAD_ERRNO stored in dso__load_errno(dso):
+			 * __open_dso() computes fd = -errno, so a negative
+			 * errno produces a positive fd that looks valid.
+			 */
+			errno = EIO;
 			goto out;
 		}
 
-- 
2.53.0



