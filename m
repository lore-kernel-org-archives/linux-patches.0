Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83C324A078;
	Tue, 21 Jul 2026 20:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664641; cv=none; b=sYiEkeQGvBLlghltHwhJaA4XjJAHS03d14jFl+QQtVehRUHBsxoMV817FpZ4lZsv8PLgbSEn/FSAtiFJjGiMXZ/eWRQvM1VNo32w67F0pnOHv2wEUyVbqgs54NIiTF45qKK/8yDc4F15dBXBEW5Lz3qh79eGpQW6JwycN0Eo9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664641; c=relaxed/simple;
	bh=7cq7Z/VkgTgd9KYXebh9IbBra6BP1giZrkKEWWJ4GDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw5aTYuMiM1sYrd99nIbrLN9XjFQyWWzwFJb69vYnKoMhQhDimGAo4SYyndIAhMa5YUdf8jzOAu+sN5rDi95Bg7niYl6YS2EFbKFS81seAmCBTApjr+5nfhswSD6x9ceROLT1E8NVJWDECXIO6zQRWZWWFaImc3h8tuC/4iikDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKvMuRBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKvMuRBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3441F00A3A;
	Tue, 21 Jul 2026 20:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664640;
	bh=CmcFvSDHMfQyQIH1Hl5IsdVlYKn2pTb6eniMbFcNUQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKvMuRBYcQAqUXukRQFqhGKR0GTi2K+HOIRC3f5P5jQcPV8CaqDD4f8r9BaC1jyTZ
	 1A/Wec0mWE52jMMYMCGuy1CAdrrDoEUKYQsUWGtKlm+jc5DePUn4ZXBmTfFo1FTkZy
	 TLmFRBGSy/lu3r+5Hw+9NnvBcOQBAR/G7dO+okBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.12 1276/1276] perf build-id: Fix off-by-one bug when printing kernel/module build-id
Date: Tue, 21 Jul 2026 17:28:39 +0200
Message-ID: <20260721152514.643417772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Petlan <mpetlan@redhat.com>

commit 017bca78e4d72b1ff027d368c20a1b2c654edaf7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-buildid-list.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -58,7 +58,7 @@ static int sysfs__fprintf_build_id(FILE
 	int ret;
 
 	ret = sysfs__snprintf_build_id("/", sbuild_id, sizeof(sbuild_id));
-	if (ret != sizeof(sbuild_id))
+	if (ret + 1 != sizeof(sbuild_id))
 		return ret < 0 ? ret : -EINVAL;
 
 	return fprintf(fp, "%s\n", sbuild_id);
@@ -70,7 +70,7 @@ static int filename__fprintf_build_id(co
 	int ret;
 
 	ret = filename__snprintf_build_id(name, sbuild_id, sizeof(sbuild_id));
-	if (ret != sizeof(sbuild_id))
+	if (ret + 1 != sizeof(sbuild_id))
 		return ret < 0 ? ret : -EINVAL;
 
 	return fprintf(fp, "%s\n", sbuild_id);


