Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D08471260;
	Tue, 21 Jul 2026 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657472; cv=none; b=m8bxhAj2NK9dgAozEub6+kaXMHP86dw1KDIRqQ37U2vDMQYJ0f7Sy7UQ+a0mDKTmYjR86vmFblpmtvC650ZPrYQJ3tXKXj7SOJOt7nT08p1xp65bV2ILToorM3GBaMaFuf7/b+RhM40Gno++jbVaa6Vu14TM7GQpnCb9ibPD2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657472; c=relaxed/simple;
	bh=ty5cqc0DT+2izWvbcWxcgNGb0iGLJJ8sf1+5fHaR0NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rEj4VpsyUYCNrFnagM8ihf6NCKvZ0OffZgdC7V715Gw70jkB1UjC274PllWKK9uJWMA9QGIqB1kgrDVlnPs0NXvtvoN9fa6Xn8yqUxtp/jZLTowe58WmPg8WEj92VBZSx8VxYRWkieZB/m9HgDKGpenzdU8t0j0/pJJ+pwibtgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO1yxLZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO1yxLZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F971F000E9;
	Tue, 21 Jul 2026 18:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657470;
	bh=p/Xs8/LjhV62kHBbNfnZmFiQ3jAaqFIaFbXVekQH+o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jO1yxLZn6NVtFQbcdMhW/TA42nIw6XDspFayqK1JoDywAsEHI83aI/QEubc7rYjOd
	 mXO6CKkq+jWvoMIAPCijZjYdw64tp68QLugwz/MVW8VZkuk0fYm9zWddnfAFwmCft0
	 V36naOpocDmof76VX4Ikiwq1aPZrFXznTEonLJe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0776/1611] perf dso: Set error code when open() fails on uncompressed fallback path
Date: Tue, 21 Jul 2026 17:14:52 +0200
Message-ID: <20260721152532.841359200@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d2c6069d68ee9d53b05fe38bc2049cc4286fbb16 ]

filename__decompress() has an early return for files that are not
actually compressed, where it calls open() directly.  When open()
fails, the function returns -1 but never sets *err.  The caller chain
(decompress_kmodule → dso__decompress_kmodule_path → dso__get_filename)
then reads *dso__load_errno(dso) to set errno, but that field was never
populated, so errno gets a stale or zero value.

With errno=0, __open_dso() computes fd = -errno = 0, which is non-
negative, so callers treat fd 0 (stdin) as a valid DSO file descriptor.

Set *err = errno when open() fails on the uncompressed path, matching
the error handling on the compressed path at line 354.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 8b42b7e5e8b5692b ("perf tools: Add is_compressed callback to compressions array")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index cfbad2d0496e89..5b88b19f9d8e3c 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -343,9 +343,12 @@ int filename__decompress(const char *name, char *pathname,
 	 * descriptor to the uncompressed file.
 	 */
 	if (!compressions[comp].is_compressed(name)) {
+		fd = open(name, O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			*err = errno;
 		if (pathname && len > 0)
 			pathname[0] = '\0';
-		return open(name, O_RDONLY | O_CLOEXEC);
+		return fd;
 	}
 
 	fd = mkstemp(tmpbuf);
-- 
2.53.0



