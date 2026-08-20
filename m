Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFDC35DA68;
	Thu, 20 Aug 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248205; cv=none; b=QgHO0uzi6QtLysfUOQskN4Twkocqh+buIojskMW/qIwPEii5J/ZRn6qk6BAQ5YcSjDmDo5Q+FrC/ZcP7Zw1f7+Q+RJLNMzAmhXLiU4mJk4Ohs0UeKG7NKSnPC2MZ1wILtHRAB2RGTm15UC7+SsnPxVbpzrXYw3c4t2OuqcyX15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248205; c=relaxed/simple;
	bh=FPNllEDNmgFPOPm9IVGWXQlY8BTv70OcrRMkQKkz/Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6TsmPUnczmyFKnGbn7HgLlOx4hcD/+MuTznubyB2TN4F6S3sIW+BzlYtYQkxjdeXoDVvec7+RX0uWRBrCAhnZfmws1pgtyh+mCVJ/FPAW0Pfiv2nGHE/6+iQ8P94PLNuDmiyDouJsKWQ0h1wruJufoVHkm1cy6Bq0obdV2LGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEtQNica; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEtQNica"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCC01F000E9;
	Thu, 20 Aug 2026 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248204;
	bh=n5Cw3VJgeZeSrBPle3ERg1rxE6+Q/v9bxN9FQkirf1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEtQNicaFYGymCgDCyq6IM5MDF233lmrJShCEWF+OgoZ7FT77xp+Y9UgKJ7F9yZjt
	 NoIsO0z9jL89AJP/pZyCjORnm62VVhM9aUYhh1XvWsXc7g1pjcZrrcXjWeBA9C1LbD
	 4m3jWJo8JIWn6Xsw0QXUn2e6tzek3/74xmq4v6tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/303] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 20 Aug 2026 16:54:03 +0200
Message-ID: <20260820145256.500296478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970d6aaf710db166de98c5356a260089896fae5 ]

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: e5e24a365a5e ("netfilter: nf_conntrack_sip: validate skb_dst() before accessing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -948,9 +948,8 @@ static int set_expected_rtp_rtcp(struct
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 


