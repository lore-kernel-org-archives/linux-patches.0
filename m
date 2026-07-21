Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CE63C1081;
	Tue, 21 Jul 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671945; cv=none; b=oUSAOg6vYcqCwffH2MPbBYgkKyXwZKkTvAgp7q1xeBovurKsHXWuF0PwZkfQmD8i7pZMksUUVqtDxM3B4fOIC48wJwWjeEaXUM6n6FYuQIyCxkn9TVNOs0Sb7gqTvSjB5V39FNuAdJCHi6m5nwblBPDJ/UqudLAZ3cQFUUt6XJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671945; c=relaxed/simple;
	bh=t3QNcYA/a/GLDbS+DJek1j9K+9haifXkVF+Jmg7HN6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+aXH8Drn6bkdG/L589L+y4GV9pHqv5cPOsFg9Xwft5XQqFHsdcS6QXzsBOZ6q3kFlr5YRcHHz+dsJ343Pw7ClWdi3DbOozSJVcm1Sy8zh4++wr061ni9XRAawG69a6QSmPxCx0ZWOrLJSMxS3hSVtD7/wSMVDHcPJuL59Q1ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNDga9x4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNDga9x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6AC1F00A3A;
	Tue, 21 Jul 2026 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671944;
	bh=vwoZIPr14vYmzg96pWh4s64FhkEpRaeC8e2sJXkUlbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNDga9x4c156zwN88A7XL7yFH+pze132AH/LX0TCcILWHwp9xu4REtGwYp3atWBH7
	 aTIsamo6eX2mgRXwxavBNIewUlID8HslediFXthKh/Q2UHGtzmoa8tIXGENMQZs/VK
	 mK0tODFrpbSStn/aSeQ04jnIDre2S7q4g/ZiJbvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Zhang Yanmin <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/843] perf tools: Use snprintf() for root_dir path construction
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152415.863231413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0df9d24b2cb47..7e7c63fcd14068 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1338,7 +1338,7 @@ static char *get_kernel_version(const char *root_dir)
 	char *name, *tmp;
 	const char *prefix = "Linux version ";
 
-	sprintf(version, "%s/proc/version", root_dir);
+	snprintf(version, sizeof(version), "%s/proc/version", root_dir);
 	file = fopen(version, "r");
 	if (!file)
 		return NULL;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b48d237124e121..51e86e3d2e674a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2313,7 +2313,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map)
 		if (!kallsyms_filename)
 			return -1;
 	} else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		snprintf(path, sizeof(path), "%s/proc/kallsyms", machine->root_dir);
 		kallsyms_filename = path;
 	}
 
-- 
2.53.0



