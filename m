Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CCD2B9B3;
	Tue, 14 May 2024 11:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687167; cv=none; b=dHwHZ8kg37KezmNVknTKnRvp3gC4DV/K6QKdlaoKaxvRd+49gDL7NN7CoI7kfUNj1DGh+aglyFY4IZCIbxmLoW3BR2Cu0xM5FPy3+yD9ocogE1bh/Ie0IB+Npt2wGg6RuXt9a5/tvqbV1Gkgheg6qANgc/8m7AmxDIVYl/aSgGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687167; c=relaxed/simple;
	bh=T2NXiTBL1C6i8nPlCknmv/5sF0F4KLfxmnQWwfYsyHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2avAzfln09gq6b0SsiESFzyt9Cr+hPNbjIUaczbM6GVixJSLVBYxXpc15MOQpbVumtSkj5qyxwuK+mjeFGlwwIaqLinnP/4K4j9hbAGS0yJbo0Duaur19YBvoBXCDNRE0Q8KA7n58Z5+vTZBpo0+9lwDpbsPXR8d2wCbWC+OKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofXjuqZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofXjuqZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7149FC2BD10;
	Tue, 14 May 2024 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687166;
	bh=T2NXiTBL1C6i8nPlCknmv/5sF0F4KLfxmnQWwfYsyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofXjuqZTirmUOTu/ETkHgnmaM59sT8jU0cxf26jWh/ZnfZVo/oeV6Ym2kn2oSTrIq
	 YIITIz5bLTyuPfAmOdI7RII/6Vg80+pIjWGVjKnwLOOsS/Hmh5ZeAEnFdc37g4V0m3
	 u4XaqD/wAnpWdB7thmB8BEaK+3xWiG7Xhk82lLJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roded Zats <rzats@paloaltonetworks.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/84] rtnetlink: Correct nested IFLA_VF_VLAN_LIST attribute validation
Date: Tue, 14 May 2024 12:20:18 +0200
Message-ID: <20240514100954.205407846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ee599636f817f..2b7ad5cf8fbfd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2252,7 +2252,7 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		nla_for_each_nested(attr, tb[IFLA_VF_VLAN_LIST], rem) {
 			if (nla_type(attr) != IFLA_VF_VLAN_INFO ||
-			    nla_len(attr) < NLA_HDRLEN) {
+			    nla_len(attr) < sizeof(struct ifla_vf_vlan_info)) {
 				return -EINVAL;
 			}
 			if (len >= MAX_VLAN_LIST_LEN)
-- 
2.43.0



