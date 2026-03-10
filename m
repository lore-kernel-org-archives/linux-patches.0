Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B508237B413;
	Tue, 10 Mar 2026 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142042; cv=none; b=jgTq2+A0MvWji6cwaO8ve8gEtBzcZijprpDFJmS8KS4pBla8S/4v6AcTZVMv+hl2JkvficWbamRWDZGZeFbhlmvIld6RkEA38ALj1uIHpXxP1Q8a8U+EVaZKFsskFyY9Z3gnW/gf2f3KoHUJTkeYqnu7u3bnaC+jWJmnxuqmKQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142042; c=relaxed/simple;
	bh=Vz95uGP1/IBJ2T7Xba07XRl9cAQfwaG6gvxu0vWscf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnqbAgN+Px2jnzQjI12fH+G0eTWvvyBg0zq+Zs8V3w2lnhNtYRZgd3VorjwdOrm2Svf6YIIuFZRfYzcQf80kmli2kYihpPG2tAPYILIF8ZHBv5CTSi+zJkQtuL96IGOVda16/P6mlkGa6j3/8QUXy+PG0ltxXPCrXnbyda0d6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSsVskF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSsVskF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BC8C2BC86;
	Tue, 10 Mar 2026 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142042;
	bh=Vz95uGP1/IBJ2T7Xba07XRl9cAQfwaG6gvxu0vWscf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSsVskF/gmtVrmUz2KjtNIT+5WvTRUaDvCAQ1C4dAt5c0Yb++OLAD/o1GHABOh6DO
	 AqFOeo01gwa0H8gSeV1VJigcgkKY2YHHfeZxSk9VbGG76g/X5QkYZBU5c0TYbbmVDp
	 V/xlNTp3S7rtC2cTopV1xc+8j8jZEAA/T24aV0F7A5y6Z1HgYSObnvpvmR/TiU7AyO
	 o2Lu+lM8jB1DYMGaTXz+eiOKsu7AH/8mR5f75wYyRg22FVPlUS6MMGg6sDN6779G3k
	 2JeLg5NF9DvZyx03yfuWolSY8Miwi9hRtS5aFByFAr4+d9veDSxiGABEdhtD1ZQRs7
	 PiK68oqFcYP8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 170/314] RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
Date: Tue, 10 Mar 2026 07:17:09 -0400
Message-ID: <84fb02fec9b0ed3d6770872cc646f15e13dac2e2.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

commit 74586c6da9ea222a61c98394f2fc0a604748438c upstream.

struct irdma_create_ah_resp {  // 8 bytes, no padding
    __u32 ah_id;               // offset 0 - SET (uresp.ah_id = ah->sc_ah.ah_info.ah_idx)
    __u8  rsvd[4];             // offset 4 - NEVER SET <- LEAK
};

rsvd[4]: 4 bytes of stack memory leaked unconditionally. Only ah_id is assigned before ib_respond_udata().

The reserved members of the structure were not zeroed.

Cc: stable@vger.kernel.org
Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/3-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b8655504da290..5d027c04dba6f 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -5202,7 +5202,7 @@ static int irdma_create_user_ah(struct ib_ah *ibah,
 #define IRDMA_CREATE_AH_MIN_RESP_LEN offsetofend(struct irdma_create_ah_resp, rsvd)
 	struct irdma_ah *ah = container_of(ibah, struct irdma_ah, ibah);
 	struct irdma_device *iwdev = to_iwdev(ibah->pd->device);
-	struct irdma_create_ah_resp uresp;
+	struct irdma_create_ah_resp uresp = {};
 	struct irdma_ah *parent_ah;
 	int err;
 
-- 
2.51.0

