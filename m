Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801F71C07C2;
	Tue, 15 Oct 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997137; cv=none; b=YydL3iBC07ZHJ4eoUng7x/tY6doUCu6mTNGhdj7Y0I+4uv7GfV1EiQ9TXcSiC2QnPzMii9OrqZbvro2J3FR00gpoCBkc2DWBgXt0J0DpIll2KR9Pb6KB90hXGi7S/Iigt1Hhu2RJNtbbPutTGj8rUPdCbysFfPzQtSWTIbV3qkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997137; c=relaxed/simple;
	bh=bSCXKasXnNAbCTzjn8mdtmGcesl6tzfVZqJlVRXoi/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoCo6xK1XexIje4EOWdDZRc3tcNkZz8FJaQYwqWLPhmuYSZxFtcc4l4g4fVDVFvbuIJ29vyOd5Oh5U9t0XNzqbyEVD8jp3F03cnVmncTGVYQzE18wGMiDPpI8zcCyqiNNsUjQjeTHpdR21RfnZXPCMtBi/YuC8AeLPxll/dsXW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCNtl2jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCNtl2jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E87C4CEC6;
	Tue, 15 Oct 2024 12:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997137;
	bh=bSCXKasXnNAbCTzjn8mdtmGcesl6tzfVZqJlVRXoi/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCNtl2jwbXP/MOwDgTJiCVOdyHqbHn3BFosWS9j/UhPjhARnK91qx7ZRptca8jhFE
	 ISsU+42TtvC4YZPamVVfqsoyxXei9xSuQ9PxjY3trVHAynbwbO/cdJgihqR5wuvQ4/
	 iAOFqRBZsLPkUVFaH7vFaoDgnN7DrmaW5ZqoVvgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/518] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Tue, 15 Oct 2024 14:39:31 +0200
Message-ID: <20241015123919.590883807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 87c572ba69acb..5c937c5564b3f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4026,7 +4026,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



