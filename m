Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD229BD9A;
	Tue, 12 Aug 2025 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026397; cv=none; b=Jp8KBnQoIa42ha9OkoGPy/aGmCgorSTAG7ft0FB+myOD7PPqmHo3T+olJ6DelcqElCsN6brX9wrVTZGTbEgbiGhgke/IG7v4bVF8WLAGX+AYtLm7yByPGhjzqwv0MyBLWPdcpDmwL/hi+gN3LMX+FjKSVIJE73eNSX1ZH0pICtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026397; c=relaxed/simple;
	bh=JxVUSCiP3ObFL3t6jiDXG1jznHGfTD9gOOYPl0bMQrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSJ2w+QedqZC5S+J/KKU2WQ4+bLTYR3igGESNEPxxdOkSJxG5aJ/ikGIDso1KPxnI4SeDxNp/fR73dSwPDLM83TnmaOGzEc+4386KFLV1oHAyspmNH8Rii1a+mgdWUwuSNoie8wMoV8Y9DlG0bN+k1/Ae9j3Eb41W2xxbPII9g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0CMXIZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0CMXIZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5063DC4CEF0;
	Tue, 12 Aug 2025 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026394;
	bh=JxVUSCiP3ObFL3t6jiDXG1jznHGfTD9gOOYPl0bMQrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0CMXIZTCBa5siIlUpTwnLM7c+cI4tHlLGp2VjstjnVPexGGg1Hq+/UWKbl11bAgZ
	 szwerUTxt9hdaOI6ah3Hu9s3zj4ErimQlCZHQNQX8CXupaKwp0Ue+s+vRKJ60i6ovz
	 DHTJzLIw/xYCUwwiKF5JXi/a195Jf3K1ooomUVLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 323/480] perf record: Cache build-ID of hit DSOs only
Date: Tue, 12 Aug 2025 19:48:51 +0200
Message-ID: <20250812174410.762565507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 6235ce77749f45cac27f630337e2fdf04e8a6c73 ]

It post-processes samples to find which DSO has samples.  Based on that
info, it can save used DSOs in the build-ID cache directory.  But for
some reason, it saves all DSOs without checking the hit mark.  Skipping
unused DSOs can give some speedup especially with --buildid-mmap being
default.

On my idle machine, `time perf record -a sleep 1` goes down from 3 sec
to 1.5 sec with this change.

Fixes: e29386c8f7d71fa5 ("perf record: Add --buildid-mmap option to enable PERF_RECORD_MMAP2's build id")
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250731070330.57116-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/build-id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e763e8d99a43..ee00313d5d7e 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -864,7 +864,7 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 	char *allocated_name = NULL;
 	int ret = 0;
 
-	if (!dso__has_build_id(dso))
+	if (!dso__has_build_id(dso) || !dso__hit(dso))
 		return 0;
 
 	if (dso__is_kcore(dso)) {
-- 
2.39.5



