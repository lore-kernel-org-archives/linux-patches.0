Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D43E343889;
	Sat, 12 Sep 2026 10:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209242; cv=none; b=P04x/xPnoRjs3AqIO+erc+zDaM8w2o7gYjjqY5fEI+h0AimkHkm9w/8kxJXoy02uOFiKqeprtG2luQmU0UW4hvp9E+2VOdluUf8Vp/Tz/0BgjyRXrHImMknLE+mAeI7sLd5HwJu/xQ/iqXoXCOcDyF8Ady0BD0aGiuSVKgYI3OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209242; c=relaxed/simple;
	bh=5I7ZWown1p2dMIZuxmEx2i5QlzWDW9AyOBn5coU5Ahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoJ5OE7cSVmmb6lvBjm0QzEyBRiKUzxNa9ZUFIrsHcSXvoyYmUpihl/xOe8dF4DOHvI0OVEkViHFJQGW65qgk2fNqy55MFXea8JMxjmDhjVkpotzs9mhfPZdW/qay8qC+oxXGyhpTMKtXm/BJjTDh/RcUUOGt6cREa5lMFWwlu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uynkeh4U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uynkeh4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E6E1F000FF;
	Sat, 12 Sep 2026 10:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209241;
	bh=4UBcB9GuzOHVl0IPJUdHR1+s93aPDgyEkWsa2IE1Xyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uynkeh4UUW1+IUS6tyKwbbjpJBeDbGyPTVw3FWgu/kGDJM2TfK7UsB7HeNJwTp/Pg
	 uf8n214VmyShybzLDFltgOhJ1TBhAoub/bgW4NqDYc+VL5gxHARiBb4b9gTY7TEv1+
	 mwLB4mehZljyDBtzK4LfEaxHpFc5gmOYRFOxtRkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0779/1518] perf machine: Fix fd leak on bounds check in maps__set_modules_path_dir()
Date: Sat, 12 Sep 2026 08:49:08 +0200
Message-ID: <20260912065641.059284440@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9331b4cc19f18..a2f5ca35141bb 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1390,8 +1390,10 @@ static int maps__set_modules_path_dir(struct maps *maps, char *path, size_t path
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



