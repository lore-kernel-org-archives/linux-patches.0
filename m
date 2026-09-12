Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EF0356744;
	Sat, 12 Sep 2026 11:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211297; cv=none; b=p7oCU9lhVnOyPCWdjFTRJMjDxnlTb8cCs2GZXszxM9aSw2GeFh93l0Dw+HYsIQdmckcHZqMwcAfd3zTnrhGb0BK0ZJwufBQ/Gq+jkwfPDDXpVtuUHwz2wuQalLcu0AhGnG2h+JZVYb/ZQPkQYdJ/htnAHnBNEluipb82qwxwO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211297; c=relaxed/simple;
	bh=kaHJuGy0kGT7q+Vqmy8yfrDg9uS0yxaZsG9lEpkWWww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRs0BkWtYirE7jWHb2UQc33x4zF3J7o4hzX/QW+yjNK/rRUjQ+v3poYggYhVkf6H7zCriMe+FPJfkaFca+/qXx7mGJXMwMDpJIolpLhZftPfiK0WlKSNoDcgwsVEG/xy+aCRZ8jf7ngdjnIX2onX4NnYZvDfpducoIivKEXr13U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fg9bjiu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fg9bjiu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5B41F000FF;
	Sat, 12 Sep 2026 11:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211296;
	bh=hHyLNkEYfU6T+PN42jvXw0/Di8iLVxzWq17/ACQwVww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fg9bjiu89eCrUG1eHPwWPZwtVXoLwLQpCW/U6azfIupR8e94pOiWlDRUYCguCwOI7
	 gRrXQifaeog6A7JaGRVkQcBltnpB4efsTgEQaGhDPi/QWNDdqVnEtTbcby1YimTwRB
	 qvFbqTYM7J1cEYSc/vvhxUsF6vzf7wrUreHY2hyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1203/1518] perf dso: Guard against errno==0 when dso__get_filename() returns NULL
Date: Sat, 12 Sep 2026 08:56:12 +0200
Message-ID: <20260912065650.699764174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 51a7a9ddcb3ebc86615886b1f44e85bdea9df326 ]

__open_dso() computes fd = -errno when dso__get_filename() returns NULL.
Some failure paths in dso__get_filename() (e.g. binary type mismatch)
return NULL without making a syscall, leaving errno at 0 from a prior
successful call.  fd = -0 = 0, which is stdin — subsequent code treats
it as a valid file descriptor.

Fall back to ENOENT when errno is 0, ensuring fd is always negative on
failure.

The forced ENOENT stays in errno for the callers that check it after a
negative fd.  It must not misdirect the try_to_open_dso() fallback
loop, though: dso__get_filename()'s chroot fallback used to accept a
stale ENOENT even when stat() succeeded on a non-regular file (e.g. a
directory).  Re-stat() there and only take the chroot path when
stat() actually failed with ENOENT [sashiko-bot review of PATCH 1/5].

Fixes: eba5102d2f0b ("perf tools: Add global list of opened dso objects")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6fa104752de2a..6bff8be805ce5 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -581,9 +581,18 @@ static char *dso__get_filename(struct dso *dso, const char *root_dir,
 		goto out;
 
 	if (!is_regular_file(name)) {
+		struct stat st;
 		char *new_name;
 
-		if (errno != ENOENT || dso__nsinfo(dso) == NULL)
+		/*
+		 * errno only reflects the failure reason when stat() itself
+		 * failed: a successful stat() on a non-regular file (e.g. a
+		 * directory) leaves a stale errno, which a previous failed
+		 * iteration of the try_to_open_dso() fallback loop may have
+		 * set to ENOENT.
+		 */
+		if (stat(name, &st) == 0 || errno != ENOENT ||
+		    dso__nsinfo(dso) == NULL)
 			goto out;
 
 		new_name = dso__filename_with_chroot(dso, name);
@@ -639,10 +648,13 @@ static int __open_dso(struct dso *dso, struct machine *machine)
 	mutex_lock(dso__lock(dso));
 
 	name = dso__get_filename(dso, machine ? machine->root_dir : "", &decomp);
-	if (name)
+	if (name) {
 		fd = do_open(name);
-	else
+	} else {
+		if (errno == 0)
+			errno = ENOENT;
 		fd = -errno;
+	}
 
 	if (decomp)
 		unlink(name);
-- 
2.53.0



