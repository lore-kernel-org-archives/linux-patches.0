Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542611710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFAAC433C8;
	Mon, 11 Sep 2023 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445648;
	bh=fPe+phdJM330acCkBPrAwBN9GxOEDQdGuOFdQLeVDcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcukMdzW3mrD9u7Y3MU+C1RJ6WSj/gTJeBA3eop/z/ACZiB4AhxGxcKlw0P6C3+Sa
	 i2PUr58mUMKqAb8qgWAWDkbkW5O73pZ3oHbUJuuUJGjkiHIHwybLyKL2a0Fzs+Jr6C
	 /O3Lt1D5mL/VDLHxOmUIRKKGS34BDiIyvXWeqYhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Marcovitch <dmarcovitch@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/600] iommu/amd/iommu_v2: Fix pasid_state refcount dec hit 0 warning on pasid unbind
Date: Mon, 11 Sep 2023 15:47:08 +0200
Message-ID: <20230911134645.337274873@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Marcovitch <dmarcovitch@nvidia.com>

[ Upstream commit 534103bcd52ca9c1fecbc70e717b4a538dc4ded8 ]

When unbinding pasid - a race condition exists vs outstanding page faults.

To prevent this, the pasid_state object contains a refcount.
    * set to 1 on pasid bind
    * incremented on each ppr notification start
    * decremented on each ppr notification done
    * decremented on pasid unbind

Since refcount_dec assumes that refcount will never reach 0:
  the current implementation causes the following to be invoked on
  pasid unbind:
        REFCOUNT_WARN("decrement hit 0; leaking memory")

Fix this issue by changing refcount_dec to refcount_dec_and_test
to explicitly handle refcount=1.

Fixes: 8bc54824da4e ("iommu/amd: Convert from atomic_t to refcount_t on pasid_state->count")
Signed-off-by: Daniel Marcovitch <dmarcovitch@nvidia.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230609105146.7773-2-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 75355ddca6575..4caa023048a08 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -262,8 +262,8 @@ static void put_pasid_state(struct pasid_state *pasid_state)
 
 static void put_pasid_state_wait(struct pasid_state *pasid_state)
 {
-	refcount_dec(&pasid_state->count);
-	wait_event(pasid_state->wq, !refcount_read(&pasid_state->count));
+	if (!refcount_dec_and_test(&pasid_state->count))
+		wait_event(pasid_state->wq, !refcount_read(&pasid_state->count));
 	free_pasid_state(pasid_state);
 }
 
-- 
2.40.1



