Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457E32548B;
	Tue, 17 Mar 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768233; cv=none; b=C8uzNJ5P/rI5kBuzzddN5eVtUUJFTcd2hsTeaRlgyMwgeN7BzVVrcS1DP+yH5MTX6kCk9wOA+/nZLPvCVcfFjKB8uPVseB8Gg3CRWv4GuFbnlUaZOedFH/pSZ54iK5MQpoK55OWp3hPeFdSUp/wBb6z31SEOHmiAdXETcPoe/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768233; c=relaxed/simple;
	bh=KKxUMH3CQwaF4Rtlzk2adU98pkqmFpC1nEFWw4u8Ja8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euofY4yHUCkzIgXei4otw1G1Xj6mQybzlwDKqiWBflo5BfC2h+F9cR30jZ9I3GKOHFIDUfOyYKoYCMn9gJ6idBwp5oqLGi2VBxPGsJee5ZDcDMRQMduOXahCctXVeff9olrRJGp8ASYxlRq9wvKZnFtvvnB+cxLL5sGOES8Ziqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPBUwk5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPBUwk5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B623C2BCAF;
	Tue, 17 Mar 2026 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768233;
	bh=KKxUMH3CQwaF4Rtlzk2adU98pkqmFpC1nEFWw4u8Ja8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPBUwk5B621h1XOvhhE7B1JgtZwnS/PjOFcjILMhque/zFwfs3GsrCKLq2BseJ52E
	 ItdkZC+EYtmM6+N3UBVLVW9RmR2eMlexQvuvtgWJJCCJ7iU4fjY0PkqDWI7Z4YVzxr
	 Fmk3uqjOZaDyOvmWxXb54fgwmRaubszCzzbDDvDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 263/333] net-shapers: dont free reply skb after genlmsg_reply()
Date: Tue, 17 Mar 2026 17:34:52 +0100
Message-ID: <20260317163009.124199268@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

commit 57885276cc16a2e2b76282c808a4e84cbecb3aae upstream.

genlmsg_reply() hands the reply skb to netlink, and
netlink_unicast() consumes it on all return paths, whether the
skb is queued successfully or freed on an error path.

net_shaper_nl_get_doit() and net_shaper_nl_cap_get_doit()
currently jump to free_msg after genlmsg_reply() fails and call
nlmsg_free(msg), which can hit the same skb twice.

Return the genlmsg_reply() error directly and keep free_msg
only for pre-reply failures.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Fixes: 553ea9f1efd6 ("net: shaper: implement introspection support")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Moses <p@1g4.org>
Link: https://patch.msgid.link/20260309173450.538026-2-p@1g4.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/shaper/shaper.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -759,11 +759,7 @@ int net_shaper_nl_get_doit(struct sk_buf
 	if (ret)
 		goto free_msg;
 
-	ret = genlmsg_reply(msg, info);
-	if (ret)
-		goto free_msg;
-
-	return 0;
+	return genlmsg_reply(msg, info);
 
 free_msg:
 	nlmsg_free(msg);
@@ -1314,10 +1310,7 @@ int net_shaper_nl_cap_get_doit(struct sk
 	if (ret)
 		goto free_msg;
 
-	ret =  genlmsg_reply(msg, info);
-	if (ret)
-		goto free_msg;
-	return 0;
+	return genlmsg_reply(msg, info);
 
 free_msg:
 	nlmsg_free(msg);


