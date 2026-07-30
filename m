Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A23933D50F;
	Thu, 30 Jul 2026 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421914; cv=none; b=AH0a2Iw6ykUvkDhRWA+cOkOYUuxvlaEthhQ96eZf+BnhKw4IDRL0NfMdbnIhMIFEgRkemwfVDVdKUh0vMy8oVDrbKVvK3XGyKWQLSABYLfgvlz1MunhHVGPPUHo508zKd/Qeh7x2jP2cbL/eWsrAK7EuDWBaO2inr+zMZT8jbgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421914; c=relaxed/simple;
	bh=GYVT3Szbw+OasavEwwx9rxeylEuXTa2zkEqwXNJO3mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ2w1xjM54omuzwd5II5fmFbN/XWgpRpYrFUBD1C3WogKlgDIPpS/GxEZhm/Jgsp+niEJFGS+qhf9hn1MjAUIo6OGcj+RKFIlaeHqB1PXrl6t1nxRJOU1n6ivmHjn8ahZsLJyWwrRiFlfBvWpjJKiMYoi+e8Oj4c6GI8K/HWMZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPpjYd93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPpjYd93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940AC1F000E9;
	Thu, 30 Jul 2026 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421913;
	bh=XdP4fVliyfa9zKK7zHf0yWw1PURPpMU75IYUDypG5ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPpjYd93cavL6/J7YRLEdFLjEtx4zgkdezTz0w338k99lkTh2ISYPmTLB2El1GKj8
	 m2C+pK29Qeu4TTDThlWFttaAFNjgWMsxTCRQhsU8jNJK86FJfaJ+rYw9JL9mwJ14QZ
	 XmpXHgkhBNEP/XfJYUyPDSAApgjewImIjH0i/ukk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 260/744] geneve: ensure the skb is writable before fixing its headers
Date: Thu, 30 Jul 2026 16:08:53 +0200
Message-ID: <20260730141449.820400979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 447ec540233c60d6af4d68a164a5bc8ce7e975c1 ]

Make sure the IPv4/6 and UDP headers are writable before fixing them up in
geneve_post_decap_hint. As skb_ensure_writable can reallocate the skb linear
area, reload the GRO hint header pointer and only set the IPv4/6 header ones
after the call.

Fixes: fd0dd796576e ("geneve: use GRO hint option in the RX path")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529144713.780938-1-atenart%40kernel.org
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709125000.141092-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index e9102548ac438d..29041175b7b80c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -585,6 +585,7 @@ static int geneve_post_decap_hint(const struct sock *sk, struct sk_buff *skb,
 	struct iphdr *iph;
 	struct udphdr *uh;
 	__be16 p;
+	int err;
 
 	hint_off = geneve_sk_gro_hint_off(sk, *geneveh, &p, &len);
 	if (!hint_off)
@@ -609,12 +610,20 @@ static int geneve_post_decap_hint(const struct sock *sk, struct sk_buff *skb,
 		     !geneve_opt_gro_hint_validate(skb->data, gro_hint)))
 		return -EINVAL;
 
-	ipv6h = (void *)skb->data + gro_hint->nested_nh_offset;
-	iph = (struct iphdr *)ipv6h;
 	total_len = skb->len - gro_hint->nested_nh_offset;
 	if (total_len >= GRO_LEGACY_MAX_SIZE)
 		return -E2BIG;
 
+	err = skb_ensure_writable(skb, gro_hint->nested_tp_offset + sizeof(*uh));
+	if (unlikely(err))
+		return err;
+
+	*geneveh = geneve_hdr(skb);
+	gro_hint = geneve_opt_gro_hint(*geneveh, hint_off);
+
+	ipv6h = (void *)skb->data + gro_hint->nested_nh_offset;
+	iph = (struct iphdr *)ipv6h;
+
 	/*
 	 * After stripping the outer encap, the packet still carries a
 	 * tunnel encapsulation: the nested one.
-- 
2.53.0



