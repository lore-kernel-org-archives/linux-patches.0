Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70B926869D;
	Tue,  8 Apr 2025 11:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111622; cv=none; b=PbCYq6Bz22KN6zXaAl1mRpN8IAP3dcaRzgSEr1tjnJyLc0j3V8Ag8kdNZe+DhJ5mL690LIEoEL172RbyXe3upf2Tu3nQmZ8KxZGumXyDT7ZQMTKWGyr57iJocqjGV/n8ort5ikdhpI7OXlPobT3VF5ISj8d5g5DJQn8famv0hGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111622; c=relaxed/simple;
	bh=P3i20FLyNYsc84RINCLYgsIx2HipLv08JykBQe+c1qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFZ5Jgg4fP7RKuuNj1sf2e73J2Hjct/OIOgIvBw2dK/+TKX4fJkPS2BWfxqAAKdZeRZ/Fu36j8dOHNqJf44T8sGz6ol1CtormWkaDbR1KK7wfDgUq6iVChzm8EPvCuBOnte7PdEj4sVTkkNaLf+pu1P/I0i387ElHT+4P2ghRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0O8DWuMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0O8DWuMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D26C4CEE5;
	Tue,  8 Apr 2025 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111622;
	bh=P3i20FLyNYsc84RINCLYgsIx2HipLv08JykBQe+c1qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0O8DWuMl8kAgesTCQTzGu0OZiG2NTzEuB3+fW/RWw08nGhxereIT+AmSEPtC1Ql9g
	 1bAR2YQtqkHmfxgT2oR0Jb+aSbfJ/rdLpPORewxKX5ihcA6e26OLvHjyraQ8i8CBc3
	 7MZMcHaszd7Sf0gMurOmSJy8m+0K57PMnQI4BHWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 497/731] perf debug: Avoid stack overflow in recursive error message
Date: Tue,  8 Apr 2025 12:46:34 +0200
Message-ID: <20250408104925.835735129@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit bda840191d2aae3b7cadc3ac21835dcf29487191 ]

In debug_file, pr_warning_once is called on error. As that function
calls debug_file the function will yield a stack overflow. Switch the
location of the call so the recursion is avoided.

Reviewed-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250228222308.626803-2-irogers@google.com
Fixes: ec49230cf6dda704 ("perf debug: Expose debug file")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 995f6bb05b5f8..f9ef7d045c92e 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -46,8 +46,8 @@ int debug_type_profile;
 FILE *debug_file(void)
 {
 	if (!_debug_file) {
-		pr_warning_once("debug_file not set");
 		debug_set_file(stderr);
+		pr_warning_once("debug_file not set");
 	}
 	return _debug_file;
 }
-- 
2.39.5



