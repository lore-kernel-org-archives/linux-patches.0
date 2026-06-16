Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072D333688F;
	Tue, 16 Jun 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626704; cv=none; b=EX5xA9OmJ7FitCB6RikHNmN5Fb7nXAU8vqUWrHe++x6GOECe6YtYwluIGNHNwPmqIpAmFTM6SyW43k6U3TABR66QHP9RZey1eJ7VO6TOAuGxrP49bUkOfUtiNZZmLIT0uf8l5VUgNRcNhLIJSadYKtq0zbHfFknspH6fdskU8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626704; c=relaxed/simple;
	bh=bgqEld5O27kmcbrDVC3mYk8Cs7aR3tguKjcTKklh3VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtcUuVXUfFi2GUSXkksBuaeynW5sUeG79Ncl+As6XJEvGJ6A3CUc7OVnd9ErqM0Pn/MMR0kWV01vBweVVwKgSUa4XLGQMoK0Nww+pJNCDhdZXOqgFDxObe434uPzWHYmM6sr02AnXRZEYwf+oRrZId6rJ0qrAvSqGkDruouw7Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL3N1kDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL3N1kDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D331F000E9;
	Tue, 16 Jun 2026 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626702;
	bh=ztymp7epFO9+uT/BX4J7PpykkDP1IUnCTd5DsJBuscQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL3N1kDAbHELyoyekZaqZFctWFAHl0aY2t8fOwt6P0r5klKDCdgo4fVKXOZlm0AbJ
	 WcU37pIH+yDDzhC3SVxKSbpxLwfpWehSqm0gTxoPGMSnlUpOLOIjUvg3DAPGMAPvq+
	 prB22dvtALrLqLzMmeXs3wCSG+n65Vc0w0oPJQHA=
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
Subject: [PATCH 6.12 026/261] 6lowpan: fix off-by-one in multicast context address compression
Date: Tue, 16 Jun 2026 20:27:44 +0530
Message-ID: <20260616145046.276674049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index e116d308a8df6d..37eaff3f7b6940 100644
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



