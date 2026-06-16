Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDDC332EC1;
	Tue, 16 Jun 2026 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631467; cv=none; b=cVt1Ad4ONDMkdXryzEenkK3GCOtX5fGpdrU06zeNKAMWDaDXz0Ifl2k1DjBfmI/jaP5TlpnNhnfNCgl8F6qex8JJeELQImdL6u3tqMsSCAutigzLpjiR3/vvVlDATve7+Se9etwDzxLPEPkefHV+oCsfwNv+7Dq2o4NBa1YrsVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631467; c=relaxed/simple;
	bh=RxmJAIOWsvBmDI1HNrDEdBLR0bIsx1hDC5i1kAfUXSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcCy6Ezc0b0ar9aowKhIDA0mVK0gpmnHu4eE1+1UqwxDZPCOB3C+SCjqIvjoq32eYK6jej8Wo5jhENLqgG3xUUs3foLNor7wO8PtXWpt+Mb6YgB5vs2FMZri/kQcpbHVWWWBFOBgsRUFkTQ+IYfR/yi9LU1nIx8G8vX2kWozRL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghO4Na9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghO4Na9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757C11F000E9;
	Tue, 16 Jun 2026 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631466;
	bh=1C4cOaqo+xHCg9MEh9T0Iog9uFlcOFih/TymDIIBJb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghO4Na9R3v6dK1PQs/Og3aWj6jk2JGzY7lR6RTW+gjMSBpFORgEwFQx0FMHJj6DQp
	 v5akUkTrsZmlQ06mfe/RGpxVpX9tKW2FoNkFRS4YwDRqAyR4SI9mT5HodrNO6qUCo9
	 cbHTX+dhfx05KMowRzGPs+QmBIg2AYOnW1oELJLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/522] net: garp: fix unsigned integer underflow in garp_pdu_parse_attr
Date: Tue, 16 Jun 2026 20:25:56 +0530
Message-ID: <20260616145135.836795232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 16e408e607a94b646fb14a2a98422c6877ae4b3c ]

The receive-side GARP attribute parser computes dlen with reversed
operands:

        dlen = sizeof(*ga) - ga->len;

ga->len is the on-wire attribute length and includes the GARP attribute
header. For normal attributes with data, ga->len is larger than
sizeof(*ga), so the subtraction underflows in unsigned arithmetic.

The resulting value is later passed to garp_attr_lookup(), whose length
argument is u8. After truncation, the parsed data length usually no
longer matches the length stored for locally registered attributes, so
received Join/Leave events are ignored. This breaks the GARP receive path
for common attributes, such as GVRP VLAN registration attributes.

Compute the data length as the attribute length minus the header length.

Fixes: eca9ebac651f ("net: Add GARP applicant-only participant")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260527083200.42861-1-zhaoyz24@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/802/garp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/802/garp.c b/net/802/garp.c
index fc9eb02a912f81..f8037227e6dd66 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -452,7 +452,7 @@ static int garp_pdu_parse_attr(struct garp_applicant *app, struct sk_buff *skb,
 	if (!pskb_may_pull(skb, ga->len))
 		return -1;
 	skb_pull(skb, ga->len);
-	dlen = sizeof(*ga) - ga->len;
+	dlen = ga->len - sizeof(*ga);
 
 	if (attrtype > app->app->maxattr)
 		return 0;
-- 
2.53.0



