Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE86A22B8DF;
	Tue, 21 Jul 2026 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660188; cv=none; b=qMsce2ACdBjH6K4Ync58ryqJNTnrATzZtaEEQZ9b0V+W0O74PYXGSX+i2kRhZ11sHflQvwl8Wdg4OUCoh0cNh82jesDdrCsmRJ/ChpjV/OFQJeOf1quqmv0429hbXEqDii6ERQRnU2Sj442iT0rcG/tje06fZzBay0ig7BXnB40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660188; c=relaxed/simple;
	bh=v+D45MczdG8BwbsH/n8MEh7UoVEA5GBr3+P8PJy3xGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pqsiov0jiyYd+d1XWy5+9hV4Fl5y0plEkBm+fDycVyN5+pAmkRTPjIWFtTBw7oOx1uEklqkz1mL67xVhwgKbSARlXSvn9XeN2dtnfuX63ryGtw+zV5OV6cipqdH4lsNuiVwQ0dPz8QFU0iN5nGjHTG2YApueLth5Ww/B3bb90/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTiS8cR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTiS8cR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A97E1F000E9;
	Tue, 21 Jul 2026 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660187;
	bh=X8xnn3PX68ZK50XFaLeB8H1L7wGT6QTEXpRP4XxO6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTiS8cR+WSoMV2BgfXN4Gso4fdz1JRxZnvoxJEaquvcQ92kJcuDGQ7RdZdFnuYH3M
	 q9IDrYeInZqw0hK9CPd7nibf3ikoWyYHtYfesSSkDrCkX4dy6ODfE3yqdCW9mxs6Cw
	 uS7Njd3Z/SWkqaFbMIQq8+Kf0YMlZ/wQDlDOIQ78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0886/2077] perf build-id: Fix off-by-one bug when printing kernel/module build-id
Date: Tue, 21 Jul 2026 17:09:19 +0200
Message-ID: <20260721152613.706215051@linuxfoundation.org>
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

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit 017bca78e4d72b1ff027d368c20a1b2c654edaf7 ]

When changing sprintf functions to snprintf, one byte got lost. Since
snprintf ones do not handle the '\0' terminating character, the number
of printed characters is 40, while sizeof(sbuild_id) is 41, including
the terminating '\0' character.

This makes the later check fail so that nothing is printed.

Fix that.

Before:

    [Michael@Carbon ~]$ perf buildid-list -k
    [Michael@Carbon ~]$

After:

    [Michael@Carbon ~]$ perf buildid-list -k
    a527806324d543c4bc3ff2f9c9519d494fed5f68
    [Michael@Carbon ~]$

Fixes: fccaaf6fbbc59910 ("perf build-id: Change sprintf functions to snprintf")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-buildid-list.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index a91bbb34ac9463..e0881b0ac38ff2 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -61,7 +61,7 @@ static int sysfs__fprintf_build_id(FILE *fp)
 	int ret;
 
 	ret = sysfs__snprintf_build_id("/", sbuild_id, sizeof(sbuild_id));
-	if (ret != sizeof(sbuild_id))
+	if (ret + 1 != sizeof(sbuild_id))
 		return ret < 0 ? ret : -EINVAL;
 
 	return fprintf(fp, "%s\n", sbuild_id);
@@ -73,7 +73,7 @@ static int filename__fprintf_build_id(const char *name, FILE *fp)
 	int ret;
 
 	ret = filename__snprintf_build_id(name, sbuild_id, sizeof(sbuild_id));
-	if (ret != sizeof(sbuild_id))
+	if (ret + 1 != sizeof(sbuild_id))
 		return ret < 0 ? ret : -EINVAL;
 
 	return fprintf(fp, "%s\n", sbuild_id);
-- 
2.53.0



