Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B68409277;
	Tue, 21 Jul 2026 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660552; cv=none; b=NXFt0eEqQKmUXkc9t/3pstg7YHQP7DwHkxQCOsNSZDWh5xZo+ISF4wFVyfks/5ygbWeenU2wWGLvEM6G6WfcZ6mIjFR9NAXAlN3Zai74ceGhlYrg4XW+Vv1DFNo+eITBcUswV9ItAKNopxE6smevKd7ij3wqrEDGBk7IV9Ad0Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660552; c=relaxed/simple;
	bh=VLifuZZcnvofIh5cqne9F4TBPKATLJX4YJCrzl4Cdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/N9QHiC8A8VYpEwJVCpKzHb07S8fHvjteqW6+4TEVQ5Qa4nE9gn91s3xNMDjmskfNpWRhEb4tvi//NmmFaW1dFRZTBPlR2RdfwHw2pT+pHKBYEloZ4wBQhDqi8JcVWpxZzi0vhr2l67852Qytpndf8tSQL17eVZa+o3tWwFhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfBjfJxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfBjfJxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F761F00A3E;
	Tue, 21 Jul 2026 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660549;
	bh=K982GJrTw9EBYfGvDsjfdp+lx/1I6UYe6HTLAz+rz9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfBjfJxvEoao0Q/xKVjB7mv5sH7aYTKafTqu233eZ1d2o4DlwN8Ia+ndQQUicAsDD
	 yU+GsIJ1XfWl9dwTi4CM53M+7B6W/4g2o9DhYmce4YbIKmb3lSNScWvdzOAno6NLrZ
	 cAekscukn/Q1RMBJS7YC1PaHMUw9fNXiLaaFE8Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Blake Jones <blakejones@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1023/2077] perf bpf: Fix metadata leak in perf_env__add_bpf_info() on duplicate insert
Date: Tue, 21 Jul 2026 17:11:36 +0200
Message-ID: <20260721152616.950497802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit a0e4362a3e7b592f1d58949ffe3d6decad39a17c ]

When perf_env__insert_bpf_prog_info() returns false (duplicate
program), the error path frees info_linear and info_node but not
info_node->metadata.  If bpf_metadata_create() had succeeded, the
metadata allocation is permanently leaked.

Fix by calling bpf_metadata_free() on info_node->metadata before
freeing info_node.  bpf_metadata_free() handles NULL, so this is
safe even when bpf_metadata_create() returned NULL.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: fdc3441f2d317b40 ("perf record: collect BPF metadata from new programs")
Cc: Blake Jones <blakejones@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index b65ad28cd950fc..c4594969d76772 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -873,6 +873,7 @@ static int perf_env__add_bpf_info(struct perf_env *env, u32 id)
 		if (!perf_env__insert_bpf_prog_info(env, info_node)) {
 			pr_debug("%s: duplicate add bpf info request for id %u\n",
 				 __func__, btf_id);
+			bpf_metadata_free(info_node->metadata);
 			free(info_linear);
 			free(info_node);
 			goto out;
-- 
2.53.0



