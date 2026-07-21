Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972E846EF73;
	Tue, 21 Jul 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656953; cv=none; b=Zu5qQhG3u969yh/c5BEugzoCYkbRqDQ92eOxRFYNUzZqL1/tyafZiJEM22m6RITJ+IkxTb366FyuynW9vklCMBUfooPW3rWqGuRWziD5dRTe2n5nHLL/3F+E99iv/KXks9bzIOqvxg4uO84KoZG+ExlDZjStAp/ANvmFxHe5ShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656953; c=relaxed/simple;
	bh=WgWWM18bQCw5XFq4c0seSi5v2Jw7oypWGR/QyPvrK/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biyzhMhKRDy3C8qhqiHfPLxstGQZkOA6EAjiUD3dxnNuFEzqRV1kne84I1BCw/xS+0Axay3bGnHkPqYsqiDPCMTbSkpgHsq2hx1WoS4x7X1StD+GcZCEdcQHJAGaZW5FmernzTAUXB49jUyp2l7rmr6Qap+Qw0xQjgN01xPcudc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaPg9FuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaPg9FuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00F11F000E9;
	Tue, 21 Jul 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656952;
	bh=FUo2/erLrSWz3QHSPLInGaD2Mzoy68NVx5GrozmG6OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaPg9FuC571mzNdiJi/6zeuddztY4mesQLxh7d/314QTbG+8EZQbbt+EG4I2s3wOK
	 TgCHrXAL+43Odzr5pKfGYG4UXOS4/24aCFB0baGbvl8VOVpfRWSk3eAsDKiwhd46dR
	 q4Z+1kMd5spM0clZ4pVPq+QZxittL9MP/9xR6lOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Baoli.Zhang" <baoli.zhang@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0581/1611] soundwire: fix bug in sdw_add_element_group_count found by syzkaller
Date: Tue, 21 Jul 2026 17:11:37 +0200
Message-ID: <20260721152528.447391441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
 .../soundwire/generic_bandwidth_allocation.c  | 47 +++++++++----------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index c18f0c16f92973..e52c536d663c53 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -296,39 +296,36 @@ static int sdw_add_element_group_count(struct sdw_group *group,
 	int num = group->count;
 	int i;
 
-	for (i = 0; i <= num; i++) {
+	for (i = 0; i < num; i++) {
 		if (rate == group->rates[i] && lane == group->lanes[i])
-			break;
-
-		if (i != num)
-			continue;
-
-		if (group->count >= group->max_size) {
-			unsigned int *rates;
-			unsigned int *lanes;
+			return 0;
+	}
 
-			group->max_size += 1;
-			rates = krealloc(group->rates,
-					 (sizeof(int) * group->max_size),
-					 GFP_KERNEL);
-			if (!rates)
-				return -ENOMEM;
+	if (group->count >= group->max_size) {
+		unsigned int *rates;
+		unsigned int *lanes;
 
-			group->rates = rates;
+		group->max_size += 1;
+		rates = krealloc(group->rates,
+				 (sizeof(int) * group->max_size),
+				 GFP_KERNEL);
+		if (!rates)
+			return -ENOMEM;
 
-			lanes = krealloc(group->lanes,
-					 (sizeof(int) * group->max_size),
-					 GFP_KERNEL);
-			if (!lanes)
-				return -ENOMEM;
+		group->rates = rates;
 
-			group->lanes = lanes;
-		}
+		lanes = krealloc(group->lanes,
+				 (sizeof(int) * group->max_size),
+				 GFP_KERNEL);
+		if (!lanes)
+			return -ENOMEM;
 
-		group->rates[group->count] = rate;
-		group->lanes[group->count++] = lane;
+		group->lanes = lanes;
 	}
 
+	group->rates[group->count] = rate;
+	group->lanes[group->count++] = lane;
+
 	return 0;
 }
 
-- 
2.53.0



