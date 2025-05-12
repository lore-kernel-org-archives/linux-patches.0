Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E2929A302;
	Mon, 12 May 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073079; cv=none; b=q05BzVlFpYvTVqUND9F6mpBw3J05+/64eeNge7p4Fv0Pt1RtggBFXewqJvJQn3SMHl+r9VTY0AgcNAj4S/ceUBnTwEOhDWlRmY0/y9emGEtqO1zidbeCGwH3LfTcuQZp1M8rOSALWhjg2xWuq69cM1tc7+BhuOQzQlvY3HHANVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073079; c=relaxed/simple;
	bh=8d+MIh0ZJExvxWHnilQyk/lGhI/iKEiO0XS+vqKLqqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tKlu5qHPcVyg1veZTu+SnplNhFvnYhb53JfTaKGOWzykTDvERau4HQtQ9HQR5c3izJoWRwmt6DJl0c80K5nBLRYimAJTDh9yI67Hp4Zae0e9+udxMPc71DsGMmoRtpyu/mUW7dquc+yCCHPRqybt7qdqlqtNytaUxb3GVOZT+4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l96ClnrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l96ClnrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CCFC4CEE7;
	Mon, 12 May 2025 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073078;
	bh=8d+MIh0ZJExvxWHnilQyk/lGhI/iKEiO0XS+vqKLqqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l96ClnrOe15fXvqtRziwmfo4fYHTSvvVR8aYQ/0K1j7gAEiGt+Xehn4R3g9mb2IJi
	 8Pin9+Y2Fj5tZ22yZjH+MnZzX0+dJkvxkkwxfT7jZBRpNmeSOgnrcI3xcz1E48wVa8
	 L833J7ngiMlxj4TfJyvjct9bNi1vPSM8TGZjF47WEWNPqydIgSw87Fu62DOW+J/Crg
	 kdhWDu1t2oYeVo4dcsN2qTDflMGVoD2WTCp7lP0c1ogyPZsiVLSy88d6zUR1rjYxG7
	 RovkxS1pGwTd4agNN8OtiL3MrnyeEFZ/XRYq9xPvVQn9yRLh8dYCQHmU7QuVuHOdQo
	 qFX4A1TV8/syQ==
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
Subject: [PATCH AUTOSEL 6.12 05/11] tools: ynl-gen: validate 0 len strings from kernel
Date: Mon, 12 May 2025 14:04:20 -0400
Message-Id: <20250512180426.437627-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180426.437627-1-sashal@kernel.org>
References: <20250512180426.437627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.28
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
index ce32cb35007d6..c4da34048ef85 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -364,7 +364,7 @@ int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr)
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

