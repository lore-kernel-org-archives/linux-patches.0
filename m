Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD650277A;
	Wed, 30 Sep 2026 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785387; cv=none; b=g6k8DtymFd6V8m1NHKWBd0KUOioG0Aem+6HnWtB/X6hf1+1kD5tW5kllzMnvfJ6CRYX5L9u4NDqW3o9h7rleHJ1UhMDYK1bR2cUE6h4ENJUVY8XuzjlLHL6kawVxanJf0p8uoH4Q+vXNwE8UFlSgnGmR+6V/PneeUgBz64Re9pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785387; c=relaxed/simple;
	bh=WVDWsotwBuERpMTEdtZD5YKwv+7Aajz6p3Obj24ohb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6WoEnE9v0aKLi9oh7g19KLt0Ku1kALUI7Pq6Wh2T1ELFFQkEHSkgMHp+bXeKujVcZfp71H/1ogTPW/FVfx6Qk/3viGcVpdOIJ/6jHxKYUwUPI+luYQe0sAnPjI8ehr5w/C0efFND3Rf98sUHkyQuI/FX3lpjbL+fNSQF51guyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2es0mHEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2es0mHEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA081F00893;
	Wed, 30 Sep 2026 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785381;
	bh=ThK778fDlH7mPkpRVEhPGpuMNM5BaYs8cu0cP+f5iZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2es0mHEVBOkvy9QFbMWAsDts7OrQ8pst+Gp+Q+ZcXVJtqmpg3CRmuWP27hnf+7WKM
	 kRvhzRMSmZuvewqzgFwp+/dmY412Mj2UA00HejhM6UrS8wWTGN+JLbhAkhNHmXYkaX
	 N+crQ6OAw/9k+tzTkGT7Qhr4L8rU1H9k8JCxXvjU=
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
Subject: [PATCH 6.1 487/982] openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()
Date: Wed, 30 Sep 2026 17:20:23 +0200
Message-ID: <20260930152427.241809320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 3111817293aa0..bfb96f0876900 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -289,7 +289,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
 			if (*ext_hdrs & OFPIEH12_ESP)
 				*ext_hdrs |= OFPIEH12_UNREP;
 			if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
-					   OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
+					   OFPIEH12_ROUTER | OFPIEH12_FRAG |
 					   OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
 			    dest_options_header_count >= 2) {
 				*ext_hdrs |= OFPIEH12_UNSEQ;
@@ -302,7 +302,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
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



