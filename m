Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131BA1D63EF;
	Tue, 27 May 2025 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364626; cv=none; b=POIHp/ldmBkowo2EX4oxDKAxwNvpAXzRwZLPkVTF3YDUrvD5YRTriobwKCiOIX02h7FSp9nUj933NBKGifVn1RfruELS0nudCDyCNTl5DeLvylG1S1b2gYYxD7fop+xWMH01WuHkQiNkVLxWawx7f0so3Jw04ekf2ca5MsPZZ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364626; c=relaxed/simple;
	bh=lAT3x4q+X4TmZVr11Fzuj6/ESvd2XawGkGOZeBSviWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuYVkuujldl1N7yGEiQCYza6ROyfc6lIidoCpocH2c2P6acRN3l3RAAcPvJUjZmWqZyDNydkci/k895wqB6GznyPulSq0wiucIzD9KJ94xSRBSf96SdZzsP95PN16hbghZemGtd2/hqZ4TgjS/svlEA5l/3Pz9ej8zWZRhBtNxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiCvPY/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiCvPY/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFE1C4CEE9;
	Tue, 27 May 2025 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364625;
	bh=lAT3x4q+X4TmZVr11Fzuj6/ESvd2XawGkGOZeBSviWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiCvPY/lzaj+JjuYoNyAhCid+Mqt6IgrcrvW+iYCluTuaEbY5CKcTe5PJZncBjoPa
	 0e8JgOX/PuXGgd8o7q23jGOT4ea602SrNEAWoRWJdr0A7EAi7jnk5RTJQT6W9xfJNo
	 ht/KF581Eu7Qq7N282lMPrphyMHlqbC1krlafmB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Su <jingsusu@didiglobal.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/626] dql: Fix dql->limit value when reset.
Date: Tue, 27 May 2025 18:19:37 +0200
Message-ID: <20250527162448.459155322@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Jing Su <jingsusu@didiglobal.com>

[ Upstream commit 3a17f23f7c36bac3a3584aaf97d3e3e0b2790396 ]

Executing dql_reset after setting a non-zero value for limit_min can
lead to an unreasonable situation where dql->limit is less than
dql->limit_min.

For instance, after setting
/sys/class/net/eth*/queues/tx-0/byte_queue_limits/limit_min,
an ifconfig down/up operation might cause the ethernet driver to call
netdev_tx_reset_queue, which in turn invokes dql_reset.

In this case, dql->limit is reset to 0 while dql->limit_min remains
non-zero value, which is unexpected. The limit should always be
greater than or equal to limit_min.

Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Link: https://patch.msgid.link/Z9qHD1s/NEuQBdgH@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_queue_limits.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index e49deddd3de9f..7d1dfbb99b397 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -190,7 +190,7 @@ EXPORT_SYMBOL(dql_completed);
 void dql_reset(struct dql *dql)
 {
 	/* Reset all dynamic values */
-	dql->limit = 0;
+	dql->limit = dql->min_limit;
 	dql->num_queued = 0;
 	dql->num_completed = 0;
 	dql->last_obj_cnt = 0;
-- 
2.39.5



