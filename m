Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8EE29C349;
	Mon, 12 May 2025 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073102; cv=none; b=VezlLp8PmTrwfH8Nn7FG7o34Y5VyE5x4fyW7eftHUIp65V35GESQ5WZ+QJ1Yy38TKa+4V1dazlGEfolxEjyAajnKhgqskPVBthc/N8J9S2X8odwzNAsB2OH4n7g7uWYIYTT7dUX++ypCYPWCd1/9uwE+0Qai9RPdnbR/8xe0yBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073102; c=relaxed/simple;
	bh=1fXxdmjBAZoi3QflX7ew1py07w7QX9cGXStVQVebULI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8fZQhE8XQzLXqZzSc8EhDpIe1NbQ3F6rJ+sf1yU2qrvO6zQcKbFaA3vVwS6LGJf2H5joJwZPwnCJPT2AsN/si20MRtqvxiOuG2mqgCPGPYXAR6tlSxuiV05cDQ2CX/lWEhZDU25aoPP5q/8kNoZhlWw/pW1Ifzh0NIsAhJeDKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxNGU0r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxNGU0r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA202C4CEE9;
	Mon, 12 May 2025 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073101;
	bh=1fXxdmjBAZoi3QflX7ew1py07w7QX9cGXStVQVebULI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxNGU0r5kmp2Ot92nRI0RFWL+krqdCL+p7gmfLSdwXShr8PX/oWrsx5HZJ34NoUlE
	 AtU9b2rJV3vaGLgIuTKoM2roZCsLmIJkS/Sq/ticTJyApskDUP0csTX7Dg23GPzIBE
	 OSHsn0x6dIEKrb/vQHeLnXwoxXwmXyb7BEdEO9wBDPVE9q2tpVmK+BftqxQkaAmFz5
	 qVS4qT73pN9FVUdprrHTl7H0ne3qligPu6hhVzFz7ndn+I310GsqG5tGgPEUXeUy7E
	 1aaF4rT9AfIX1IT+MUGlNFUgrhZQip27v85/k7LPjJH32NqGlrrl/LoLt3DcDlW1Gf
	 lvREP2cMkM3Cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	donald.hunter@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	nicolas.dichtel@6wind.com,
	colin.i.king@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 3/6] tools: ynl-gen: validate 0 len strings from kernel
Date: Mon, 12 May 2025 14:04:49 -0400
Message-Id: <20250512180452.437844-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180452.437844-1-sashal@kernel.org>
References: <20250512180452.437844-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.90
Content-Transfer-Encoding: 8bit

From: David Wei <dw@davidwei.uk>

[ Upstream commit 4720f9707c783f642332dee3d56dccaefa850e42 ]

Strings from the kernel are guaranteed to be null terminated and
ynl_attr_validate() checks for this. But it doesn't check if the string
has a len of 0, which would cause problems when trying to access
data[len - 1]. Fix this by checking that len is positive.

Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250503043050.861238-1-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index ae61ae5b02bf8..0871f86c6b666 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -368,7 +368,7 @@ int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr)
 		     "Invalid attribute (binary %s)", policy->name);
 		return -1;
 	case YNL_PT_NUL_STR:
-		if ((!policy->len || len <= policy->len) && !data[len - 1])
+		if (len && (!policy->len || len <= policy->len) && !data[len - 1])
 			break;
 		yerr(yarg->ys, YNL_ERROR_ATTR_INVALID,
 		     "Invalid attribute (string %s)", policy->name);
-- 
2.39.5

