Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1D8223C62;
	Thu, 12 Dec 2024 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023186; cv=none; b=iLLbylO43fkwdsMy60NZ97e/uBAUl2GGsdLinKTjIqyIdpS0KOp8yxV7j90siroLP9Q0C5xaAhDPcCLJ1okpwr80i+z6Q7UNLEGWEl/aGObTf9hGD0yH10TRnMmRWxK7IHjZQpyXshNwLd465iJecgahgLJHTOXZmAW2/YuMSEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023186; c=relaxed/simple;
	bh=dvpEoRgyzf7S2ycV33ftTIGfMUBwSvxotGe7vcvZdNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giTY/obUtMUVjQrhjNflDYXRu3wL/r6Ep8XXUPa1Da5hF50YFAPZ4wJbS+X9tFcTigWZYy6tSgXX5TDDkuRkcRXwOxbpAtId3Y8IGPEk/qIl5M32ysdxHVB8SRlaRYw/hnjDIFnsF3SFlI826tg3ky6BJ049Q4sse+XlYLFLNNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B82NnGfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B82NnGfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AB1C4CED3;
	Thu, 12 Dec 2024 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023186;
	bh=dvpEoRgyzf7S2ycV33ftTIGfMUBwSvxotGe7vcvZdNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B82NnGfG+orGT2sfCCQQOxsd9q6j5MAYjudoUh4Pqd79U2Hrzrrip/Io7qWPecufo
	 M78G/nnDspNxUf3XniYGjEWnsUn8GI/kc+zB8l4m4mhWISQOpVJyH4gBgJD3SgUAEh
	 rvQSkxtmG2t4yeOI/UadzhFZD+lJkVcnG1dmhy5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/565] net: sched: fix erspan_opt settings in cls_flower
Date: Thu, 12 Dec 2024 16:00:16 +0100
Message-ID: <20241212144328.307053753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index bff0a5f24aca8..057612c97a372 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1224,7 +1224,6 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	int err;
 
 	md = (struct erspan_metadata *)&key->enc_opts.data[key->enc_opts.len];
-	memset(md, 0xff, sizeof(*md));
 	md->version = 1;
 
 	if (!depth)
@@ -1253,9 +1252,9 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
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
@@ -1264,10 +1263,12 @@ static int fl_set_erspan_opt(const struct nlattr *nla, struct fl_flow_key *key,
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



