Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42831E98EF;
	Sun,  7 Jun 2026 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827231; cv=none; b=cJBpu8au6MN8R39ip8DROENg/SOhLc0Kzhw2e9UbTdOotgLA7cHXfwfDkhwgocdK1cjNcmj+uWYFS2LZGfHmdsBivS5XmC7dq26W1HL2hS/8oLMjJGI915r9EiWJXpn8jKZXc/g0t/f7yFvIGet9TAMBb7IRBZ623W3JBGbGWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827231; c=relaxed/simple;
	bh=cFz2rfirBGVi/6ODMIa9v8AFT9U4FsqJbm4YQYcj/JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USCJb8eqoTQvIYEqY1mu3LHEOwq23YF49/isIDwCV3A/zFNSQI+5a74GWG+qPJYV6DfKiaPg5xxlJbIWuj+H/9qY8RgSMxk+lbTtIC0U8F1wUAqe1XkvWH6Nxcavt82g5jELkQ+pYrx14rJHoRZHf+Vs37abC6BK146MX++bujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETZSUpSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETZSUpSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08671F00893;
	Sun,  7 Jun 2026 10:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827230;
	bh=qhzMcvFQoHFUsKc1HikrTMknfJuGrl3w6CZdTKb/lv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETZSUpSyS9Fea2N+zUD42cdNw+J90rJXyzMLb9rVrG9FqnbbklVQ5IaDCLOx/DQAw
	 R/hKiHXQhMjtL/6LafoZ5qWbave/qXiGq6e6PDdRpwt970v+ZCVI54iJIleSVdyN+P
	 DX8nvP9HSshkucDKXcmhnx5UBZ/3pT4vReVe5r1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 074/332] ethtool: tsinfo: dont pass ERR_PTR to genlmsg_cancel on prepare failure
Date: Sun,  7 Jun 2026 11:57:23 +0200
Message-ID: <20260607095730.857406776@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c3fc9976f686f9a95baf87db9d387f218fd65394 ]

The goto err label leads to:

	genlmsg_cancel(skb, ehdr);
	return ret;

If ethnl_tsinfo_prepare_dump() failed, it has not started a genlmsg.
There's nothing to cancel, and passing an error pointer to
genlmsg_cancel() would cause a crash.

Fixes: b9e3f7dc9ed9 ("net: ethtool: tsinfo: Enhance tsinfo to support several hwtstamp by net topology")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsinfo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index cb1491e0a28bac..64e6016a7a1772 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -405,10 +405,8 @@ static int ethnl_tsinfo_dump_one_netdev(struct sk_buff *skb,
 			continue;
 
 		ehdr = ethnl_tsinfo_prepare_dump(skb, dev, reply_data, cb);
-		if (IS_ERR(ehdr)) {
-			ret = PTR_ERR(ehdr);
-			goto err;
-		}
+		if (IS_ERR(ehdr))
+			return PTR_ERR(ehdr);
 
 		reply_data->ts_info.phc_qualifier = ctx->pos_phcqualifier;
 		ret = ops->get_ts_info(dev, &reply_data->ts_info);
-- 
2.53.0



