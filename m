Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD972580F6;
	Tue, 25 Mar 2025 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906124; cv=none; b=q12Ncs28yuvv2DgqbDMeTN3n6YOrM8HbWfB5VX9uVW/dT4e79RVyp7MgxUVRqmYZIGcH83Lan988sPbUlP2EDyXTedfDQxW9pUyjBRXeEGQHtRTnEbB0AtJRalsZFJWwfozCOu7+s6oTrrpVFeLC5YjT2Yw0MoEGW5nAyxM4P7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906124; c=relaxed/simple;
	bh=mCkBDzY0QKmH9fJUo3rfBLCaWDb63BFUqXW056a0Ufw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+KDH1+Y5vk27iPN6Is+2bcsnDfOFBAHnBW43zGXYmNq7zIPi38w/FAoZUz9dS7OxfH6iC4vpwcc+guNHBYW2NLdxZzzIP64u63w2cY1+ghCipbbin5ilnQjl+MJHb8qJz0KU7k2cESrU5dEpmUSWrPpv27MgaXwbDv+okhPvp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D+CcpeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D+CcpeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A48C4CEE4;
	Tue, 25 Mar 2025 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906124;
	bh=mCkBDzY0QKmH9fJUo3rfBLCaWDb63BFUqXW056a0Ufw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0D+CcpeEXnNH75WbWnBXoTJsgcs1wdQA6om7LA3JofVFEXU9oYMD2fBT8inpggvYv
	 zjAjLMtUR6MtyDHZmh2qnsMyhfCRvNw9slZI6mXp9HV1p5uJ6DhvqkJJxrM52I3T2l
	 ZBF1pc8ENglsDi1kTri1AWvwOAvhJg/78PtLhlM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 27/77] net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES
Date: Tue, 25 Mar 2025 08:22:22 -0400
Message-ID: <20250325122145.062822001@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 90a7138619a0c55e2aefaad27b12ffc2ddbeed78 ]

Previous commit 8b5c171bb3dc ("neigh: new unresolved queue limits")
introduces new netlink attribute NDTPA_QUEUE_LENBYTES to represent
approximative value for deprecated QUEUE_LEN. However, it forgot to add
the associated nla_policy in nl_ntbl_parm_policy array. Fix it with one
simple NLA_U32 type policy.

Fixes: 8b5c171bb3dc ("neigh: new unresolved queue limits")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://patch.msgid.link/20250315165113.37600-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e44feb39d459a..1e2e60ffe7662 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2293,6 +2293,7 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
+	[NDTPA_QUEUE_LENBYTES]		= { .type = NLA_U32 },
 	[NDTPA_PROXY_QLEN]		= { .type = NLA_U32 },
 	[NDTPA_APP_PROBES]		= { .type = NLA_U32 },
 	[NDTPA_UCAST_PROBES]		= { .type = NLA_U32 },
-- 
2.39.5



