Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304CA47127B;
	Tue, 21 Jul 2026 18:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657530; cv=none; b=hI4WjO6TvVIOQ/C3Gv035oB5YCOOJsCMgQuexzZXNNmSj6BdjQyf/OiRJyuB/igoX4szsOReYKCWKGdTT7VrXWnCJzK8VyA4yEriyoa7zZ5fB4aO8by7p1ocGz6ZiMt0mN6SFeiKR9pvnG2JmRbLPGSRiyAzcBNKgzQuFt3bwZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657530; c=relaxed/simple;
	bh=rl2n+GiMXdZHq9EAfJUm8zNizGGOeN4trj0SlmAZ1t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhG/xu2kWz5o6clH1W1LEtcYuL/5IDVQ+Qc2/R2jRNx24zPKtj5xp+jAMlMnmtaoLlwKN+z972PUbXVeSDj5QWU1HIHXrfpCBL3ooKaVD03U5WclQC1AluWav4ZFqC1i8IBhdCAxEVPKo9DdSzMmSoc1JMKo8PTmJJ3GOXxFsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA20n1As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA20n1As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5921F000E9;
	Tue, 21 Jul 2026 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657529;
	bh=KSUs+E36dDBlt4T4zsanirPMZrlLD4glZvK86FxVvOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yA20n1AsqPof5jqP0RFeqLzs6ypUNZU3JC20Ui3xYNiMa2iTefPo6BwnQKaH2BFuq
	 qyq2EP8bHbucbttGGhSqjMEiMr53SgXKqnJSs71ZpbGznhnDfQr/r/5Wug9jSlP6XI
	 bhtdA1NkpaI4ZNKiEcdMineYKqEKc9hGPX4TGs2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0800/1611] perf dso: Set standard errno on decompression failure
Date: Tue, 21 Jul 2026 17:15:16 +0200
Message-ID: <20260721152533.381204404@linuxfoundation.org>
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
index 48f0617df2dbbd..d63e97480fece4 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -602,7 +602,13 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
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



