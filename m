Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9533F327D;
	Mon, 17 Aug 2026 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974413; cv=none; b=n2cxqnVzVLzQV/2p67e+rXnj01NdbbEC0r3CoYLhayoCDFz+2Lq3dTQjw6aOv63+H/nWQTG8TuhBRCEVxNs/7WZVo6mBQvrKU3BtQ/VLinWQOZOfNgtYvz6yc1sq8d/kyhoHH0t4ytN6qfQhdB/b3Z32sPnSiuSSb0YuTT75shA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974413; c=relaxed/simple;
	bh=0EVTO2Ywc4rl8/+9qtYrJwxrdo2BRDV61nKT24h8Msk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J27SsGCsIV2QY+cW2oc4i1rh/Y4Ra3gR+P2NCbLuxmdTpzuBwyO37D4BoXS827lY3N4lcUSJsnnrN6T4yn86weaP5ENb1oSBpMVCswySjdpPc8ScCN5zSV9c2W1hfcy/1pzRvo4LMPPx91UOVqyhUyOryWXyIlPfJQYxGsFDEB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAoUiXa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAoUiXa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BD31F000E9;
	Mon, 17 Aug 2026 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974408;
	bh=hkvNYoHNIQM5GAi04Gm4AiUCLlN5kRcxEuoGGuL1Cnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAoUiXa/KqFLViKKs8frm2+wCQJNL/7WYZQ8//4+rhN8n99fXlOr67Vp3JqSqhAli
	 A5thus0ZIQglXUPGrSik5G0bGVtRsSfTLdQg55n4NmyCxAlDHPQFAH5BwGzUD4cqnB
	 gqQ0Y+3TTOH3+9C4gzlvyHQFLetl9iL0xUuffO5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 194/271] mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Mon, 17 Aug 2026 15:31:59 +0200
Message-ID: <20260817132544.799692319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 06befa61c427e74319781e6f35a364cfc32dbae8 upstream.

damos_quota_score() can trigger division by zero if the target value is
zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
scheme via active_mem_bp parameter.  It avoids setting it as the target
value if the parameter value is zero.  However, it also sets the cold
memory scheme with a target value that is calculated as '10000 -
active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
memory scheme's quota goal target value can be zero.  As a result,
division by zero can be triggered.  Fix by returning an error when the
user tries to start DAMON with >10000 active_mem_bp parameter value.

It makes no sense to set active_mem_bp with 10002.  It also requires
module parameters write permission to reproduce the issue.  That said, the
consequence is quite bad.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_lru_sort/parameters
    # echo 1000 > wmarks_high
    # echo 995 > wmarks_mid
    # echo 0 > wmarks_low
    # echo 10002 > active_mem_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
    [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260803134034.15217-3-sj@kernel.org
Link: https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org [1]
Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -234,6 +234,8 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
+	if (10000 < active_mem_bp)
+		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;


