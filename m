Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB23C43DA53;
	Tue, 16 Jun 2026 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622963; cv=none; b=KPTf9DO6JixcFvMfaZwb8s0eeFRyuS1roFLF6yqimHJAoPp8Jq3xIDmMETBOdvYQMTcxrjkdZpZlTN0z3J4IXPTBAvLITb0vwniI4tZ6UZkEAdMw289/sq57rCjhDPgI4lfOLpSlaO6uGpcv86QrYKmWuwRACvoy8iPIGdR2uGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622963; c=relaxed/simple;
	bh=vPUSj4SgdZs7no+zH3LE4HSmhnVM2wgPOklf0v7p3YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzPtMnh3MKn15JIPDWnUHMUODVhRDU/PhmLfd4NO3xhzKxoEGCXL6EMFE/IVTz49pZcH0FDob4sJaBXMHNu+e82uicfThgyqiQtyN8CDL/UHFAX5l+G4WuKlmHzUyW3EPc3WISVOyIm1W474BvuFJefByrYi5PI2YYaBHSm4EAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCCYspG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCCYspG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938BF1F000E9;
	Tue, 16 Jun 2026 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622962;
	bh=hUk0gHHDuQpTeo15xsMihHzTaxalxPIQkfssC9NIG8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCCYspG49V0R/qZCYaZfjAFRaZfSKL6dGfQkZKXKXkxZ+tMMHNPRXSxkqVnjALFYR
	 NyHOZ1Brs9PkNO+qcAUoiK5b9sfTCQ8tgFsAo+CzCgktHkKmdrhKSgY2fbLUN9CI5L
	 DFUzAoLPiRf5aEoQhPCHWAGi2cFWBMa6U2BJY4Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 062/378] geneve: fix length used in GRO hint UDP checksum adjustment
Date: Tue, 16 Jun 2026 20:24:53 +0530
Message-ID: <20260616145113.277476872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1231623fd3b5aa6b41cce799ffb0d82e10914be4 ]

In geneve_post_decap_hint the length used for adjusting the UDP checksum
should be 'skb->len - gro_hint->nested_tp_offset' (UDP length) instead
of 'skb->len - gro_hint->nested_nh_offset' (IP length).

Fixes: fd0dd796576e ("geneve: use GRO hint option in the RX path")
Cc: Paolo Abeni <pabeni@redhat.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260521131436.748832-1-jhs%40mojatatu.com
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260529144713.780938-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 01cdd06102e0db..8ea9482d52e538 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -633,7 +633,7 @@ static int geneve_post_decap_hint(const struct sock *sk, struct sk_buff *skb,
 	uh = udp_hdr(skb);
 	uh->len = htons(skb->len - gro_hint->nested_tp_offset);
 	if (uh->check) {
-		len = skb->len - gro_hint->nested_nh_offset;
+		len = skb->len - gro_hint->nested_tp_offset;
 		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
 		if (gro_hint->nested_is_v6)
 			uh->check = ~udp_v6_check(len, &ipv6h->saddr,
-- 
2.53.0



