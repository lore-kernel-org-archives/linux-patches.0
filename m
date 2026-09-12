Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40FF19D8BC;
	Sat, 12 Sep 2026 07:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198146; cv=none; b=Otb7k8bH8Bf8bAFoSvvh9+dzssyMy51D/+ZWt+9bu/YbeMnfaNxmmHVTtk/4DHZfYvaOrJOWviZIVEkozhTtGEaPtap164u6Tvv1mujLjIHKoIImypKioWxPbIgJV/9vclKZUagzRoie0pLVyYXin33ikUolq/AuJ3pygrVHcOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198146; c=relaxed/simple;
	bh=f/8QFCZ934UceEmfZ/rMNt7ieyxNctMhIHmMuTvg6QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSIyMEv2/I/21z6FR1bO4cIi+PSlR9+ta3AqZdr/ZOcOVkgJyUrqY/ediGk0Ed3unmtP83Rd/vI/PS6gdTtcNfM+XVsQN6+01P+87mFSjsXocA14sxTLq10TKUjrbbznUUvKeGEs4YoDiwGGRLMcKoVJG1SsrJRPy+K6JZTxXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iksBZAb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iksBZAb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF071F000FF;
	Sat, 12 Sep 2026 07:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198145;
	bh=2/L42cjEHZMJscnt4UOG8tbKIuUk5IzoFpIbYsWb0jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iksBZAb75WcyQdf6NOxE1H9slNoCtvLBkbTDd3mQMMQAE0VAEWnv9Re5K9LaMA8VH
	 uHlWS+kx/iB/7Gih11rMZR2jkrNOJPnInp0iWIsROP6mtQw18hiZICnDDg/bkW9rQd
	 xx7N/UuMOfIe1ENvAQYbgu0QtQ5a9GDydcSVSJwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0278/1815] perf dso: Fix kallsyms DSO detection with fallback logic
Date: Sat, 12 Sep 2026 08:33:48 +0200
Message-ID: <20260912065655.490467780@linuxfoundation.org>
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit 8c5f60344b07f839267c0c835962e2206143be85 ]

The current kallsyms detection in dso__is_kallsyms() uses the
dso_binary_type enum which fixes the issue of kallsyms being cached in
the build-id cache for out-of-tree modules.

However, during build-id injection in perf record/inject, dso_binary_type
has not been explicitly set yet,so dso__binary_type() returns
DSO_BINARY_TYPE__NOT_FOUND instead of DSO_BINARY_TYPE__KALLSYMS for the
kernel DSO. The current check then fails to identify it as kallsyms,
causing build-id symlinks to not be created in ~/.debug/.build-id/ and
perf archive to fail with "Cannot stat" errors.

Steps to reproduce the issue:
1. rm -rf ~/.debug/.build-id
2. perf record sleep 1
3. perf archive

Fix by falling back to matching long_name against the known kallsyms
strings explicitly when binary_type is not yet set
(== DSO_BINARY_TYPE__NOT_FOUND). Use strcmp() for exact matching of
fixed names and strict validation for guest kallsyms with embedded PID
to prevent path traversal attacks.

Fixes: ebf0b332732d ("perf dso: fix dso__is_kallsyms() check")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.h | 57 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 2916b954a804b..55c4aaa53c382 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -9,6 +9,7 @@
 #include <stdbool.h>
 #include <stdio.h>
 #include <linux/bitops.h>
+#include <string.h>
 #include "build-id.h"
 #include "debuginfo.h"
 #include "mutex.h"
@@ -20,6 +21,40 @@ struct perf_env;
 
 #define DSO__NAME_KALLSYMS	"[kernel.kallsyms]"
 #define DSO__NAME_KCORE		"[kernel.kcore]"
+#define DSO__NAME_GUEST_KALLSYMS		"[guest.kernel.kallsyms]"
+#define DSO__NAME_GUEST_KALLSYMS_PID_PREFIX	"[guest.kernel.kallsyms."
+
+/*
+ * Validate names of the form "[guest.kernel.kallsyms.<pid>]", where
+ * <pid> is the PID of the guest VM and varies per guest, so it
+ * cannot be matched with strcmp() against a fixed string.
+ *
+ * Every character after the fixed prefix must be a decimal digit,
+ * with ']' immediately terminating the digit run and nothing
+ * following it. This rules out '/', "..", or any other character
+ * being smuggled into the name.
+ */
+static inline bool is_guest_kallsyms_pid_name(const char *name)
+{
+	const size_t prefix_len = sizeof(DSO__NAME_GUEST_KALLSYMS_PID_PREFIX) - 1;
+	size_t digits;
+
+	if (strncmp(name, DSO__NAME_GUEST_KALLSYMS_PID_PREFIX, prefix_len) != 0)
+		return false;
+
+	digits = strspn(name + prefix_len, "0123456789");
+	if (digits == 0)
+		return false;
+
+	/* ']' must terminate the digit run, with nothing trailing it */
+	if (name[prefix_len + digits] != ']')
+		return false;
+
+	if (name[prefix_len + digits + 1] != '\0')
+		return false;
+
+	return true;
+}
 
 /**
  * enum dso_binary_type - The kind of DSO generally associated with a memory
@@ -924,8 +959,28 @@ static inline bool dso__is_kcore(const struct dso *dso)
 static inline bool dso__is_kallsyms(const struct dso *dso)
 {
 	enum dso_binary_type bt = dso__binary_type(dso);
+	const char *name;
+
+	if (bt == DSO_BINARY_TYPE__KALLSYMS || bt == DSO_BINARY_TYPE__GUEST_KALLSYMS)
+		return true;
+
+	if (bt != DSO_BINARY_TYPE__NOT_FOUND)
+		return false;
+
+	if (!dso__kernel(dso))
+		return false;
+
+	name = dso__long_name(dso);
+	if (!name)
+		return false;
+
+	if (!strcmp(name, DSO__NAME_KALLSYMS))
+		return true;
+
+	if (!strcmp(name, DSO__NAME_GUEST_KALLSYMS))
+		return true;
 
-	return bt == DSO_BINARY_TYPE__KALLSYMS || bt == DSO_BINARY_TYPE__GUEST_KALLSYMS;
+	return is_guest_kallsyms_pid_name(name);
 }
 
 bool dso__is_object_file(const struct dso *dso);
-- 
2.53.0



