Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAC6470131;
	Tue, 21 Jul 2026 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657033; cv=none; b=WgNYu/xwjo7W4tg/dD/rxIQjRfYQFOwf5zAkF/f/iAk/hJys/3FW2WpMU2ZqJDGnoZwTZLSkCB9NZLme1TwMOoFL9FH4DHSrwD8sEEYvsp4toh1a0fgzI98CAWfcitzYXMk15kR8qg0z/gqZjZR5gRL1YAlCBvtgSPSqq0FdT+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657033; c=relaxed/simple;
	bh=97QTKKgyg5Xyv+KL6y8Bd/RmaKDefierHAXfrC2Pt4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruVWTtMidFFO9mFpOdMMzp7bTWqvzyWAxLVOenOGp8mpJ4uZiUCUFs3wnQy/NpsStIIBRTlniM0TbyvxMSqNLxWKvZRY1UtYMExH09niQDf4qwrFJzABK3MTqAdrZ8r/tBUDy0Z68kxo+h9sTPGYF9ARlhWKXEDL6QzB43CV1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/6CMfKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/6CMfKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205CD1F000E9;
	Tue, 21 Jul 2026 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657031;
	bh=Vln2+nTdl2W/OmIHNWjbP2oUqzcNeFwrU3jEfcpDnw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/6CMfKXJdWviHA4Vw4e0Dt9jgs9LbvmMpIj2FDYZ18JWfo0NpCghJ8jnuT5Xf6U+
	 e+QrGrD6aPE95jkW/end1lpR5Ezy4nFCztsMGJh9rNhg44yRGbQvBs4nUqdL6CSZSV
	 RwYCJD/dDqZvQZTyzRRcrWKP4I4qq1t3dVejDA3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0604/1611] perf build-id: Fix off-by-one bug when printing kernel/module build-id
Date: Tue, 21 Jul 2026 17:12:00 +0200
Message-ID: <20260721152528.972965859@linuxfoundation.org>
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



