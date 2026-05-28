Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5C2E7379;
	Thu, 28 May 2026 20:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999988; cv=none; b=NNepGgVVzTA/8dpp7av5NLICwJAxDlFQTxoREqqjm7TAvbFRuvXtQkGQiCHcf3UPS9U+sRwv1i5C51cmWIEE3DeL0H2gy+SJp2O59RKMMLvgF//oPerRAP3nCUCzyNoF1YiwsdYQuv4k0gvPrC7U8Yw7PlxqUD683V9C2czvQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999988; c=relaxed/simple;
	bh=N6kki3N0OrmkmWBvoSKkPkyMy+oJM7brlkM8uo2meDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie+oBhtPzotVqhfItL9rRbRCx7K93kw3DxJHW9WS7zT3Jv1SFzZhG0OumWO7ilcvcgaHHDNUC3MOgQgYXWgCFCX+CKA79wyI2H31IfOgWBgS8G2qOp0prpMcm2O8eeVqSBH76Ho9FwrafZ367DIRnb97OlHwARIahTE4zEDghPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZdpQxZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZdpQxZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC5D1F000E9;
	Thu, 28 May 2026 20:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999987;
	bh=cmKy8iJMptucssGxpFNd58fGGR+sdgSigUXMSEPfZTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZdpQxZJp+1bXA4d2h4lWNyxqTIZ7JJr0G9yhBbagg1ac0kvHEvsokQhWXWmdOVt2
	 mi9iOlFwEcyNtATfhJ3QiPNDkA8lr5d3h7ordJysAHXHsZX1DGc70sSeAxn6Dpn399
	 BY0n/5nVu2jQYpdoxkaZkSqhvfbwQZDde/BYdWdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/377] net: shaper: fix undersized reply skb allocation in GROUP command
Date: Thu, 28 May 2026 21:48:19 +0200
Message-ID: <20260528194645.927861171@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0f9a857e34d0f8c018a3e4435c6f0e92e8d2f38c ]

net_shaper_group_send_reply() writes both the NET_SHAPER_A_IFINDEX
attribute (via net_shaper_fill_binding()) and the nested
NET_SHAPER_A_HANDLE attribute (via net_shaper_fill_handle()), but
the reply skb at the call site in net_shaper_nl_group_doit() is
allocated using net_shaper_handle_size(), which only accounts for
the nested handle.

The allocation is therefore short by nla_total_size(sizeof(u32))
(8 bytes) for the IFINDEX attribute.  In practice the slab allocator
rounds up the small allocation so the bug is latent, but the size
accounting is wrong and could bite if the reply grew further.

Introduce net_shaper_group_reply_size() that accounts for the full
reply payload and use it both at the genlmsg_new() call site and in
the defensive WARN_ONCE message.

Fixes: 5d5d4700e75d ("net-shapers: implement NL group operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-7-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index ee0d1f0613430..5338842122a2a 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -90,6 +90,12 @@ static int net_shaper_handle_size(void)
 			      nla_total_size(sizeof(u32)));
 }
 
+static int net_shaper_group_reply_size(void)
+{
+	return nla_total_size(sizeof(u32)) +	/* NET_SHAPER_A_IFINDEX */
+	       net_shaper_handle_size();	/* NET_SHAPER_A_HANDLE */
+}
+
 static int net_shaper_fill_binding(struct sk_buff *msg,
 				   const struct net_shaper_binding *binding,
 				   u32 type)
@@ -1228,7 +1234,7 @@ static int net_shaper_group_send_reply(struct net_shaper_binding *binding,
 free_msg:
 	/* Should never happen as msg is pre-allocated with enough space. */
 	WARN_ONCE(true, "calculated message payload length (%d)",
-		  net_shaper_handle_size());
+		  net_shaper_group_reply_size());
 	nlmsg_free(msg);
 	return -EMSGSIZE;
 }
@@ -1276,7 +1282,7 @@ int net_shaper_nl_group_doit(struct sk_buff *skb, struct genl_info *info)
 	/* Prepare the msg reply in advance, to avoid device operation
 	 * rollback on allocation failure.
 	 */
-	msg = genlmsg_new(net_shaper_handle_size(), GFP_KERNEL);
+	msg = genlmsg_new(net_shaper_group_reply_size(), GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
 		goto free_leaves;
-- 
2.53.0



