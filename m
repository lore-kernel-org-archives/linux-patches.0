Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016BB221F2F;
	Wed, 20 May 2026 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295194; cv=none; b=uf/eG0JaKMIEtl2elSQTP7PsjsSlp4YCdWCFnu+HdBV1yXJDsP4SauyWFQV/P9zwR59TfeNe82svJCVPptROEmCmMusslr5qb48sQ5aupNZMXN+fMOrcdRIEIkTh6RkjAyuKU6FdNAKZDkYaJQ4PmEpbO+Hs8ydlr+FgkCAN82w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295194; c=relaxed/simple;
	bh=EsV8vczmsm7yK1wTYhxa7fXjoT3tz1R8uIq3LQGfY1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKgQzBPqOSG71h5pofptWTl6X2MxOPoUtK+hIZzEuRGSTmZoTu35WBPR449g7iDxRb3EanC6T/+U+OYh3g81uYy8IT5TQF0yj76jYG0ej4o/oBahlZ01TQpen9IRKLZrUp9YqG0LKhpYXo3CwzHkdytvXnxavHpan6GzTkdhgrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3+IisQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3+IisQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AFC1F000E9;
	Wed, 20 May 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295192;
	bh=XE6ybgrkHFGhxM5R642c+jyHTH5MMmTTf9JjVTZ5deM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3+IisQOPr5Vj3jf/yJ0zhdxob7DxFk7J0N2E7/qk6lYcVeewofMEIqNHTg8d1Gmn
	 HRwW+ps0WnCkA5xyzIQoavJdH2XuwbH0rFozYDLj72PJCRuXRP+y90qLooDeiX7bqm
	 VyB6iuT+Kstnf+TiEooN6qVetPgHdvP1xO1tcaLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0326/1146] tools/sched_ext: scx_pair: fix pair_ctx indexing for CPU pairs
Date: Wed, 20 May 2026 18:09:36 +0200
Message-ID: <20260520162155.575394216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit f546c77038ab898726e7344255217fbec382b97f ]

scx_pair sizes pair_ctx to nr_cpu_ids / 2, so valid pair_ctx keys are
dense pair indexes in the range [0, nr_cpu_ids / 2).

However, the userspace setup code stores pair_id as the first CPU number
in each pair. On an 8-CPU system with "-S 1", that produces pair IDs
0, 2, 4 and 6 for pairs [0,1], [2,3], [4,5] and [6,7]. CPUs in the
latter half then look up pair_ctx with out-of-range keys and the BPF
scheduler aborts with:

EXIT: scx_bpf_error (scx_pair.bpf.c:328: failed to lookup pairc and
in_pair_mask for cpu[5])

Assign pair_id using a dense pair counter instead so that each CPU pair
maps to a valid pair_ctx entry. Besides, reject odd CPU configuration, as
scx_pair requires all CPUs to be paired.

Fixes: f0262b102c7c ("tools/sched_ext: add scx_pair scheduler")
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_pair.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/sched_ext/scx_pair.c b/tools/sched_ext/scx_pair.c
index 2e509391f3dab..eb1bea2dd0ccc 100644
--- a/tools/sched_ext/scx_pair.c
+++ b/tools/sched_ext/scx_pair.c
@@ -48,6 +48,7 @@ int main(int argc, char **argv)
 	struct bpf_link *link;
 	__u64 seq = 0, ecode;
 	__s32 stride, i, opt, outer_fd;
+	__u32 pair_id = 0;
 
 	libbpf_set_print(libbpf_print_fn);
 	signal(SIGINT, sigint_handler);
@@ -82,6 +83,14 @@ int main(int argc, char **argv)
 		scx_pair__destroy(skel);
 		return -1;
 	}
+
+	if (skel->rodata->nr_cpu_ids & 1) {
+		fprintf(stderr, "scx_pair requires an even CPU count, got %u\n",
+			skel->rodata->nr_cpu_ids);
+		scx_pair__destroy(skel);
+		return -1;
+	}
+
 	bpf_map__set_max_entries(skel->maps.pair_ctx, skel->rodata->nr_cpu_ids / 2);
 
 	/* Resize arrays so their element count is equal to cpu count. */
@@ -109,10 +118,11 @@ int main(int argc, char **argv)
 
 		skel->rodata_pair_cpu->pair_cpu[i] = j;
 		skel->rodata_pair_cpu->pair_cpu[j] = i;
-		skel->rodata_pair_id->pair_id[i] = i;
-		skel->rodata_pair_id->pair_id[j] = i;
+		skel->rodata_pair_id->pair_id[i] = pair_id;
+		skel->rodata_pair_id->pair_id[j] = pair_id;
 		skel->rodata_in_pair_idx->in_pair_idx[i] = 0;
 		skel->rodata_in_pair_idx->in_pair_idx[j] = 1;
+		pair_id++;
 
 		printf("[%d, %d] ", i, j);
 	}
-- 
2.53.0



