Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BC227BF6C;
	Mon, 13 Apr 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097924; cv=none; b=XPRHW7Bx9M9ADqK0kS1WCcYvec9qiu3VUCuhSS6RACC+FPtv15ZBugz5QnVI0YNGjKkIhmti1Os5dx9nymgokGkc3DxVUUGgXzA5DymUFtdrCuk0fKd5/hpC9v3fZMscNZJ+XrVInhyRswAtyZNE7LNYqXwlmiXY4sHDSK3gonE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097924; c=relaxed/simple;
	bh=EDqms9xHizVYciZp7AUkFZXV3N8hXF9hjpwSzgt+NPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjkCRHl7m7F+i3WJH9OD9Zj1Tad5c6LaMeBk8/kXY+lXAtygfoHmKvMy/YoBVbMaOF36SzkTVN6k7thDkYrb6VSl3YFdwbarBzMcC7OEdzThFBc0RM0NyJ+0svufrPhOZm3ojvysg5g6ZOA0ecLfKHbZ5UMSDMAc7JcVNJOebD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMPD65aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMPD65aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4152BC2BCAF;
	Mon, 13 Apr 2026 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097924;
	bh=EDqms9xHizVYciZp7AUkFZXV3N8hXF9hjpwSzgt+NPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMPD65aIHXr/cGuXTOXlzL3iy9QCrdsKTNJinoBHJwTBQW1ruIVyR2piaFT71Zex3
	 2+iHy2xSswwQRaw8JoqEgswhMpizuLvV6uFpZxEgIAIXc/NgjsrliJZw4Ziog0DoO/
	 9zXhvGFiObIOgLPT8DRuOkclw2SNJDep3y0pmsT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/570] openvswitch: validate MPLS set/set_masked payload length
Date: Mon, 13 Apr 2026 17:57:36 +0200
Message-ID: <20260413155842.671008762@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <n05ec@lzu.edu.cn>

[ Upstream commit 546b68ac893595877ffbd7751e5c55fd1c43ede6 ]

validate_set() accepted OVS_KEY_ATTR_MPLS as variable-sized payload for
SET/SET_MASKED actions. In action handling, OVS expects fixed-size
MPLS key data (struct ovs_key_mpls).

Use the already normalized key_len (masked case included) and reject
non-matching MPLS action key sizes.

Reject invalid MPLS action payload lengths early.

Fixes: fbdcdd78da7c ("Change in Openvswitch to support MPLS label depth of 3 in ingress direction")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260319080228.3423307-1-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index a7a9e4df3f600..1b2941e9c6d14 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2908,6 +2908,8 @@ static int validate_set(const struct nlattr *a,
 	case OVS_KEY_ATTR_MPLS:
 		if (!eth_p_mpls(eth_type))
 			return -EINVAL;
+		if (key_len != sizeof(struct ovs_key_mpls))
+			return -EINVAL;
 		break;
 
 	case OVS_KEY_ATTR_SCTP:
-- 
2.51.0



