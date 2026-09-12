Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39453F7877;
	Sat, 12 Sep 2026 08:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201994; cv=none; b=P0OMKPm+YE/aaQC3+6XuIiJ8xMLOqT0R21Xj/t0pPKygwQfyQCSy6lkE7p95ilvZRyj+IdussC1EgDkK2LiGDitv1/QOgntY4IOKrM6rhMwL1KZ9+B8ktqvBtAxXRAd6Klc6cW3d7XUU0w1jv7tVogpALnB5nJzwhh4ifArfrhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201994; c=relaxed/simple;
	bh=Skg7ZQIQRMQ4+E9Arf1FbXjLO8uK72bV7216X5hF6UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7QCfw5Kz08krSm87+Vfxv83JsO80qCVHcEsrVVvhqjEpDMNT+ndbI9/fle5PoN6ZtZ8xj7nILSXSHdVrz4tm7E/p9K4iY28bCE554KCFnKoyEjVBNJZmOVT/+Uhv4gxHmPUZX0YmrknQB4l7pzjSTawBjIMl9yjy2a30XnIJD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDbaojz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDbaojz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDD31F000FF;
	Sat, 12 Sep 2026 08:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201993;
	bh=Z019jZr6bdcNVkJYrUaxSE+6yC4KDao1WRr9CpiZLLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDbaojz39xQBDhac6LPO0WF3qhPX9Eb+SbMtWmJ3NzzZTyRhwPAEDOtfzFkj5L4p3
	 zzBKuU+5p4OWSUtUaJJ66lSDL6ihT/fcjDY/6aw6T9DL8TIGBILfJO44kS9cLZYZS+
	 4jQxOancUG7Z6GaW05YJaNwAhAVzRDCm1+2tXVw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1112/1815] perf header: Use write lock when translating BPF prog info pointers
Date: Sat, 12 Sep 2026 08:47:42 +0200
Message-ID: <20260912065715.123878866@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 60f2f5b7650bb8779af3087ef429fad4ed74a5c8 ]

write_bpf_prog_info() holds a read lock while temporarily mutating
info_linear via bpil_addr_to_offs()/bpil_offs_to_addr().  Between these
two calls, the pointers in info_linear contain file offsets instead of
heap addresses.  Concurrent readers holding the same read lock see the
file offsets and dereference them as pointers.

Use down_write()/up_write() instead of down_read()/up_read() to exclude
concurrent readers during the addr-to-offset-to-addr translation window.

Fixes: 63ac7968a1fb ("perf bpf: Save bpf_prog_info information as headers to perf.data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e90e541f546b4..7db7da090a1e0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1120,7 +1120,8 @@ static int write_bpf_prog_info(struct feat_fd *ff  __maybe_unused,
 	struct rb_node *next;
 	int ret = 0;
 
-	down_read(&env->bpf_progs.lock);
+	/* write lock: bpil_addr_to_offs() temporarily mutates info_linear */
+	down_write(&env->bpf_progs.lock);
 
 	ret = do_write(ff, &env->bpf_progs.infos_cnt,
 		       sizeof(env->bpf_progs.infos_cnt));
@@ -1150,7 +1151,7 @@ static int write_bpf_prog_info(struct feat_fd *ff  __maybe_unused,
 			goto out;
 	}
 out:
-	up_read(&env->bpf_progs.lock);
+	up_write(&env->bpf_progs.lock);
 	return ret;
 #else
 	pr_err("ERROR: Trying to write bpf_prog_info without libbpf support.\n");
-- 
2.53.0



