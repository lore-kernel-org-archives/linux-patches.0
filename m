Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FC91D5ACD;
	Tue, 15 Oct 2024 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992483; cv=none; b=ee5LdD4Ur+XVX53Kb9gu6sCfherBGxsd8nuVmVVAb6Pk8IwI+J+6fdNrwfaECYVKp3CV+PcyjX8K1jWZPKnkfiv6Lr+YqyhdbHwwAxnE84E+WklQXbsmqcEy1IKZR8MG28ricAdqvPFKzq5w38rUZfGfyLtj8sietYU1tid3ZAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992483; c=relaxed/simple;
	bh=qEbbbV7+y5wHr/bnRBcCTAxF7KqH8u5CNKS+AVu+wmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYlevNIybZ8RJiNH+t2DXoW18J/mpGXzCRAaEoNQEdoSMD9mtohkiDeBdUoMNcqKJkxGy1pHLrjCirds5lgKGCCKLmMPNXuNsAZ/WPS1e1wG8TtdoXha2NFy7H0Dkt1pCSHcynWhkzXCjTmry4iZ+cg0GhXzjlUckutgfwG/xxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPYH6L1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPYH6L1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693EDC4CEC6;
	Tue, 15 Oct 2024 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992482;
	bh=qEbbbV7+y5wHr/bnRBcCTAxF7KqH8u5CNKS+AVu+wmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPYH6L1jVoyg6XuwJ/B6db7mNLYKOR1UuUe1iG+40Y8VJ9zCESmw02cio7PYiDILR
	 6LRfuPh5+ShYQpL6lgGGtND3udllIMFF+8x38bxwlrWMUZ2ewypBV+F0W8NpREtN1z
	 BFrZI8XihAhZXO4XKMvKXlpmmBT23cK4HAQxOdkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/691] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Tue, 15 Oct 2024 13:20:59 +0200
Message-ID: <20241015112444.768014986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df10a2047bb0e..c00a9495f3453 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4153,7 +4153,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



