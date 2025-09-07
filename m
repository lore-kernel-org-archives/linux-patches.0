Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03AF315D54;
	Sun,  7 Sep 2025 20:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277350; cv=none; b=qYgGv6zlBVjpI+wI2JniXrrm43MQqcTucL/p1/proVXunlkaAMR9ooYUL55H6cYY9H3J0DSH3Mo+CgSZO5OpXpnDuprXHyBuFS6j1E0wkkjvkbJi8v11okoZsnnZ1WpMas3LXdY5cILfM7b29N5zKFJQcenaObcxn/WUkNf1sag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277350; c=relaxed/simple;
	bh=92UXg2wYD6rAAybStowipLP/hG/qqB84BgqJ2c44/zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snnGHMkurhfSLen882QYePdGn9PHu0IDI84+49un9lmLC1GKWuIzfrwJVz2BZpY2Sd96l7bAWOZk96trCqo6L/CR05Fim4ZgEUv+49oLWPDn2YkzEW22l3g+M8Yw0ISy47xcMGV8k3hI3TRYyOcnkXB3FUD2H3A1dSc5Q14zhF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcQ74oDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcQ74oDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEB4C4CEF8;
	Sun,  7 Sep 2025 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277349;
	bh=92UXg2wYD6rAAybStowipLP/hG/qqB84BgqJ2c44/zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcQ74oDQXELJKyQFOtXzy2/KGBHyek9gvuxDUY0ul7v4nKwpm2/0FOpxXv+0WRq8p
	 VwiEp1aMTlac3TkwEbUgtGeF/D4tax0H8LBs9yBTLIbgIEwTbv0pdQqMRHUVcKvkm4
	 i9CiBpAZ+Nnkw6LRqR2sbPhTDl2wykzfpMtM+Kbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/175] perf bpf-event: Fix use-after-free in synthesis
Date: Sun,  7 Sep 2025 21:59:17 +0200
Message-ID: <20250907195618.689451217@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d7b67dd6f9db7bd2c49b415e901849b182ff0735 ]

Calls to perf_env__insert_bpf_prog_info may fail as a sideband thread
may already have inserted the bpf_prog_info. Such failures may yield
info_linear being freed which then causes use-after-free issues with
the internal bpf_prog_info info struct. Make it so that
perf_env__insert_bpf_prog_info trigger early non-error paths and fix
the use-after-free in perf_event__synthesize_one_bpf_prog. Add proper
return error handling to perf_env__add_bpf_info (that calls
perf_env__insert_bpf_prog_info) and propagate the return value in its
callers.

Closes: https://lore.kernel.org/lkml/CAP-5=fWJQcmUOP7MuCA2ihKnDAHUCOBLkQFEkQES-1ZZTrgf8Q@mail.gmail.com/
Fixes: 03edb7020bb9 ("perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250902181713.309797-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 39 +++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index c81444059ad07..d9123c9637baa 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -290,9 +290,15 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 
 		info_node->info_linear = info_linear;
 		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
-			free(info_linear);
+			/*
+			 * Insert failed, likely because of a duplicate event
+			 * made by the sideband thread. Ignore synthesizing the
+			 * metadata.
+			 */
 			free(info_node);
+			goto out;
 		}
+		/* info_linear is now owned by info_node and shouldn't be freed below. */
 		info_linear = NULL;
 
 		/*
@@ -451,18 +457,18 @@ int perf_event__synthesize_bpf_events(struct perf_session *session,
 	return err;
 }
 
-static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
+static int perf_env__add_bpf_info(struct perf_env *env, u32 id)
 {
 	struct bpf_prog_info_node *info_node;
 	struct perf_bpil *info_linear;
 	struct btf *btf = NULL;
 	u64 arrays;
 	u32 btf_id;
-	int fd;
+	int fd, err = 0;
 
 	fd = bpf_prog_get_fd_by_id(id);
 	if (fd < 0)
-		return;
+		return -EINVAL;
 
 	arrays = 1UL << PERF_BPIL_JITED_KSYMS;
 	arrays |= 1UL << PERF_BPIL_JITED_FUNC_LENS;
@@ -475,6 +481,7 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	info_linear = get_bpf_prog_info_linear(fd, arrays);
 	if (IS_ERR_OR_NULL(info_linear)) {
 		pr_debug("%s: failed to get BPF program info. aborting\n", __func__);
+		err = PTR_ERR(info_linear);
 		goto out;
 	}
 
@@ -484,38 +491,46 @@ static void perf_env__add_bpf_info(struct perf_env *env, u32 id)
 	if (info_node) {
 		info_node->info_linear = info_linear;
 		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
+			pr_debug("%s: duplicate add bpf info request for id %u\n",
+				 __func__, btf_id);
 			free(info_linear);
 			free(info_node);
+			goto out;
 		}
-	} else
+	} else {
 		free(info_linear);
+		err = -ENOMEM;
+		goto out;
+	}
 
 	if (btf_id == 0)
 		goto out;
 
 	btf = btf__load_from_kernel_by_id(btf_id);
-	if (libbpf_get_error(btf)) {
-		pr_debug("%s: failed to get BTF of id %u, aborting\n",
-			 __func__, btf_id);
-		goto out;
+	if (!btf) {
+		err = -errno;
+		pr_debug("%s: failed to get BTF of id %u %d\n", __func__, btf_id, err);
+	} else {
+		perf_env__fetch_btf(env, btf_id, btf);
 	}
-	perf_env__fetch_btf(env, btf_id, btf);
 
 out:
 	btf__free(btf);
 	close(fd);
+	return err;
 }
 
 static int bpf_event__sb_cb(union perf_event *event, void *data)
 {
 	struct perf_env *env = data;
+	int ret = 0;
 
 	if (event->header.type != PERF_RECORD_BPF_EVENT)
 		return -1;
 
 	switch (event->bpf.type) {
 	case PERF_BPF_EVENT_PROG_LOAD:
-		perf_env__add_bpf_info(env, event->bpf.id);
+		ret = perf_env__add_bpf_info(env, event->bpf.id);
 
 	case PERF_BPF_EVENT_PROG_UNLOAD:
 		/*
@@ -529,7 +544,7 @@ static int bpf_event__sb_cb(union perf_event *event, void *data)
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env)
-- 
2.51.0



