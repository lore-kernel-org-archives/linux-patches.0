Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C938AC92;
	Sat, 12 Sep 2026 09:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203753; cv=none; b=A1A2N4ugK2vEzUnQQL6PF9zkfQjJVZfHH5wqTS1yKcTH/qAVzMhr4ysBizMi/3etn+U59mrLtfAxGQEnYNXqfd0u1G84nG38NLWxPPbnlZG85ptuyPkNq33VQ7LWxCRDAh0smZ4hX9gQ+UxveOhyo0lFOlvFYZIXvBEukc5n47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203753; c=relaxed/simple;
	bh=NrfxmhchG1Iopa55M4YVSLHGAqW9bNqYMiQ8Z2ibCIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZtJqvXUwXQ25kn/oToM0LMxuuhYu5hOYWW4Jb/7mfZTwmYSUkgkFbycdcqVav7LtLN79taLMC3C81vmlxn1gohIjbc8oKm3nDCrCf8gK0dZ7r0HpauQl6IYGCZAv8dFiEEaQpZtPDzejg6br9FVmjHETA3PIdXQmsywzREXIUQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSbkHuKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSbkHuKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39651F000FF;
	Sat, 12 Sep 2026 09:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203752;
	bh=vmncxkxMYDcbRvLd3TmnAA61Lt4rEEfvdn3w5ck9bsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSbkHuKdZ49pbVQMzGPBBithJxp4xBy2EdMZEjtoowv/f0Vtnbc6ouJyiiqkz9yd+
	 JAPlXBWAyDHqxdO4ySjhIU+F7TeOmf82dpHa+Acq224Fk4ig5YXVtL4i6XYnUJ62qH
	 xqCz9oFKhUilANdmvuh4Cd7bzgbqjrjutKcbYDvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1473/1815] perf dso: Use stored fd error instead of stale errno in file_read() and file_size()
Date: Sat, 12 Sep 2026 08:53:43 +0200
Message-ID: <20260912065723.589435995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 075d2c32353ded0fe5f3b62f4aa4e98dccb3fb29 ]

file_read() and file_size() use ret = -errno when
dso__data(dso)->fd is negative after try_to_open_dso() fails.  By this
point errno has been through mutex_lock(), nsinfo__mountns_enter(), and
multiple open() attempts inside try_to_open_dso() — it no longer
reflects the actual open failure.  If errno happens to be 0, ret = 0
looks like EOF rather than an error, and file_size() callers like
dso__data_size() would then report a zero-sized file instead of
failing.

dso__data(dso)->fd is always negative on failure — -errno from
__open_dso() when no filename could be built (e.g. -EINVAL, -ENOENT),
or -1 when do_open() itself failed — and never 0, so use it directly
instead of reading the stale global errno.

No assert() or comment is needed after the assignment: the enclosing
if (dso__data(dso)->fd < 0) already guarantees ret < 0
[Namhyung Kim review].

Fixes: 33bdedcea2d7 ("perf tools: Protect dso cache fd with a mutex")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 41bbc8f994e41..60aa77f797851 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1038,7 +1038,7 @@ static ssize_t file_read(struct dso *dso, struct machine *machine,
 
 	if (dso__data(dso)->fd < 0) {
 		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
-		ret = -errno;
+		ret = dso__data(dso)->fd;
 		goto out;
 	}
 
@@ -1160,8 +1160,8 @@ static int file_size(struct dso *dso, struct machine *machine)
 	try_to_open_dso(dso, machine);
 
 	if (dso__data(dso)->fd < 0) {
-		ret = -errno;
 		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
+		ret = dso__data(dso)->fd;
 		goto out;
 	}
 
-- 
2.53.0



