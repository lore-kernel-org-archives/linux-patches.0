Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C72175A6B;
	Sat, 30 May 2026 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164833; cv=none; b=mmwHVwTJ2x6eMCFVxqiQFH3qdX4//uwMo1Bk9M3fBpgwgan0nAM2zR3THqworkHI4Wh0lBOPlsDcrixdFbMQh4WfoYo4VtmwoZ9lSBqcD1JNmBFrPmFhSpKAadxOF/SKHUFbfaSSMQl4ZjBKFMAc1ylsCc1/sirbu+plLGQ64MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164833; c=relaxed/simple;
	bh=eeVZ3EL1N2YmryYXUhcl3wRvkrtLfFQWMG7ommm/lVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL+UrgYzYGIgi/jDQFHF7FzPhXgYMxg+bk28jIrBYX3OXnFJvfN8iaiwvTWcxaC+q0jQj+ekmnjdZ2iLdaVO4q4Ku085PPpXli3lwuQc0T96M4hpPjfEwNSIo6uwezpRq6wrmHamVEmOqF5XYpGZpUn+T71q+6KqXCYfKx/+uzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3hHWk+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3hHWk+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF841F00893;
	Sat, 30 May 2026 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164832;
	bh=utdQaEgyZcLvOyqCcncqEZiL6nSHLx9cEP/LbTbu6lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3hHWk+Rw/layB+te423JPIGVH7BvSwYr75CzqE4yXtE0C6Jk0LSfceU/DwQdCXxe
	 DRNXAAeQi1veseIFT0PhgjoHTEWtJm7c0sJiVl2VRtMk3Otje7s2CLq+VkOGOZH7jq
	 lQJclq9t1jz2+7QgR9fKiRdKhitIzMBn/iZnmWWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 672/776] net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()
Date: Sat, 30 May 2026 18:06:26 +0200
Message-ID: <20260530160257.240117873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5f2b28b79d2d1946ee36ad8b3dc0066f73c90481 ]

There are actually 2 problems:
- deleting the last element doesn't require the memmove of elements
  [i + 1, end) over it. Actually, element i+1 is out of bounds.
- The memmove itself should move size - i - 1 elements, because the last
  element is out of bounds.

The out-of-bounds element still remains out of bounds after being
accessed, so the problem is only that we touch it, not that it becomes
in active use. But I suppose it can lead to issues if the out-of-bounds
element is part of an unmapped page.

Fixes: 6666cebc5e30 ("net: dsa: sja1105: Add support for VLAN operations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250318115716.2124395-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index baba204ad62f6..2ac91fe2a79bc 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -1921,8 +1921,10 @@ int sja1105_table_delete_entry(struct sja1105_table *table, int i)
 	if (i > table->entry_count)
 		return -ERANGE;
 
-	memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
-		(table->entry_count - i) * entry_size);
+	if (i + 1 < table->entry_count) {
+		memmove(entries + i * entry_size, entries + (i + 1) * entry_size,
+			(table->entry_count - i - 1) * entry_size);
+	}
 
 	table->entry_count--;
 
-- 
2.53.0



