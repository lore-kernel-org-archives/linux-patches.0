Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B9FF9D4;
	Tue, 14 May 2024 11:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687821; cv=none; b=EBTJhp3kaMN3lV4VM2haMHLhbWTmd+kpf93A9iQiSGmot/3R8ZK0jTmLEW126LWZ4+DjtCCL3SUvHELi2jK+jvr5TF5x2EHAg7gniXpDH9IJKOjDgSi9jE8THdez1Oy6ODWMmV/EmRX9Mj2QSDn8LAqL41i6EdQvFKG0PoDR7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687821; c=relaxed/simple;
	bh=LByu32i5djXSxq3UDqVziMG5JELnb4PBHd2oBZ+BBSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEeRVfou7KmRAPIBGAKTQtmlcOowe8p+1cb8VsdZCkZUHBratueccJWFbdaj+aKEG+dzQ9N2I70EfjLGsCnCRr4ypLAnPSj/ct6+jNLJSIhO+otyEoUo2iTxqPEjtTbBfgr0hJvWepUqmP6zuYwwmIGjcLI2zIf6GjzaFKSbZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGvclV0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGvclV0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E67C2BD10;
	Tue, 14 May 2024 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687821;
	bh=LByu32i5djXSxq3UDqVziMG5JELnb4PBHd2oBZ+BBSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGvclV0AJbiPyzAAHPvJLH9rgzi9SX3mZ3OPObT/cM9TE90WKJJRCHAWqxmPSPoxx
	 rpJf4CtfQqnLGthP5lGzWUis5/qoE6b6wbBQMUCH8kAlgv81HZIgcHU0DHoofeq8n2
	 C4ZktjVA/QQJfpns93UkirxyHrYsOO+opqOLP/Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roded Zats <rzats@paloaltonetworks.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/168] rtnetlink: Correct nested IFLA_VF_VLAN_LIST attribute validation
Date: Tue, 14 May 2024 12:20:07 +0200
Message-ID: <20240514101010.799961013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef218e290dfba..d25632fbfa892 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2383,7 +2383,7 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		nla_for_each_nested(attr, tb[IFLA_VF_VLAN_LIST], rem) {
 			if (nla_type(attr) != IFLA_VF_VLAN_INFO ||
-			    nla_len(attr) < NLA_HDRLEN) {
+			    nla_len(attr) < sizeof(struct ifla_vf_vlan_info)) {
 				return -EINVAL;
 			}
 			if (len >= MAX_VLAN_LIST_LEN)
-- 
2.43.0



