Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA752D6401;
	Mon, 27 Oct 2025 19:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592111; cv=none; b=Y45fwulmnSfqVp6si18gqGh3jLnv4PdvFIZa6FbP2xfZo1lAOJ1vgWIDIp6/VYLwn8Db90XXJ9cDeKDpMDkLXEJVXy+Pl+iOzDZZtPTptOCUDag/k1ZlS6tpvJazylNcTpT7HeKlQwtUk5axJYu1l3YaupMwIa2p/BQl7kZJoFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592111; c=relaxed/simple;
	bh=wVqbhwT+9/Fg3bONzJsjI05Iiewm3dHO3ICJGrMO85o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urzl8eq3L+dnn/f5+wCmwab7UUoCKn6YQRDP7txY+lIrafiVKi15e9vb3OpKTU+tVJs9rTFq/cbVhjnyOX5GI4T8rzn3+uziq8Cf1upC79ifI2bnIgc2KGyeGif93yWIsyZAmEBKxaJ+zfpOQf9oD3DdKPcqu/WXVldVmsj/teE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rL2/kbbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rL2/kbbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66FAC4CEF1;
	Mon, 27 Oct 2025 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592111;
	bh=wVqbhwT+9/Fg3bONzJsjI05Iiewm3dHO3ICJGrMO85o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rL2/kbboL8Rd4Ckz47hRi/vNt39w9ds9p/iyyqsxLjhaGPa1XxR9/9Q4mJSd9wsVm
	 rqkL91GnirrjvJMpMBQjQXcmjLrfiYIgvssyMrKllE7Qxz7B0RZQNQDRDANYZFasVF
	 1VfHh702hsVimUOvF7D8oxsBpOtV8SzhkbZhBlaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 121/123] net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
Date: Mon, 27 Oct 2025 19:36:41 +0100
Message-ID: <20251027183449.621017634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 5b22f62724a0a09e00d301abf5b57b0c12be8a16 upstream.

When bulk delete command is received in the rtnetlink_rcv_msg function,
if bulk delete is not supported, module_put is not called to release
the reference counting. As a result, module reference count is leaked.

Fixes: a6cec0bcd342 ("net: rtnetlink: add bulk delete support flag")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20220815024629.240367-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5664,6 +5664,7 @@ static int rtnetlink_rcv_msg(struct sk_b
 	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
 	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
 		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		module_put(owner);
 		goto err_unlock;
 	}
 


