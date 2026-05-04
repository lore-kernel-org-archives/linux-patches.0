Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D2C3D9029;
	Mon,  4 May 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903339; cv=none; b=WcDrCie1c+K5quSbryENozyPuRQoiKxgyXi98D0kMseJREwFbx6QTReGuE6EaQmk04+p6K6/daF48nuPesiU4+acjB6daaqpPZsmvh0NC2D4OLz5Rd5LnTg8kfl6skY8WkA7ydRP+OWI/CcftGb+Y0gXOqLLNNaOc3Dxtf/GcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903339; c=relaxed/simple;
	bh=NWXCPl5DPIrWiskGgon7gq+dUVL76Fgvcxxl03YEFf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKCFAKTmps2hYvRw/IaAlm8I2pDzr5aFLrRbcHPwh390BUXWAAneXTchavn19ucWwML+6t8p80lUh5Tp/FiDuSZB/w5biXXJGp+lfREtJpi5vkt7q7ATXQuXfKx2Swilv47rQDTLRP7FAfxLrVgGlo3Piemij3J3lDmjADU9QRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEdBK+zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEdBK+zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9F8C2BCB8;
	Mon,  4 May 2026 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903339;
	bh=NWXCPl5DPIrWiskGgon7gq+dUVL76Fgvcxxl03YEFf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEdBK+zmH7eYI0EGWfVFankEAjQlHCQXu3A78yQeF5ISRAGgcuk3nFfNLupRItjOe
	 tsECF7C1RjjczyDOrKKy0bLlrV+td2ocwuWnlpbDHCjp1bZK2ROkIeKGGMnnyJAny8
	 C/UEfnOOf81ecZIW0GRm47jIsnu8OnQI8DNeqfyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 195/307] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Mon,  4 May 2026 15:51:20 +0200
Message-ID: <20260504135150.219873102@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit a34dac6482e53e2c76944f25b1489b9b7da3a6e6 upstream.

Users can set damos_quota_goal->nid with arbitrary value for
node_memcg_{used,free}_bp.  But DAMON core is using those for NODE-DATA()
without a validation of the value.  This can result in out of bounds
memory access.  The issue can actually triggered using DAMON user-space
tool (damo), like below.

    $ sudo mkdir /sys/fs/cgroup/foo
    $ sudo ./damo start --damos_action stat --damos_quota_interval 1s \
            --damos_quota_goal node_memcg_used_bp 50% -1 /foo
    $ sudo dmseg
    [...]
    [  524.181426] Unable to handle kernel paging request at virtual address 0000000000002c00

Fix this issue by adding the validation of the given node id.  If an
invalid node id is given, it returns 0% for used memory ratio, and 100%
for free memory ratio.

Link: https://lore.kernel.org/20260329043902.46163-3-sj@kernel.org
Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2112,6 +2112,13 @@ static unsigned long damos_get_node_memc
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 10000;
+	}
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)


