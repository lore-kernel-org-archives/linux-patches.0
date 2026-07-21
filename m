Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAC629CE9;
	Tue, 21 Jul 2026 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658157; cv=none; b=hEXAxT1gA4YRE4PbXcVnDGjd5Tb4zncBdwtzHSHGdnZU3m6Iv4NksXIvqw5DXfWmqlpKjsLTshtHhBDRPzJ0Gau7rrqAeMf1/GtboFEeYStis8U8ZxtJlqul7BBj9LZ7PfGL1nzWaIydbuMiRVY83pW1gfvjLhc2O5FanAC4nw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658157; c=relaxed/simple;
	bh=vXfYGyZwwd5IAs2/Q68TIrmRxK+ZjXzOYGOLwxuxSG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYQd3MEBAQuDpzD6U2hg2dAe3CUIx2tC2x9NbLDwWYYPLkm4PnMeaitVFvtdR9ehKxIteGLeQRb+CSAjm4vQaVjJQnVYwUkIasCnWUAq4Ez5FPlY8ckQEYGKxutgm0vlqe8j43LSTOHok0Nzlx6BNe1wansyeHJQWSDPNprHqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QklF4SHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QklF4SHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9381F000E9;
	Tue, 21 Jul 2026 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658156;
	bh=Fgb/26TtjkfKshWi0gbHc21+Nl/euXr2e5Xkd1s5u6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QklF4SHfgz7etnAG7BFGidB8dEcJgG3Jyn4ik3Uqov8RuIhQmwXyyNlDTC/VnHaMD
	 ECxElo5cVuBmDUgaPyzqSjs7Hsj6V+8eIkuRzh1KT+KeeX/0tIC6ReD0ofEe1O5GFR
	 4tWkCErqbH1Lzglw9Ztmz73FZE2/17CFoWxTbusg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1038/1611] netfilter: xt_u32: reject invalid shift counts
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152538.750284708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

[ Upstream commit 64cdf7d30ac18e43df6c48004435febb965809a8 ]

u32_match_it() executes rule-supplied shift operands on a 32-bit
value. A malformed u32 rule can provide a shift count of 32 or more,
triggering an undefined shift out-of-bounds during packet evaluation.

Validate XT_U32_LEFTSH and XT_U32_RIGHTSH operands in
u32_mt_checkentry() and reject malformed rules before they reach the
packet path.

Fixes: 1b50b8a371e9 ("[NETFILTER]: Add u32 match")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_u32.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 1ae7f926b0df73..dabbaa742874cb 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -106,7 +106,7 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct xt_u32 *data = par->matchinfo;
 	const struct xt_u32_test *ct;
-	unsigned int i;
+	unsigned int i, j;
 
 	if (data->ntests > ARRAY_SIZE(data->tests))
 		return -EINVAL;
@@ -117,6 +117,16 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
 		if (ct->nnums > ARRAY_SIZE(ct->location) ||
 		    ct->nvalues > ARRAY_SIZE(ct->value))
 			return -EINVAL;
+
+		for (j = 1; j < ct->nnums; ++j) {
+			switch (ct->location[j].nextop) {
+			case XT_U32_LEFTSH:
+			case XT_U32_RIGHTSH:
+				if (ct->location[j].number >= 32)
+					return -EINVAL;
+				break;
+			}
+		}
 	}
 
 	return 0;
-- 
2.53.0



