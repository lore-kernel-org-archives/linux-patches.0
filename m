Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869743D51D;
	Tue, 21 Jul 2026 22:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673831; cv=none; b=dHpvhjznXsIBVKIder87xNcSu9gDhbL7YuZpYze5L6IlwlRzjghTFHDFsiwqH/Q6oPzVfjEXH6Tuu4bjEvWEZTfmKkXWWuB/YnQWiamq+NCx8fjnRb8L9ku1a5Tk5F6tEWEF5OMNvU1KuUFwInGbG3oLZNvtylttj2Pz/PLKajk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673831; c=relaxed/simple;
	bh=QmaJv8o5mWE+qDwd+9C6wEXQMe2EoZW4MFlCh7aHMYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDCL8nGeX0FqSXcZvhcK7Qsgv6j06a/xlY8sRQm2sxhXJD21/kMvR4SFpfV2CKetCMicPBeMdC47RFvbe0yU1odw+cyGCDajgvw9m97iCDpbrUoRA2evEsBD76Z1JjMp+R7k11xQZdua91fpLlXMIsTvMfh/sa4J+USC3sW1k4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkpgfPNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkpgfPNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B07F1F000E9;
	Tue, 21 Jul 2026 22:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673829;
	bh=GZllK+8L49Farr/YB7J819erIbMHRMDGolv01joDHuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkpgfPNrPYmaY6b0EtwKIYMZWVlnqIdo+/3WwdvGmsgOW0ylo/t/76iwtu5QU6GCG
	 TYJ5wy6ruERH+liKq+qhtcvayOCqQ51rOImAarJLDmIrP5qXCHsLRL59xzNo15kktj
	 t1/Aks3r1Rr/0WPkZU8CDTpuWbF2OsOPkxUlothY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/699] perf sched: Fix idle-hist callchain display using wrong rb_first variant
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152402.665692782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d9b99dc8148e0c1f5da3942131b47e0d21187a32 ]

timehist_print_idlehist_callchain() calls rb_first_cached() on
sorted_root, but the sort function (callchain_param.sort) populates it
via rb_insert_color() on the plain rb_root member — not the cached
variant.  This means rb_leftmost is never set, so rb_first_cached()
always returns NULL and the entire callchain summary is silently
dropped from --idle-hist output.

The original code in ba957ebb54893aca ("perf sched timehist: Show
callchains for idle stat") was correct — it used struct rb_root and
rb_first().  The bug was introduced when sorted_root was converted to
rb_root_cached without converting the sort insertion path to use
rb_insert_color_cached().

Use rb_first(&root->rb_root) to match how the tree was populated.

Fixes: cb4c13a5137766c3 ("perf sched: Use cached rbtrees")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ef535cf8d77a4e..c5d31851a64d2c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2820,7 +2820,8 @@ static size_t timehist_print_idlehist_callchain(struct rb_root_cached *root)
 	size_t ret = 0;
 	FILE *fp = stdout;
 	struct callchain_node *chain;
-	struct rb_node *rb_node = rb_first_cached(root);
+	/* sort() uses rb_insert_color() on rb_root, not rb_root_cached */
+	struct rb_node *rb_node = rb_first(&root->rb_root);
 
 	printf("  %16s  %8s  %s\n", "Idle time (msec)", "Count", "Callchains");
 	printf("  %.16s  %.8s  %.50s\n", graph_dotted_line, graph_dotted_line,
-- 
2.53.0



