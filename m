Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31842384CDF;
	Sat, 12 Sep 2026 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224454; cv=none; b=EZcq41SlRJOkePmUhJRHL6MPvCZxqe1OQQdPicT/v2nNNdPfnUuVUQwcl2QCNWKugI3ZRU1MCfgl+Ca6KMwkiPnDcgjBUpPf+M8kwWlL9bWXMyNsnTNDoTQnhyvcEyL8prYzBufFl45Ky1JkUs6TQnrg1gI3kcYyAJClRSGwL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224454; c=relaxed/simple;
	bh=zMjWvkh+lvN9TVedWkxqwjZmLfAZS+Q1QyWTLYyXcO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf2FgFexLSfVmHjSM5BkDdY2M3/uqWSYbudSyzn02pqtJh8lpQ1fIYmpSh5RL9ASBl6X/acnIs/9KwEnkIDVEuCQ/3tsoyD/g8Qlj9HKWkkv0drhm2Mj5CacwwDoJ+Lpdm5nX4ScD56Q/Gr1vf75UiOLPPhxuiTk1rQCd8VaD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqgc99zi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqgc99zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CFE1F000FF;
	Sat, 12 Sep 2026 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224453;
	bh=AjLijhhz3tuSPOWpz6d3pk6Dkz3ggXG1IknQmUaSjHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqgc99ziCEgsPeq0tVRdbSPsMNhI2Tz+A2Y+4hOOFvZsgQZKIfiLKcx897FKyZtl+
	 yUfBuzPQF7BiBSFfNLMsRVxbakD9PwPWWyfZy4/FwnAmfIk6v4k7ebJRkCEsxyAIrJ
	 2M2H7d7cUuJAVXDAxFcnt3IQ5QoBHvhiKqCEWedo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0994/1424] perf machine: Check snprintf truncation for guest kallsyms path
Date: Sat, 12 Sep 2026 08:57:06 +0200
Message-ID: <20260912065629.576984132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d04ef71492fad7230d474efe33d05f4c0563d409 ]

machines__create_guest_kernel_maps() builds the guest kallsyms path
with snprintf() without checking the return value.  A truncated path
could pass the access() check if a prefix directory happens to contain
a file named "kallsyms", leading to the wrong file being used for
symbol resolution.

Check for truncation and skip the directory.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e1fd1c35816c3..9ea386614df65 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1424,9 +1424,14 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				free(namelist[i]);
 				continue;
 			}
-			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
-				 symbol_conf.guestmount,
-				 namelist[i]->d_name);
+			if (snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				     symbol_conf.guestmount,
+				     namelist[i]->d_name) >= (int)sizeof(path)) {
+				pr_debug("Guest kallsyms path too long for %s. Skipping.\n",
+					 namelist[i]->d_name);
+				free(namelist[i]);
+				continue;
+			}
 			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
 				free(namelist[i]);
-- 
2.53.0



