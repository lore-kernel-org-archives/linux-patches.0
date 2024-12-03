Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BF1F7591;
	Tue,  3 Dec 2024 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242753; cv=none; b=HNL0pW33DKYSeCf6LqzbjonmQxKNbqUikQaWyVv5NA15ADAXSX+oTnpHecq8YTOmVZaBrZ8VJ7reYdqv92OPJeTqITbXUk0drOQpd7XdfVOJZwhwDt/uLM/bxEixCEyFPoi0JrmeinNrAmvbua3u/K+cKz6gAw/RIh51WqHAXUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242753; c=relaxed/simple;
	bh=/tMEyqca0xP07793fPBQGxqBayD9AAtU4FKsOaPoY6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt1aS8ieK09MrUvE10MZ7gz7NCfbt35nYIndiDn2TH933baOaF2+QCkjeHs0GD7SYQRacR6lw+VgNkvCFIh1DG4ritgVQsUV1sAxnJlL97mtkcR9Ol64NSLeftcmiaU++ZWVhb0GF1+1Q88LI6c5XaOfWZN81Xj0Jt58ExpKNBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZVBvksl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZVBvksl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E1DC4CECF;
	Tue,  3 Dec 2024 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242753;
	bh=/tMEyqca0xP07793fPBQGxqBayD9AAtU4FKsOaPoY6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZVBvksl6XTDTAfRP8jG4ArVAkn+2BFLgJWusxsnOfTJo7I8f6uhTG400UmoTaRyY
	 6k4RTegwISQBPky3qx9m0jLCGNRhmgqBx74T5bUorBpDq5y9bv80l0wvuwC7cNw7d3
	 t8EkGYrWpTB+8MffbiCzD3BJWmghrxqXN+ZcyjqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 800/826] perf/arm-cmn: Ensure port and device id bits are set properly
Date: Tue,  3 Dec 2024 15:48:47 +0100
Message-ID: <20241203144814.965579458@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dfdf714fed559c09021df1d2a4bb64c0ad5f53bc ]

The portid_bits and deviceid_bits were set only for XP type nodes in
the arm_cmn_discover() and it confused other nodes to find XP nodes.
Copy the both bits from the XP nodes directly when it sets up a new
node.

Fixes: e79634b53e39 ("perf/arm-cmn: Refactor node ID handling. Again.")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20241121001334.331334-1-namhyung@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 397a46410f7cb..30506c43776f1 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2178,8 +2178,6 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			continue;
 
 		xp = arm_cmn_node_to_xp(cmn, dn);
-		dn->portid_bits = xp->portid_bits;
-		dn->deviceid_bits = xp->deviceid_bits;
 		dn->dtc = xp->dtc;
 		dn->dtm = xp->dtm;
 		if (cmn->multi_dtm)
@@ -2420,6 +2418,8 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			}
 
 			arm_cmn_init_node_info(cmn, reg & CMN_CHILD_NODE_ADDR, dn);
+			dn->portid_bits = xp->portid_bits;
+			dn->deviceid_bits = xp->deviceid_bits;
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
-- 
2.43.0



