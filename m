Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934992BF3E2;
	Tue, 10 Mar 2026 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141137; cv=none; b=Jvttff6TC5NdZBCG85RPxI51wYp++gys+KRDQGQiS3QkzRdwad4zxu2Z2f+SSIYe41MGpaX3v0Z7TWUSPr8KAUut7zaXx1VTTa82n+OesaY6rxvDkXc+zdHMthfp21CDvpNY71c+PlxKAkD83yRV214oa1Twg6bK7iZNSShNdfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141137; c=relaxed/simple;
	bh=r9Fr4QjByy98PYYiJBS8P/h7hs87TY0NdD2OJX890y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2z6nTcTIAKza8VtMiYbPuNbZBzrSVsoZPx0xvKLoVJUA/3hP17uO3fJkbUS3SoUoEF08NDyDLdV82QLZyZ/8VBDwFqqT1sphFxwlexE6ZJlsNuFR1gbnECC2+nYo5QR1TwFdr7mt8b+1aZxMRy5kXKPD+i6lRCh37K22xrwenk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gERccbeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gERccbeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF65C2BC86;
	Tue, 10 Mar 2026 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141137;
	bh=r9Fr4QjByy98PYYiJBS8P/h7hs87TY0NdD2OJX890y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gERccbeLJ61K2qgAfCjkTnBSgIB2r850kHOtkRKHJe6NMJAhFLsFYnLMSr2kP7PA0
	 Cc42VJlk0IIVZAicZ7ttFKvgrawmGJYzzdv3n7lp2rsttgnYkpMZ2Xw84flc1+d1DL
	 UKkJJOUGwO8OSAQcUpcPqg/avCYoBNJQkjGNBuKA4RmajhUb2oUQ/cZA9yxRm8xJFI
	 zH5YcKasSXmEWAh2rWBbGpxaifhgkUMuEGuVq14OHIxNm7btEZbVgitV9ZJpKiIdO6
	 2CrHaDIIYNQ2MppM94h/T3n4EuIPhDQjXmciarh5LMgipn3KBPFZ4TvnfIxX1woYLm
	 txqbkv0fiGf8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 141/311] RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
Date: Tue, 10 Mar 2026 07:03:08 -0400
Message-ID: <ba9507a4daca9e83678d1dcd98eab50af5dcc39d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 6d9af41a2884a..68fb81b7bd221 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -5209,7 +5209,7 @@ static int irdma_create_user_ah(struct ib_ah *ibah,
 #define IRDMA_CREATE_AH_MIN_RESP_LEN offsetofend(struct irdma_create_ah_resp, rsvd)
 	struct irdma_ah *ah = container_of(ibah, struct irdma_ah, ibah);
 	struct irdma_device *iwdev = to_iwdev(ibah->pd->device);
-	struct irdma_create_ah_resp uresp;
+	struct irdma_create_ah_resp uresp = {};
 	struct irdma_ah *parent_ah;
 	int err;
 
-- 
2.51.0

