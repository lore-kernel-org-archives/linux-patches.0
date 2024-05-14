Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E5512E1E2;
	Tue, 14 May 2024 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687392; cv=none; b=r02DFu2/XUeHD3HBh7F3Y3XJEUac+/80BVfC6QXW8fXZqLBq9MmcsOOi1XpZNVM+MLlHERHu07HrxmRjinTxduVezofxHPbFVm2nCq9p+sicp8+4f2VHqS9sZM6pVEXsX345zrpjvFm8RQLRQismzmfzRjNDdj1uSMS5hKV1yhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687392; c=relaxed/simple;
	bh=iy8T05sE1KVG7kH1qLEI+AZjfgb2Xg7tcFYaE2AsJJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzU1WlA3Lr9YfYC/CB7hoOZ7q1wQIl6i7WXGitjNTFWAodOG2o9sZNdVCzIgTGyMDtHzez59m4odhqshXPaJS4DJwNXnhZ6/nLtVEm+sBBKEXHL1853UnlQi6cBS/bVfQiCSs7QpMo+FGbaGJC4JTrMDFn5ViaeYcMSRC0VREmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAsr1iM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAsr1iM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9631CC2BD10;
	Tue, 14 May 2024 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687392;
	bh=iy8T05sE1KVG7kH1qLEI+AZjfgb2Xg7tcFYaE2AsJJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAsr1iM6FJhM34PbklU70EHqHPYeWKEnNgeLcMTqRZEKybdGrN490dTAjzI6F0P/o
	 2USyfSj4jnK/nL42g6PcyceRainv7u3WFvx+AtWqU2Fs6Ag437NehPxnDH4DT+i/8A
	 u2Y3iqQWWyU6fzqdLWRo8EMCpt6VU2+Zq1MeVgnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roded Zats <rzats@paloaltonetworks.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/111] rtnetlink: Correct nested IFLA_VF_VLAN_LIST attribute validation
Date: Tue, 14 May 2024 12:20:18 +0200
Message-ID: <20240514101000.174531098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roded Zats <rzats@paloaltonetworks.com>

[ Upstream commit 1aec77b2bb2ed1db0f5efc61c4c1ca3813307489 ]

Each attribute inside a nested IFLA_VF_VLAN_LIST is assumed to be a
struct ifla_vf_vlan_info so the size of such attribute needs to be at least
of sizeof(struct ifla_vf_vlan_info) which is 14 bytes.
The current size validation in do_setvfinfo is against NLA_HDRLEN (4 bytes)
which is less than sizeof(struct ifla_vf_vlan_info) so this validation
is not enough and a too small attribute might be cast to a
struct ifla_vf_vlan_info, this might result in an out of bands
read access when accessing the saved (casted) entry in ivvl.

Fixes: 79aab093a0b5 ("net: Update API for VF vlan protocol 802.1ad support")
Signed-off-by: Roded Zats <rzats@paloaltonetworks.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20240502155751.75705-1-rzats@paloaltonetworks.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8938320f7ba3b..2806b9ed63879 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2379,7 +2379,7 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		nla_for_each_nested(attr, tb[IFLA_VF_VLAN_LIST], rem) {
 			if (nla_type(attr) != IFLA_VF_VLAN_INFO ||
-			    nla_len(attr) < NLA_HDRLEN) {
+			    nla_len(attr) < sizeof(struct ifla_vf_vlan_info)) {
 				return -EINVAL;
 			}
 			if (len >= MAX_VLAN_LIST_LEN)
-- 
2.43.0



