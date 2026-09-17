Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521885349D5;
	Thu, 17 Sep 2026 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666276; cv=none; b=t+Sd9l1Bv3FHb2wQh+e+wI7oQ9rWtQRGvD1RcV3GHx3H9kpmeg+Thfb/0G91aFf7wTzKfc5JBIk7kJ2F4z2pPj7T1pwqbcX5qa3Yehq2TBMdW5rNX7NVVvibjjNBlz0U6viAWcTNFIbZMlFAq0DSjviAj6mLFdztmSwAMOvAw+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666276; c=relaxed/simple;
	bh=9zcHpzVky8A53TD4EuN+fYOACLZVFAfuVk6WX6HcmGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeR7/d7RK/D4rSGXvMmwtMxole07Gi9Kn1jZZui/OdNXAA0LRA3Fw44X5thvjwJdo8sefbGp3LHT6IN2QsKJNfbFRH51BeAJuybjzMaYk+H7OfSPL29WYc48NuKot5u+fUTjOzC4l81+QB4NGdXSQbNxityGdqvsBhXmp+HoZwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7fJyuGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7fJyuGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CAB1F000FF;
	Thu, 17 Sep 2026 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666275;
	bh=7DtKtBuvkpLWhZ00Ea24YWf1p5ITmoQpsZhkxqgFzLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7fJyuGYSZUnWgFIfctbLnoLxs3AQm2FwQDHdwK443LDkaQ2yb7M5f7fMXyjJmUZ+
	 VT8B8xFqDXif0/jYbwhnx7GqIrMRreSEZlLjczAWTAImcLcYDGbXkSG7/Gie/idkBm
	 Arphe3i6lCAXspdSUYdzW8Ay24IL3CSJMoTi0eg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0945/1250] openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()
Date: Thu, 17 Sep 2026 16:12:20 +0100
Message-ID: <20260917151617.638940291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit e184a4a6f423550a25adce867036cdb1ff471745 ]

The ESP and AH cases in get_ipv6_ext_hdrs() used IPPROTO_FRAGMENT instead
of OFPIEH12_FRAG when checking for out-of-order extension headers, causing
the fragment header to not be recognised as a valid predecessor.

The original code used IPPROTO_FRAGMENT (44) as a bitmask constant where
OFPIEH12_FRAG (1 << 4 = 16) was intended.  IPPROTO_FRAGMENT encodes bits
2, 3 and 5 (OFPIEH12_AUTH | OFPIEH12_DEST | OFPIEH12_ROUTER), but not
bit 4 (OFPIEH12_FRAG).  This caused incorrect OFPIEH12_UNSEQ verdicts in
both the ESP and AH arms: the ESP arm failed to whitelist OFPIEH12_FRAG,
while the AH arm accidentally whitelisted OFPIEH12_AUTH.

With the fix, a packet with two AH headers now also gets OFPIEH12_UNSEQ
in addition to OFPIEH12_UNREP, matching the ESP arm which already sets
UNSEQ on a repeat, which is the intended behavior.

Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/1b1582eb07550d71f3cbe210e5cb31eeb8d0ad86.1788876917.git.echaudro@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 46c1d66aad8c3..868d9fdf3afdf 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -288,7 +288,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
 			if (*ext_hdrs & OFPIEH12_ESP)
 				*ext_hdrs |= OFPIEH12_UNREP;
 			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
-					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_ROUTER | OFPIEH12_FRAG |
 					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
 			    dest_options_header_count >= 2) {
 				*ext_hdrs |= OFPIEH12_UNSEQ;
@@ -301,7 +301,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
 				*ext_hdrs |= OFPIEH12_UNREP;
 			if ((*ext_hdrs &
 			     ~(OFPIEH12_HOP | OFPIEH12_DEST | OFPIEH12_ROUTER |
-			       IPPROTO_FRAGMENT | OFPIEH12_UNREP)) ||
+			       OFPIEH12_FRAG | OFPIEH12_UNREP)) ||
 			    dest_options_header_count >= 2) {
 				*ext_hdrs |= OFPIEH12_UNSEQ;
 			}
-- 
2.53.0



