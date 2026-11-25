Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622388;
	b=3++6dZdsQA8zN7qgLSUPBqAHIzXLk2rpWU+oggpqA/WKvQwW2iAMgE6J0ezfaz+EaKIZ
	 MJyxmA5//lydSzhgb+Y7xsuKBJBkdURylsbscGZ9MhkfzIP05O1xYCmoUq0nutF4vlIQ6
	 l/PoAI4R8/0Irzjt24GovnQZVv1m8g/Edw9JRQjQHXAO8MMgebShF4ki+SPNGEFKN1Q5R
	 UnKSoMLHwwJa/jKAJw/01dN9JpZPuVVMmnxGLFt2N+SIClf+FKy72pmiQVLAY9iIb2p9j
	 mJ/mAamm7ORXgLKAeeSBTOgXCTLbYXao1Agz7zlqkHd1tuVl47zD/IE51p6p+0bxzUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmturqQFg+F5xdT02dEX9m+OacOP2raNTFW5o6ZPcyY=;
	b=35hVdOTWfJ5sbqG6oHHlx3Kl0cM/fM4xytlp91sXypo68gTFDsG7N5DN8SaZrheGOsBf
	 jZNMDQzRvNAt7QJIhuFeHNfnHH8lSqeYyxLtC2YKoINlijFGJ6i+GBWdT5fdH7SncqcPb
	 1ljVIJXefRrfS8lfsdpzGLG3a2kYjND4Qu9m0IkGslXSV/55F1bquzJqsOHEk3pOCkAEW
	 g9CsZ1lDminlw+fPyZI7irvKv35OMmBBfxZoGYwJqLF1Oy+SVouxTLkuwJ3AkQrNUJV+r
	 P2c+FArPyFN6eAFzsJRfpmuYbXYc4BSH+9gWiGSwKnrMnHN6Q4J/ZUSj70nZZsU9kWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qoH2gBR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29BB606A31E;
	Wed, 25 Nov 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qoH2gBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB98D1F000CA;
	Wed, 25 Nov 2026 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622387;
	bh=rmturqQFg+F5xdT02dEX9m+OacOP2raNTFW5o6ZPcyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qoH2gBRQQqktaFpOiA66kucy2Ct6uws+EvEf8xXNpYF8P9l99tPBubq1AbEOUrK/
	 A7RWhHoxK7gVPjYtC3uwvuEsdkOL5rc8q5Nu5a+wN9NudxPdBnus1qCKpgpYvx6+Qp
	 GrAQb9oSh0dxHZCbiPJcDOEUxHh4fJgcHaQrfbso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/990] perf dso: Separate libbfd and cmd addr2line caches to fix confusion
Date: Wed, 25 Nov 2026 15:31:28 +0100
Message-ID: <20261125143834.299777122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f651c02755af85324ad029cd948a8e570d0769fb ]

When a dso executes addr2line via libbfd it instantiates an a2l_data
pointer. If the DSO later executes via the command-line fallback due
to an inlined bug, the a2l pointer is unconditionally populated with a
child_process process wrapper.

If libbfd is queried again, the offline reader attempts to cast struct
a2l_data into child_process, coercing random arbitrary instruction
addresses and causing silent aborts. This cleanly splits the caches.

Fixes: 257046a36750a6db ("perf srcline: Fallback between addr2line implementations")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Adapted to a tree where dso__set_symsrc_filename() is a plain inline setter and libbfd__addr2line() is unlocked, so the symsrc cache-free and lock context were left out. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c     |  2 ++
 tools/perf/util/dso.h     | 15 +++++++++++++++
 tools/perf/util/libbfd.c  | 10 +++++-----
 tools/perf/util/srcline.c |  2 ++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 70daf4fd200e3..f381ac71e8a57 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -32,6 +32,7 @@
 #include "string2.h"
 #include "vdso.h"
 #include "annotate-data.h"
