Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912F83A7F4D;
	Sat, 17 Oct 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259352; cv=none; b=WIK+CfixVbiuLhzlh/NwVvBvQoQFieBwezV6j8wJajhxN6pWfXdkwWbidQnrC19/ruU/aJiUK9BjlCIel0py+MB3fTDQ7x4Ywt6JjH6p9y7YNxwhxBa4CqIypv7r4jw9TacK4OWD7PKbnNm9a1ZaEgdh3lY4VK0TH26/mRBJfZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259352; c=relaxed/simple;
	bh=tYoYHhbfifjBGkPAjHppdZfK6JRQq2Kgz6+NqTK1cwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHiME4XJjAi0poag+vJp8QvCOry8UqiEaYuZa36W3OOLW/AcYhbo/Q/SiWjAv0sQLURNFByzwr3saSAWgmCvTpBNxOPSih+Cbc5j7lp8nhu3r/zjhs7kKU6p4lRlgVzlX7+qihFtQALJ2umCrlRi4ibbo9D6Y/rFE4q7QCvV2xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pzgw2KKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pzgw2KKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F741F000C5;
	Sat, 17 Oct 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259351;
	bh=97uvgd3qzw3KmRNt8FeLymyQr/2TC4aUtc67M3+JmF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pzgw2KKhL3Dte+bS6P0DPkL38RxNEStY7n9RVjGneHFCogboO1X1BhgaRXW44VOzQ
	 ryJB95ZecZSb3UIEe6JbVyvoO8106APHtW09kMCX9egszNhijTBa2LCbT8jqHUnK73
	 V1Jqiih6+kVw6MZNBZvz17BhtwFfz9f6qKmDV0r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Baoli.Zhang" <baoli.zhang@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1148/1674] soundwire: fix bug in sdw_add_element_group_count found by syzkaller
Date: Sat, 17 Oct 2026 17:57:00 +0200
Message-ID: <20261017160500.617508002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 .../soundwire/generic_bandwidth_allocation.c  | 30 +++++++++----------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index 31162f2b56381..b9b7308977a2b 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -201,28 +201,26 @@ static int sdw_add_element_group_count(struct sdw_group *group,
 	int num = group->count;
 	int i;
 
-	for (i = 0; i <= num; i++) {
+	for (i = 0; i < num; i++) {
 		if (rate == group->rates[i])
-			break;
-
-		if (i != num)
-			continue;
+			return 0;
+	}
 
-		if (group->count >= group->max_size) {
-			unsigned int *rates;
+	if (group->count >= group->max_size) {
+		unsigned int *rates;
 
-			group->max_size += 1;
-			rates = krealloc(group->rates,
-					 (sizeof(int) * group->max_size),
-					 GFP_KERNEL);
-			if (!rates)
-				return -ENOMEM;
-			group->rates = rates;
-		}
+		group->max_size += 1;
+		rates = krealloc(group->rates,
+				 (sizeof(int) * group->max_size),
+				 GFP_KERNEL);
+		if (!rates)
+			return -ENOMEM;
 
-		group->rates[group->count++] = rate;
+		group->rates = rates;
 	}
 
+	group->rates[group->count++] = rate;
+
 	return 0;
 }
 
-- 
2.53.0



