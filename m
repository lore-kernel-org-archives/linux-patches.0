Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCD4425CD6;
	Tue, 31 Mar 2026 16:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974941; cv=none; b=U3ovXYOL7pNubJD4rNEhzj8NQaL+ZQKP/ZQqOUvkQn2Akz+P8S5xFR/PgvbjwctWb/Q8O0U+Ft90CdO6bY8423+8XtIq01/hA4OaIO7q0GkH+yQ6Wjg23Ahz42LRd/IWkN/LCgemVudRV6Abg4Q4d/cXzFEQjmRSif1fuS6sKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974941; c=relaxed/simple;
	bh=TgAEEXj4Gq6wLolb1dQHzQTqK2cMYCY3pAcZO3ER2CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C19x7fXtZXTJVdSEcNH6oSQ/DhQyk27ZNS/JxXBaNPzPh5/8L7PHB+56XRm2c+Yf/xQTxrk2qs+yKStfKizv7OZtAlNoemV3A2OtOAEjXdRvp+guJjDfNXwekoSyQJpQhpdJJ5ZwoQvcAdy6XdzhHWD7XrSK5j71Y4E7JCzgiIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfQ3tGZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfQ3tGZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9F3C2BCB1;
	Tue, 31 Mar 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974941;
	bh=TgAEEXj4Gq6wLolb1dQHzQTqK2cMYCY3pAcZO3ER2CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfQ3tGZNp/b0/SLJHwi0ZFogW+Fhv5uM+sZBneT7xmQAXrBAu35ndKchldyiaL63r
	 VAZd4hCV0UkgPQnr9Iwy+V6EsPNCLB+eU5FgQ+J9HARTCZQ8OmH3ST6EdoIQ6epSEd
	 DdxHcd+GgJOBpjlOp3PaWUYPa7vQGxalnmAxV/CU=
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
Subject: [PATCH 6.19 104/342] openvswitch: validate MPLS set/set_masked payload length
Date: Tue, 31 Mar 2026 18:18:57 +0200
Message-ID: <20260331161802.839828479@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2d536901309ea..2dc4a6c2aecec 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2953,6 +2953,8 @@ static int validate_set(const struct nlattr *a,
 	case OVS_KEY_ATTR_MPLS:
 		if (!eth_p_mpls(eth_type))
 			return -EINVAL;
+		if (key_len != sizeof(struct ovs_key_mpls))
+			return -EINVAL;
 		break;
 
 	case OVS_KEY_ATTR_SCTP:
-- 
2.51.0