+#include "libbfd.h"
 
 static const char * const debuglink_paths[] = {
 	"%.0s%s",
@@ -1668,6 +1669,7 @@ void dso__delete(struct dso *dso)
 	auxtrace_cache__free(RC_CHK_ACCESS(dso)->auxtrace_cache);
 	dso_cache__free(dso);
 	dso__free_a2l(dso);
+	dso__free_a2l_libbfd(dso);
 	dso__free_symsrc_filename(dso);
 	nsinfo__zput(RC_CHK_ACCESS(dso)->nsinfo);
 	mutex_destroy(dso__lock(dso));
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index b374dfabf49cc..a580e7a58078a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -303,6 +303,9 @@ DECLARE_RC_STRUCT(dso) {
 	const char	 *short_name;
 	const char	 *long_name;
 	void		 *a2l;
+#ifdef HAVE_LIBBFD_SUPPORT
+	void		 *a2l_libbfd;
+#endif
 	char		 *symsrc_filename;
 #if defined(__powerpc__)
 	void		*dwfl;			/* DWARF debug info */
@@ -369,6 +372,18 @@ static inline void dso__set_a2l(struct dso *dso, void *val)
 	RC_CHK_ACCESS(dso)->a2l = val;
 }
 
+#ifdef HAVE_LIBBFD_SUPPORT
+static inline void *dso__a2l_libbfd(const struct dso *dso)
+{
+	return RC_CHK_ACCESS(dso)->a2l_libbfd;
+}
+
+static inline void dso__set_a2l_libbfd(struct dso *dso, void *val)
+{
+	RC_CHK_ACCESS(dso)->a2l_libbfd = val;
+}
+#endif
+
 static inline unsigned int dso__a2l_fails(const struct dso *dso)
 {
 	return RC_CHK_ACCESS(dso)->a2l_fails;
diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 47d691e4af323..8771a6541f8b4 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -227,7 +227,7 @@ static int inline_list__append_dso_a2l(struct dso *dso,
 				       struct inline_node *node,
 				       struct symbol *sym)
 {
-	struct a2l_data *a2l = dso__a2l(dso);
+	struct a2l_data *a2l = dso__a2l_libbfd(dso);
 	struct symbol *inline_sym = new_inline_sym(dso, sym, a2l->funcname);
 	char *srcline = NULL;
 
@@ -243,11 +243,11 @@ int libbfd__addr2line(const char *dso_name, u64 addr,
 		      struct symbol *sym)
 {
 	int ret = 0;
-	struct a2l_data *a2l = dso__a2l(dso);
+	struct a2l_data *a2l = dso__a2l_libbfd(dso);
 
 	if (!a2l) {
 		a2l = addr2line_init(dso_name);
-		dso__set_a2l(dso, a2l);
+		dso__set_a2l_libbfd(dso, a2l);
 	}
 
 	if (a2l == NULL) {
@@ -299,14 +299,14 @@ int libbfd__addr2line(const char *dso_name, u64 addr,
 
 void dso__free_a2l_libbfd(struct dso *dso)
 {
-	struct a2l_data *a2l = dso__a2l(dso);
+	struct a2l_data *a2l = dso__a2l_libbfd(dso);
 
 	if (!a2l)
 		return;
 
 	addr2line_cleanup(a2l);
 
-	dso__set_a2l(dso, NULL);
+	dso__set_a2l_libbfd(dso, NULL);
 }
 
 static int bfd_symbols__cmpvalue(const void *a, const void *b)
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 27c0966611abb..467cdd8353aa2 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -192,6 +192,7 @@ char *__get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 	if (dso__a2l_fails(dso) > A2L_FAIL_LIMIT) {
 		dso__set_has_srcline(dso, false);
 		dso__free_a2l(dso);
+		dso__free_a2l_libbfd(dso);
 	}
 out:
 	if (!show_addr)
@@ -232,6 +233,7 @@ char *get_srcline_split(struct dso *dso, u64 addr, unsigned *line)
 	if (dso__a2l_fails(dso) > A2L_FAIL_LIMIT) {
 		dso__set_has_srcline(dso, false);
 		dso__free_a2l(dso);
+		dso__free_a2l_libbfd(dso);
 	}
 
 	return NULL;
-- 
2.53.0



