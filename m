Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EAC45C14;
	Mon, 14 Oct 2024 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917527; cv=none; b=lX8dYQ8KHwgXmd/n3plAefEyawnzA5WvjgASUjSNDrX8t0i5HjMJxhxBgk7ZXhw0VHv++hh6WB26A2A41zowbSLDB3H5NUBZ9CwYSUOK0zUYIsER8l3ZeXZTKX2+piL5E+x1SVbPS6or5iEthdZYclHlqB7barg5WyEuQ3li3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917527; c=relaxed/simple;
	bh=rng+6errRp9ojH6+oTa8pVlMDVfMyeGYm8XZcO71iHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSdPxV6Ym8Xmi44RiKV915cosdmeMLP/bU3qPWDzF31CPVlrDkErnfBqFxN2WCZXUrzjQbUw9rqOWKNSZDl2oWPfyOlzfwe9rzfw7dlWP7GKWP8XhvCR0gw/pmmziXV3QjD7Jpk+P3Cy1x6SyHYnJQNM6UWR66oxiD/VxndhWvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hyxfsp9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hyxfsp9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221C8C4CECF;
	Mon, 14 Oct 2024 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917527;
	bh=rng+6errRp9ojH6+oTa8pVlMDVfMyeGYm8XZcO71iHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hyxfsp9gdGY0tFqDJezpX2snx7w62ZkTUBV+Y0E45zS1ns6g2jergF2IRiPQQPL4e
	 H6eE8HBNc5f9Lf81VwTEGxCLFn7gN8MVDn/JRkHmkSk3BICvW/8mwBhxuJg2h5HBki
	 K7sTiiQwVn309XUrkN8qwa2yfqMjjiRGo6lXBz4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/798] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Mon, 14 Oct 2024 16:09:41 +0200
Message-ID: <20241014141219.015368649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e0c47281723f301894c14e6f5cd5884fdfb813f9 ]

Element timeout that is below CONFIG_HZ never expires because the
timeout extension is not allocated given that nf_msecs_to_jiffies64()
returns 0. Set timeout to the minimum value to honor timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 25a9bce8cd3a4..4ebd3382f15b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4223,7 +4223,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



