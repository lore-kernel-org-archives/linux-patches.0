Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4A9154449;
	Fri,  6 Dec 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498406; cv=none; b=oW8qroF/w7QU0UsaxBH15LmcowaFwQ7OovRZDPXYLJTECgCZkQzdjky6KfwesFjDeruWYIUOZmAlJLesGA9IlSySVa8DwRBBoJhf/7X+ZmpHUft9FDIUTsJ8NFY10wrLq+JNqqVopBlVug+M7tNL3joKL0a5fuVGzhu3T2YPO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498406; c=relaxed/simple;
	bh=ncbWkFdeZdCdY62xtdYuV9FQHrsWzNVBsUt2v0d3oB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlVJeR8uzdUGUWQkhseUq7ICQ2ADBmdwfYG7H+RWquK1wIRoB12cOnIsEb/4jOubSVSWZf0Odkx1bLdxeTTWs0ykA2JZDXbhwRBiThbselBeIKc7m6XAEaGpdfhcb0GYTzHiDByghKu0nKoT2l8k+VSzD6AfXnCGgQ05brNXTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyTGSdk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyTGSdk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B9FC4CED1;
	Fri,  6 Dec 2024 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498405;
	bh=ncbWkFdeZdCdY62xtdYuV9FQHrsWzNVBsUt2v0d3oB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyTGSdk7+hYuSBqtgMChJwiKg8X+6FIO6k3MqR4E0rF/gFdUSeqXxQKyBir5t28Ec
	 MLUSOfN6cIW8usjVOjxsOMFPqZEUx6/3rEcEIrltn8UspHh/tQrt196u6vEUIXeC1a
	 8ut2djwjYGMjnPMjkBGGD7K3AeAlBjoK76oJg3y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 575/676] perf/arm-cmn: Ensure port and device id bits are set properly
Date: Fri,  6 Dec 2024 15:36:34 +0100
Message-ID: <20241206143715.817721184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b3ce77136456..7bd1733d79770 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2075,8 +2075,6 @@ static int arm_cmn_init_dtcs(struct arm_cmn *cmn)
 			continue;
 
 		xp = arm_cmn_node_to_xp(cmn, dn);
-		dn->portid_bits = xp->portid_bits;
-		dn->deviceid_bits = xp->deviceid_bits;
 		dn->dtc = xp->dtc;
 		dn->dtm = xp->dtm;
 		if (cmn->multi_dtm)
@@ -2307,6 +2305,8 @@ static int arm_cmn_discover(struct arm_cmn *cmn, unsigned int rgn_offset)
 			}
 
 			arm_cmn_init_node_info(cmn, reg & CMN_CHILD_NODE_ADDR, dn);
+			dn->portid_bits = xp->portid_bits;
+			dn->deviceid_bits = xp->deviceid_bits;
 
 			switch (dn->type) {
 			case CMN_TYPE_DTC:
-- 
2.43.0



