Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFBD231829;
	Tue, 21 Jul 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660081; cv=none; b=A1a5ubSuaV2qqpOmXSkeDJxhH+5V8jukrEu9QO9ux/vDBxEuVpPt9J5xRjg1nXrTu70buu0UwIpIKIeNpp5T2JFExiYgmrbChlVSqQTEcjOit7gf8bpmI7OzVp8w272F75P2VKNhGwkqAV2fPDNaw1mQegECwJ7ytsXRCggstLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660081; c=relaxed/simple;
	bh=JC47vTjmpY35a5vfs0Nzv5EPwGBkwb8PUHgq87+iJhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HydLb8J1foU+OziHvwfiWTLRiYVcTJ8LgMlyzzR1E/lGIk5hjdAIpbu47SUbhgKVfqrtinD+KsNxh2CI+kmcWE8wJhahWFJhN80aqzTuK3EV1R+ah3CNjszdVo+l9PhTFNBku6zMzLl04kjGFMgQJKIwURFEhOr+zp8r/EkB/tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUuqvtPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUuqvtPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512801F000E9;
	Tue, 21 Jul 2026 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660076;
	bh=9BT+NB3MXOMo0Rd+eAKZ5n8GbAyxwGXoOFxWli16sZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUuqvtPzpzbWMyvSiEGqM95gby0KiCL8Fsy+NEkhVIrA5fZFaOQc1kNTutOzqUhH0
	 AD827zlpqQZucHihOKmLG5ZRM58dsI+LFF9D5ZnWtvEGRODo3C/i9zK6o9LYs9Ly9c
	 qbG71Cwno4REyAiPyV2yxq/kh5N10nGEtWYoBlUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Baoli.Zhang" <baoli.zhang@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0844/2077] soundwire: fix bug in sdw_add_element_group_count found by syzkaller
Date: Tue, 21 Jul 2026 17:08:37 +0200
Message-ID: <20260721152612.698708457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index fb3970e12dac9c..f016ad088a1db0 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -299,39 +299,36 @@ static int sdw_add_element_group_count(struct sdw_group *group,
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



