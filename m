Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32543D4E9;
	Tue, 16 Jun 2026 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631360; cv=none; b=jNIEvc/r/u+GQrJf5ZY72WF2a69JuqvA+H0D2Zvqse1gbwZ54CRHEUURGz/RUVugyBh8rAumF/JrIBN27zEOKVynp+GSvXuaQT6DUwFkx2T6JKzLo0rBppil6ObYLuzoIkK4eDQmRWmw0ib7rl40l2ZPyB8A0QHiWpLmnqLKaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631360; c=relaxed/simple;
	bh=lDQXyvqkfEKGIwZaRpsgmOlSMvMX9BybkEEVLbgkxSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMFig12d/G3pwJGJTg6Vxfh6tamhJPqd0RDDoa7oRTAJIuQ3bg363CEQD7EDZZx7axysi7LJj7Chc6rv4+xw9OVoyzRKZh0ZW+KjAMyskQzjh6RGkMx8+GumDaohZeQDQKn4YlNeUhD1xZrVxOh7DjtMY+aOCFzbMLD2xUtxJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxdX9FEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxdX9FEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524D61F000E9;
	Tue, 16 Jun 2026 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631359;
	bh=RmSKpOstwtv52ufND9ONQjUyMp36KG3iLLantz+Js4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxdX9FEhYoVyy8ksi+od8prYPyD8gjhCrC1Oxb0cKBvYWIb2p8Ot9gx37RqnGXPGp
	 lgtWcCRy45BUrfr66vviBEALudKGK5iS/zAIf2WctaPZ9VuFb5ZncV8qg5vjx4HDQA
	 NqjbMWBXNQqE45ogKxqrfIJ3fDgIKe23iZeFbRxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Alexander Aring <aahringo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/522] 6lowpan: fix off-by-one in multicast context address compression
Date: Tue, 16 Jun 2026 20:25:52 +0530
Message-ID: <20260616145135.659851654@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 2a58899d11009bffc7b4b32a571858f381121837 ]

The second memcpy in lowpan_iphc_mcast_ctx_addr_compress() uses
&data[1] as destination and &ipaddr->s6_addr[11] as source, but
both should be offset by one: &data[2] and &ipaddr->s6_addr[12]
respectively.

This off-by-one has two consequences:
1. data[1] is overwritten with s6_addr[11], corrupting the RIID
   field in the compressed multicast address
2. data[5] is never written, so uninitialized kernel stack memory
   is transmitted over the network via lowpan_push_hc_data(),
   leaking kernel stack contents

The correct inline data layout must match what the decompression
function lowpan_uncompress_multicast_ctx_daddr() expects:
  data[0..1] = s6_addr[1..2]  (flags/scope + RIID)
  data[2..5] = s6_addr[12..15] (group ID)

Also zero-initialize the data array as a defensive measure against
similar bugs in the future.

Fixes: 5609c185f24d ("6lowpan: iphc: add support for stateful compression")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://patch.msgid.link/20260527081806.42747-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/6lowpan/iphc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/6lowpan/iphc.c b/net/6lowpan/iphc.c
index 52fad5dad9f715..d762c49e722fae 100644
--- a/net/6lowpan/iphc.c
+++ b/net/6lowpan/iphc.c
@@ -1086,12 +1086,12 @@ static u8 lowpan_iphc_mcast_ctx_addr_compress(u8 **hc_ptr,
 					      const struct lowpan_iphc_ctx *ctx,
 					      const struct in6_addr *ipaddr)
 {
-	u8 data[6];
+	u8 data[6] = {};
 
 	/* flags/scope, reserved (RIID) */
 	memcpy(data, &ipaddr->s6_addr[1], 2);
 	/* group ID */
-	memcpy(&data[1], &ipaddr->s6_addr[11], 4);
+	memcpy(&data[2], &ipaddr->s6_addr[12], 4);
 	lowpan_push_hc_data(hc_ptr, data, 6);
 
 	return LOWPAN_IPHC_DAM_00;
-- 
2.53.0



