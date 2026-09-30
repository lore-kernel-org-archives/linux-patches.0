Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3243CF21F;
	Wed, 30 Sep 2026 19:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795527; cv=none; b=ETJ1/G2M2KjB0s9hx3ZNCsqaS9aPnVjd3U7wUYL+hjN18W6EYWFx/akD7jn/2o/MG30i+KEhHNCRKh6J5BwQrl6vMKQQh3d3Tji5uaA87qREOKkuUswG+/GbFbQ/Wr22qKwvEmWhrz7j4UW3dz/+OoG8vTaPgYYCRAzTSwXOD+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795527; c=relaxed/simple;
	bh=oiywEbxAD7u1G2a0vls4Ey7nUjsN/TgVNe0aieC4nG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvjtViEMsOXLMoPz7zvctL8NMRkr2AYapt/yqx8fU0KRsL4RvycskoEa11v8zBfgwM+8IJ0mcO9N1msiOIioCT7fubVr0ObBI/F3jURiY/Xy/jSK0OgwGh09F7g5zsXNzc3cv3P0jCUIqh541JSLCeGj7tqy1cN8cCV+Sz1Gf7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1ZyKDpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1ZyKDpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46E11F000FF;
	Wed, 30 Sep 2026 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795526;
	bh=N7LWrj9rBTOBYByz+3bowzkWiM4OGmJL1hZ3KxybBEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1ZyKDpPOXtjqXkQVHUL2Th5k2HWstA2WWo3GLVNlAxia4GxF/uj2gTva7wywJDiR
	 0orlQ74zytTkxU4VlSs9CkaOw7WdFt9K3jsPaAWnzF9JXs4DmdY5Gk3eOChrH13VOa
	 dYrSKpAcvIQzKy4V+PYEQusaFCdDXdKGovU54nUk=
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
Subject: [PATCH 6.6 0592/1193] openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()
Date: Wed, 30 Sep 2026 17:21:16 +0200
Message-ID: <20260930152447.398654943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 52e261ce91e8e..45e8b24bfe1e1 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -292,7 +292,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
 			if (*ext_hdrs & OFPIEH12_ESP)
 				*ext_hdrs |= OFPIEH12_UNREP;
 			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
-					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_ROUTER | OFPIEH12_FRAG |
 					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
 			    dest_options_header_count >= 2) {
 				*ext_hdrs |= OFPIEH12_UNSEQ;
@@ -305,7 +305,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
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



