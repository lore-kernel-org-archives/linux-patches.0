Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D37831B124;
	Fri, 21 Nov 2025 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731861; cv=none; b=sU8XZqvdOTlEIMX57yQ4ky7mgjEDc5DkL6CPI7sI3CMcMzbxDK/lmDbEekZHW2fKdwnYfK3FB5pXQAs5oZFdneE2N13WW558bn+ENLsolJ6ENcWo1twew3BL9aD4nnm1fkcLBacxvOGeWs8eS3e1ejk6h5gCg/w9gwiEHFfLPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731861; c=relaxed/simple;
	bh=RzqIhO8No9nhu/rk0Fm4bpbHk3FuI928L89JYg+PNBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMaK0Ae47XR47kwrmpLLnaNaXzFrTSrtYR4fFB++ptLPNO4PAfmanI3l4vTx7VWhwpDomObtRXSyHrI12eHhHxJseeuKDutYfVdNkQcEEwPmAmHHk5PwGI3mDCyqkYWSujrAS3vlfniTyF6nmvzG3WGl2yYtpeUB9owdmWLra6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHGB1fNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHGB1fNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7464C4CEF1;
	Fri, 21 Nov 2025 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731861;
	bh=RzqIhO8No9nhu/rk0Fm4bpbHk3FuI928L89JYg+PNBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHGB1fNI3n4gO4/DcRQdgZGRaq/2PnJCHfK8sp9mXA4cC/Es3a+ggMPnSkVi3SYvC
	 Zi6s9G6bmoqVAfDgvl8ClOVpXKIHcbjDPbtVxm4bdL0xb2SnFOf+nLzZ7q7a9fmF3s
	 UUCaG8Y4xhzxmzemK83WHioeypl2SGaA2ir+IkJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Chen Yu <xnguchen@sina.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/185] net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()
Date: Fri, 21 Nov 2025 14:12:13 +0100
Message-ID: <20251121130147.698852173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
Signed-off-by: Chen Yu <xnguchen@sina.cn>
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
2.51.0



