Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44C3C81B9;
	Mon, 17 Aug 2026 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975155; cv=none; b=VqyhPGjVcnauzwIZ/C+BPSBUV/NX7IvEMzqFfT7OWAN0lbW0oJUqHmtA1Xi4mbSlXdXe6+ZIlewjP6JmC+vhldXbW/5BZSaudxjR+op9apW8SYrh0malLCR/XzuhofI3UzvieHRGH1bfa4dWe4j4NuT1PQYCtuiftHp6T0WUMwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975155; c=relaxed/simple;
	bh=ER3vmJ/A661eIpFna95AbrpQZ6kLWjx5mAb3+dAnGbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxM9Ol+MExIuo5B4hFlMb9WJpWrG96VvTYlDe/JZvCGR9mDWQfHMb4rwpTE9W/ARUZGorrF7JuGz9miNZszsDvWbZD2Yw4A3TZ0cw6WtFGw3r0nPRqOeMiEuhaxqWQj9/t+YmdNMbwYtKhXtSWy5ItoUI5ADSnrib7JpcMd6NgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hazQaeOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hazQaeOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7541C1F000E9;
	Mon, 17 Aug 2026 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975154;
	bh=XnM7qdzymROjkoiHFHUEmLwyzk0PdedPDz6w7nmgN1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hazQaeOY7W/VrBBQUSZAUvWLSnY1mjo+6G41UWH2c+w2hV8fKqg9xKd1GEJuDMT+j
	 /ltawCN5VGfC1auTd0DeOQXYaENxCbFalDCBe7jqLHj+RAP2w+acJY9v0wUhy7DW0c
	 T5Ktu03974yBbbIf36zbq85qrqYIZV1GLtZd7h3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 181/250] samples/damon/mtier: error out for zero quota goal target values
Date: Mon, 17 Aug 2026 15:32:22 +0200
Message-ID: <20260817132543.986526587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit a16fd3ad9d89b05475864da97327870464611736 upstream.

Patch series "mm/damon: avoid division by zero from damos_quota_score()".

DAMON_SAMPLE_MTIER and DAMON_LRU_SORT allow the user to trigger division
by zero in damos_quota_score().  Avoid it by adding parameters validation
checks.


This patch (of 2):

damos_quota_score() can trigger division by zero if the target_value is
zero.  DAMON_SAMPLE_MTIER lets users set the target_value via
node0_mem_{used,free}_bp parameters.  It doesn't guard zero value case,
though.  As a result, users can trigger division by zero.  Fix the issue
by returning an error when the user tries to start DAMON with zero
node0_mem_{used,free}_bp parameter values.

DAMON_SAMPLE_MTIER is just a sample module, but the consequence is quite
bad.  Also the zero node0_mem_free_bp parameter might look like a
reasonable setup to some users.  Hence, the issue might really happen in
the real world.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_sample_mtier/parameters
    # echo 4096 > node0_start_addr
    # echo 8192 > node0_end_addr
    # echo 8192 > node1_start_addr
    # echo 81920 > node1_end_addr
    # echo 0 > node0_mem_free_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [18792.235916] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [18792.242787] RIP: 0010:damos_quota_score+0x6f/0x480
    [...]

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-2-sj@kernel.org
Link: https://lore.kernel.org/20260801202657.117135-1-sj@kernel.org [1]
Fixes: c5e67d40a102 ("samples/damon/mtier: add parameters for node0 memory usage")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -153,6 +153,9 @@ static struct damon_ctx *damon_sample_mt
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
+	/* zero target value causes division by zero in damos_quota_store() */
+	if (!node0_mem_used_bp || !node0_mem_free_bp)
+		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,


