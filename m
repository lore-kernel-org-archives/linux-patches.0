Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2638AC99;
	Sat, 17 Oct 2026 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254461; cv=none; b=kVNQf2QBEtzDh6O0GuAWEdCTmn3uk7OxyXBuqRSHn822cqaiZalYBidf/i4vsvk4WzNN+z8uEHUoFIZ1biaKsHg9bLnyg7ynS/KZSE0ScO4U509fyOu0seYl+omx4yH6gmB+S6PbBRLGf/fPtFWAXW38Af9uLzqShYbVctKtNIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254461; c=relaxed/simple;
	bh=z1ntx5iUeF82WkuBnNozB7j07ygun3OJchPXOvatZ/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXEjnYp64hW3Tr8v8AbGxzvmgOzUzTYa1Mbc6PJjTWsNcNDQ5f3MxGLDWehFxFXOOMnR1CqSGBCWHu+MHpM7+pH7EYQflYZtKGjPajC0R7qA6xB4nHYkpBsEqui0kCw1PL7TIMIROJfztJ9OeMiN62gwcE+wtZDi8PLFvMniHLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIVPwsH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIVPwsH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730231F000C4;
	Sat, 17 Oct 2026 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254460;
	bh=ffrjkptFY5NQX+IIMWU+mNhJq0BPo87yP/J32cUJC6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIVPwsH4KQgeKbR2Xul0efcZRexIvbtNQd8vCy0BoXZhAWPgqOJa6YXUt/N0qua0l
	 9oMrwp98dfUSEuZmxOiIGaAAK1oh8KK1qtVHg1096pH+z65pYNXlL6dnhWyy8rJcuN
	 yYD0t/QOIp3kLpu8UI34LmY+76Rf8IcTbigx6Z5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Baoli.Zhang" <baoli.zhang@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 453/869] soundwire: fix bug in sdw_add_element_group_count found by syzkaller
Date: Sat, 17 Oct 2026 17:54:54 +0200
Message-ID: <20261017160048.754967385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoli.Zhang <baoli.zhang@linux.intel.com>

[ Upstream commit f772ff5a0e6758fd412803c09e03ba3bca5f5878 ]

The original implementation caused an out-of-bounds memory access
in the sdw_add_element_group_count for-loop when i == num.

for (i = 0; i <= num; i++) {
    if (rate == group->rates[i] && lane == group->lanes[i])
        ...

To fix this error, the function now checks for existing rate/lane
entries in the group(a function parameter) using a for-loop before
adding them.

No functional changes apart from this fix.

Fixes: 9026118f20e2 ("soundwire: Add generic bandwidth allocation algorithm")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Baoli.Zhang <baoli.zhang@linux.intel.com>
Link: https://patch.msgid.link/20260506055039.3751028-2-baoli.zhang@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../soundwire/generic_bandwidth_allocation.c  | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index b9316207c3ab2..45a2f80ed809a 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -199,28 +199,25 @@ static int sdw_add_element_group_count(struct sdw_group *group,
 	int num = group->count;
 	int i;
 
-	for (i = 0; i <= num; i++) {
+	for (i = 0; i < num; i++) {
 		if (rate == group->rates[i])
-			break;
-
-		if (i != num)
-			continue;
-
-		if (group->count >= group->max_size) {
-			unsigned int *rates;
+			return 0;
+	}
 
-			group->max_size += 1;
-			rates = krealloc(group->rates,
-					 (sizeof(int) * group->max_size),
-					 GFP_KERNEL);
-			if (!rates)
-				return -ENOMEM;
-			group->rates = rates;
-		}
+	if (group->count >= group->max_size) {
+		unsigned int *rates;
 
-		group->rates[group->count++] = rate;
+		group->max_size += 1;
+		rates = krealloc(group->rates,
+				 (sizeof(int) * group->max_size),
+				 GFP_KERNEL);
+		if (!rates)
+			return -ENOMEM;
+		group->rates = rates;
 	}
 
+	group->rates[group->count++] = rate;
+
 	return 0;
 }
 
-- 
2.53.0



