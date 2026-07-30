Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C570843E08D;
	Thu, 30 Jul 2026 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425085; cv=none; b=lbQcy5kSYsjPcP6BHKdkjiiXz/xBL4oRpK2C1yX15/YPFbhNpMw8gQiMTkITa9iho1bGMH502s9fMfDH6VwmjLucsoR4mqSu4zQ4L3iuZKx5d6yMGD2DK/F+ZCgY317zArAISPF7NRFKPmcSygnqyhZzAuZLsCWI5MD65UdZjoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425085; c=relaxed/simple;
	bh=t9noN5nznrAaaUR0Sch6o+Zrdgcv2gA/2e+NvOrdPLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I95aq01B08OGua/7fwm6BMvEKGiPw3mWhEMwHg9LjcRM9kyBP/4RLFsqyVa+vkhdidnbbrYepKit66qK+Lo4PTHUbnohIYniMt8f0Cprqnuib7CKUB2PHViCLAM7VinOQqq2l7U/kswdg13P6W6FDICLE3aCNIx1ctTcHbRO6OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUAJM2/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUAJM2/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244EB1F000E9;
	Thu, 30 Jul 2026 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425084;
	bh=Bv29E7yT+rOSb3nT/4AzutPllPJtcCPPsC/tLloGaps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUAJM2/BU5ZkpfcPvbXfxlMSv1KDF5kwaYOGZEUdYwI01zH2Af1UyZgGoPzOTeLN9
	 3hrnRy3ZLI/V4XApUp9FiHO2njdwvqecASKH18E6zd3rkS3MLGwjfMTU8ffHoqF56y
	 +iaHN1n3I1/G5inAyYMgvnyJ4KiN5ALGJ4b6MbNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/675] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 30 Jul 2026 16:15:50 +0200
Message-ID: <20260730141458.297416305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


