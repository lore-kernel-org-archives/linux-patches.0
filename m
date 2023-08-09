Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726EB171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8962C433C8;
	Wed,  9 Aug 2023 10:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578744;
	bh=9opQW3mhR3qd7E0c/wpJlIun4dCB8V6v/twdVEbfSpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNdwLzxmH/Sv4Z+mXzdd7U04Ic5bBWe4yXJTSnd8s9VWVKF0hsAQnNzE7ynSYCHmD
	 MRiguQHC6Nj9MzWmE32vwUqKdzgxlsGbTo1+4hJ9LPJalXnIIv/tM2lnb9IdOMxFqP
	 AH/YRuD7APFUdQQ7L2Vu5VS0CuMczjK/Q+1NlBWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/92] net: dcb: choose correct policy to parse DCB_ATTR_BCN
Date: Wed,  9 Aug 2023 12:41:17 +0200
Message-ID: <20230809103635.040163170@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 31d49ba033095f6e8158c60f69714a500922e0c3 ]

The dcbnl_bcn_setcfg uses erroneous policy to parse tb[DCB_ATTR_BCN],
which is introduced in commit 859ee3c43812 ("DCB: Add support for DCB
BCN"). Please see the comment in below code

static int dcbnl_bcn_setcfg(...)
{
  ...
  ret = nla_parse_nested_deprecated(..., dcbnl_pfc_up_nest, .. )
  // !!! dcbnl_pfc_up_nest for attributes
  //  DCB_PFC_UP_ATTR_0 to DCB_PFC_UP_ATTR_ALL in enum dcbnl_pfc_up_attrs
  ...
  for (i = DCB_BCN_ATTR_RP_0; i <= DCB_BCN_ATTR_RP_7; i++) {
  // !!! DCB_BCN_ATTR_RP_0 to DCB_BCN_ATTR_RP_7 in enum dcbnl_bcn_attrs
    ...
    value_byte = nla_get_u8(data[i]);
    ...
  }
  ...
  for (i = DCB_BCN_ATTR_BCNA_0; i <= DCB_BCN_ATTR_RI; i++) {
  // !!! DCB_BCN_ATTR_BCNA_0 to DCB_BCN_ATTR_RI in enum dcbnl_bcn_attrs
  ...
    value_int = nla_get_u32(data[i]);
  ...
  }
  ...
}

That is, the nla_parse_nested_deprecated uses dcbnl_pfc_up_nest
attributes to parse nlattr defined in dcbnl_pfc_up_attrs. But the
following access code fetch each nlattr as dcbnl_bcn_attrs attributes.
By looking up the associated nla_policy for dcbnl_bcn_attrs. We can find
the beginning part of these two policies are "same".

static const struct nla_policy dcbnl_pfc_up_nest[...] = {
        [DCB_PFC_UP_ATTR_0]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_1]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_2]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_3]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_4]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_5]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_6]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_7]   = {.type = NLA_U8},
        [DCB_PFC_UP_ATTR_ALL] = {.type = NLA_FLAG},
};

static const struct nla_policy dcbnl_bcn_nest[...] = {
        [DCB_BCN_ATTR_RP_0]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_1]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_2]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_3]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_4]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_5]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_6]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_7]         = {.type = NLA_U8},
        [DCB_BCN_ATTR_RP_ALL]       = {.type = NLA_FLAG},
        // from here is somewhat different
        [DCB_BCN_ATTR_BCNA_0]       = {.type = NLA_U32},
        ...
        [DCB_BCN_ATTR_ALL]          = {.type = NLA_FLAG},
};

Therefore, the current code is buggy and this
nla_parse_nested_deprecated could overflow the dcbnl_pfc_up_nest and use
the adjacent nla_policy to parse attributes from DCB_BCN_ATTR_BCNA_0.

Hence use the correct policy dcbnl_bcn_nest to parse the nested
tb[DCB_ATTR_BCN] TLV.

Fixes: 859ee3c43812 ("DCB: Add support for DCB BCN")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230801013248.87240-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dcb/dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index dc4fb699b56c3..d2981e89d3638 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -946,7 +946,7 @@ static int dcbnl_bcn_setcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 
 	ret = nla_parse_nested_deprecated(data, DCB_BCN_ATTR_MAX,
-					  tb[DCB_ATTR_BCN], dcbnl_pfc_up_nest,
+					  tb[DCB_ATTR_BCN], dcbnl_bcn_nest,
 					  NULL);
 	if (ret)
 		return ret;
-- 
2.40.1



