Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C6444AB6A;
	Tue, 21 Jul 2026 22:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674050; cv=none; b=trZU7w73rY0wWRqrhrAsDe6t8lKnse/MvY/KiQpSFjTngh0kSCD/dRJSrb7aMuQ3aq/I3V6ikfLLA1W8JHhFKbplwj+OiriA15LugayBfTV1EY97LI6jpKuEQJ5MNT+EJVPU/IQ4AW0uWX7bwtxoWTfhmQT7q288bVV7zkBsPew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674050; c=relaxed/simple;
	bh=UK1r1d3bfFFWf4iys7ZxD/uZfFi2UVypowJMIo3Gg0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/Ond5CVlTaiO+PNGSl4MEYJKAlLQo2VzYmKtAOajv3kZLvXAZv44yWkg3odtyBCpy2Kx18ZWH3Gl8DGNhElbHudUrO0UR+vZBIf3mz89mN949kI4/7o7YHWFWr6ALNHD/J/0JktC+R8spspvzU/WN3O/Jh/8OEtFnioXMdVr7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKMuy484; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKMuy484"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1531F000E9;
	Tue, 21 Jul 2026 22:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674048;
	bh=XQ7k/gbUZanRnbC2Ybnvd1JsQD+r10j6EUOt5JmcCjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKMuy484k98E8aqih1T28r8ZyXGW0RWaJmkCNUT5j1wa0NDhkrwJAwN3pyV/rDKty
	 ja6pJr478s6p9ZtlXMxkj26lqvLXofj8q48h+V97tcQaq6pFIm07lKc3ZNzzoeYS4q
	 oNzKeFuKBcyiN/zGyY4AI956X+DVPs6OwdOjO7sg=
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
Subject: [PATCH 5.10 393/699] netfilter: xt_u32: reject invalid shift counts
Date: Tue, 21 Jul 2026 17:22:32 +0200
Message-ID: <20260721152404.559788087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 117d4615d6684c..ec1a21e3b6e2c3 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -100,7 +100,7 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct xt_u32 *data = par->matchinfo;
 	const struct xt_u32_test *ct;
-	unsigned int i;
+	unsigned int i, j;
 
 	if (data->ntests > ARRAY_SIZE(data->tests))
 		return -EINVAL;
@@ -111,6 +111,16 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
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



