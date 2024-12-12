Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B3F215777;
	Thu, 12 Dec 2024 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017568; cv=none; b=qiM6OqgQpMT/9mM5xIcuLRN/VxSDq2htGL3vyS7VUKAIbm7gzwxuDDzXyxYZDgnFGTqc/DS+aLMmpUWfXrIXSA2YMDS8R+shpY09qLsxH3dAWrk8Kz824Xbc34ozeCswUbt90TvDc1Z2t5q57IRpbTwbhLRAJ08mx/mG0o+V5Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017568; c=relaxed/simple;
	bh=sc6qf7ZEQbsq28djOxfPaLGFAm/X9ihi06ubROuL3W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHlLTEtqrnuYAq6fMdmNror6CArqe1vBhjRxxp+5/ljyFG4/zJEUymt9DPkXHu2IN6yl3whjofBuzirPTvU2jN9YTBfZxeMQY2XXrlwwxYMnSrBGHMcD4tQ1WLZZH0O499dDQwSCf+Js/DueGlsk2xerGimjWKKSibCA5lbaYAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln9rNTNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln9rNTNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3088C4CEDD;
	Thu, 12 Dec 2024 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017568;
	bh=sc6qf7ZEQbsq28djOxfPaLGFAm/X9ihi06ubROuL3W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln9rNTNV3FbSMXW3rBjE1xYDqeJw5FqXqoHqSjEtf6PCzNUTxFGgvLHJepi5nxnmF
	 WVnMNTBucAtyhMTkAQOfpvwEmKDYUKRLqH82i7tZAKX4GWVl5BAlYpWZO33OycUMK5
	 +TDBwD0DrMzKQrGAkAVWVr0oWAP42ETkTNZV/mC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/356] net: sched: fix erspan_opt settings in cls_flower
Date: Thu, 12 Dec 2024 15:56:09 +0100
Message-ID: <20241212144246.609752615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 292207809486d99c78068d3f459cbbbffde88415 ]

When matching erspan_opt in cls_flower, only the (version, dir, hwid)
fields are relevant. However, in fl_set_erspan_opt() it initializes
all bits of erspan_opt and its mask to 1. This inadvertently requires
packets to match not only the (version, dir, hwid) fields but also the
other fields that are unexpectedly set to 1.

This patch resolves the issue by ensuring that only the (version, dir,
hwid) fields are configured in fl_set_erspan_opt(), leaving the other
fields to 0 in erspan_opt.

Fixes: 79b1011cb33d ("net: sched: allow flower to match erspan options")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 6ee7064c82fcc..bcf1b8012b2c3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1320,7 +1320,6 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	int err;
 
 	md = (struct erspan_metadata *)&key->enc_opts.data[key->enc_opts.len];
-	memset(md, 0xff, sizeof(*md));
 	md->version = 1;
 
 	if (!depth)
@@ -1349,9 +1348,9 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option index");
 			return -EINVAL;
 		}
+		memset(&md->u.index, 0xff, sizeof(md->u.index));
 		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX]) {
 			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX];
-			memset(&md->u, 0x00, sizeof(md->u));
 			md->u.index = nla_get_be32(nla);
 		}
 	} else if (md->version == 2) {
@@ -1360,10 +1359,12 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 			NL_SET_ERR_MSG(extack, "Missing tunnel key erspan option dir or hwid");
 			return -EINVAL;
 		}
+		md->u.md2.dir = 1;
 		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR]) {
 			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR];
 			md->u.md2.dir = nla_get_u8(nla);
 		}
+		set_hwid(&md->u.md2, 0xff);
 		if (tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID]) {
 			nla = tb[TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID];
 			set_hwid(&md->u.md2, nla_get_u8(nla));
-- 
2.43.0



