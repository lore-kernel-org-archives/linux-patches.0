Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656973A63E4;
	Sat, 12 Sep 2026 08:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201083; cv=none; b=k34GT5t71FrRi0fmnJvuZ2pAWY+dnhNVDDnZVMegvNXHs08GAtIv5RTOtwRgxgw7SVOXLz9VtWiBqi5JOtGTA781tQohKUlPFyDJN9FAO1c177RuEOz3X2ud8doBa/3MYQH8EPsfkuf6Eh1MHyU9MWXCAXyQhcigrm+NUcupsAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201083; c=relaxed/simple;
	bh=kut5H+z0LzT4hMODK+addDeY3Q+RD4BAeivgmyPuv94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgNaN1tAyMPComj5Qe19l83jRG8PuOSOoa4u2M8I6gI/C3lSDi9P4W/KVPw3NsUzgjK9GocLTgY9E6BoZeQ8BNvbDqYIVS94Od7q1W0PlvTL1hWO2zC2KhEyNUDFbk8MtkDKKR8STmSvauXUmya/GdCVdGD43hmp9fUzcdK0sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCPI16rE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCPI16rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F641F000FF;
	Sat, 12 Sep 2026 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201082;
	bh=0jo3TnLN8B2f2hqF8kzg9mDhcdA9YI+wpbHruOxddUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCPI16rEgMvqMZx9v6691+cC/SV2U1TTx3Nr08BGOeziw0nqJwgi1ZDk7Exd/ZdG8
	 8/OpZyL2fuDNwKXzx5qgrWnmnuh5YdlBBPxQ5CDGvTJVMD9Ey+cGrHtJa1nCFJo/fS
	 qRPB1xwfccksCK/FW1DB6UhepguflEF+cX5ZJt0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0924/1815] perf machine: Fix fd leak on bounds check in maps__set_modules_path_dir()
Date: Sat, 12 Sep 2026 08:44:34 +0200
Message-ID: <20260912065710.632028282@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 23010160bb9fd6e7ce940e232cd660b37ab9b20b ]

The bounds check for root_len >= path_size returns -1 directly without
closing the directory fd opened by io_dir__init() a few lines above.

Jump to the out label instead, which calls close(iod.dirfd).

Fixes: e7af1946818b ("perf machine: Reuse module path buffer")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0d2ebf6a84bcf..503f5a65e0cca 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1411,8 +1411,10 @@ static int maps__set_modules_path_dir(struct maps *maps, char *path, size_t path
 		return -1;
 	}
 	/* Bounds check, should never happen. */
-	if (root_len >= path_size)
-		return -1;
+	if (root_len >= path_size) {
+		ret = -1;
+		goto out;
+	}
 	path[root_len++] = '/';
 	while ((dent = io_dir__readdir(&iod)) != NULL) {
 		if (io_dir__is_dir(&iod, dent)) {
-- 
2.53.0



