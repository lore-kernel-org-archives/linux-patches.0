Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECEA35C1A6;
	Tue, 21 Jul 2026 19:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662829; cv=none; b=TqWUIhg7XtLYo/1Gkd/n6vrU8vgHiD5NMil65IV2EsiD8WkAGc+qLBh1LonJDsHBL9HEZYMeHZn+RYlMc5dq3ESkB4ulg9EqZwrpf1hIQRbyJn9Az1tgpIdkVtRuTk0fMWLmizKlAlqq8nS9qBRNw1Uw5QlgJvi64WK6okazO1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662829; c=relaxed/simple;
	bh=LC66wlaQL/mU9Tq7Drr9FK+pdMhdJDK4HygK7SYEtYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8XulNkMcTjWO76OHXPqk7llu8I53MnWD65Ee1qkm/iIyRteTwqfSEb2jOeS949VwwFDCsMkx64LrBNjGjT0yjPmSGWTtpkyS59gN8j+Np5vgy4uNUHoRLXuIKI3+gVQdxdgY5Ho6RZDplqY7AkJQwbe1QuFU93lr7U6UH+Bk5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBAD8Bwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBAD8Bwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48761F000E9;
	Tue, 21 Jul 2026 19:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662827;
	bh=tG9g1zKGB4dIzN4w8O0WUTxPxv1zvsH8qYQBTn+Su2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBAD8Bwd4VhrU3Y6WyRSyyDy6+uopBispRWbzCOu7rfcDXxLGwx+nz4i2UqZ+R2+H
	 Ja/nAeyOCaPFY7Jy+M/6zORJSy8XfZC7wkNypKSnLq18rQ3iYWHGHX1k1O78eqEDlb
	 NDMKryo188ps7wKV+BgAQVd0Q3q4ho4EyymOq0Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Zhang Yanmin <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0555/1276] perf tools: Use snprintf() for root_dir path construction
Date: Tue, 21 Jul 2026 17:16:38 +0200
Message-ID: <20260721152458.538281048@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7b0df6f4d498b1608afccfd6dffb264e6da91693 ]

get_kernel_version() in machine.c and dso__load_guest_kernel_sym() in
symbol.c use sprintf() to construct paths by prepending root_dir to
"/proc/version" and "/proc/kallsyms" respectively.  Both write into
PATH_MAX stack buffers, but root_dir comes from --guestmount or KVM
configuration and is not length-checked.  A root_dir at or near
PATH_MAX causes a stack buffer overflow.

Switch to snprintf() with sizeof(path) to prevent overflow.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: a1645ce12adb6c9c ("perf: 'perf kvm' tool for monitoring guest performance from host")
Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 tools/perf/util/symbol.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 557853fcb5479b..71d3d034ba095e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1294,7 +1294,7 @@ static char *get_kernel_version(const char *root_dir)
 	char *name, *tmp;
 	const char *prefix = "Linux version ";
 
-	sprintf(version, "%s/proc/version", root_dir);
+	snprintf(version, sizeof(version), "%s/proc/version", root_dir);
 	file = fopen(version, "r");
 	if (!file)
 		return NULL;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e792dd22b54983..92b31c1a73a839 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2270,7 +2270,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map)
 		if (!kallsyms_filename)
 			return -1;
 	} else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		snprintf(path, sizeof(path), "%s/proc/kallsyms", machine->root_dir);
 		kallsyms_filename = path;
 	}
 
-- 
2.53.0



