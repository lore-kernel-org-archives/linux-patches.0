Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB7131B823;
	Mon, 27 Oct 2025 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590923; cv=none; b=YGC2a7J5KoKnBBEc2HOJ6JNu8lXytpFR9CDbx17GySrbOx8GHa7N24WcR1IJYVC1L1TaIXZW3kVlpcmCZaHPI6c6HZHSJR+7X3ihIf2Ye7/d+Rh9mR8023WMprEPXpwyzB22NMgLfKL7yUHR31UvrqB8L7WV8OzOaX20AdmkXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590923; c=relaxed/simple;
	bh=HP7ldfafJ1WdHn3lmXYBr15DlninjqnKnJaE09l+/O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge5MeqnPFwDqaGf0u5jDfCAAbdbgx8yJKWvqkGL2uC0sqw/8715HQ5ok3SeAH4MWcW4mdeqdNQZF78lIBUvwr3z5rH1iJA3OOdZVzfLUSgvBhZIWlbAQKXFLMe5E7ax+6TQOtDd9pBYj8mfIZX5WSlaLt5nZ0y+Zk9IahvBwhOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFGsn7pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFGsn7pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C4DC4CEF1;
	Mon, 27 Oct 2025 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590922;
	bh=HP7ldfafJ1WdHn3lmXYBr15DlninjqnKnJaE09l+/O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFGsn7pbV7gVA84hIeiBCkN2fKXrgEAL5Tzgqw1Q6aVYMcpQ0j2efyq9my+jgzF2Y
	 ViHbsGbzV3/nKFtSqp6x2lGqM3KOOhIiWAT3B8TplUEkiH3NAnrgx22fMnyMzIdLnx
	 sZ6doQsJc7GNv1dxuigucFiBZmfZ4jtJ+LvDkv7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 224/224] net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
Date: Mon, 27 Oct 2025 19:36:10 +0100
Message-ID: <20251027183514.716722542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5304,6 +5304,7 @@ static int rtnetlink_rcv_msg(struct sk_b
 	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
 	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
 		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		module_put(owner);
 		goto err_unlock;
 	}
 


