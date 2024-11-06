Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7ED1E104A;
	Wed,  6 Nov 2024 12:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897883; cv=none; b=LS/CgrWIfim4Y8+XFIvZMzkpGfisOJXzr9rcKIlBnPMWRUb6rWKwYVTyqaODwpt+x8lOXVwickPM/82Kl6x6W959bWLVeFK1AQpk2BTdvNx8p0vCSL/817P9K6AvkgOmr0fIcOx3VVHd3CXTGC21CVLqJCOMvhl/U6zZ01FY+L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897883; c=relaxed/simple;
	bh=AvCy+QcKjp4Wbohgp0ywQQX72FxL11r4UHjkzPm317U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+ss0fM+73v/Xa4H/b1xwgfGQCkgfjUJFIorsU01lOWY5258vpRRzV2EVp4gLq1nFeCbPWltq4ach6heLG5BM7YGCMjipdDKpcrfRhRHAjRq2eBNWvGVC78vymSJRzf6xlV4dp5Wed/FlRvB5Ug2feXsdhnnYCRI4H9/XrMocjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyYDQehl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyYDQehl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2183C4CECD;
	Wed,  6 Nov 2024 12:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897883;
	bh=AvCy+QcKjp4Wbohgp0ywQQX72FxL11r4UHjkzPm317U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyYDQehlPKenkMgMPMUJ8dze1rJ7imeConcai/OXLUsJ0zDbHFMcvtgGkZfuBXcFY
	 8bXBnZtg77Zt67sMWwhpyWs4tqGLjRys0K/kq0iPpft/UHScv5mvpQjO/Iui9/zlsf
	 edZNP3splAXfAm/Hc3v9bZ/C3ZOg/90GFCsSZlJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Justin Stitt <justinstitt@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/462] net: tipc: avoid possible garbage value
Date: Wed,  6 Nov 2024 12:59:04 +0100
Message-ID: <20241106120332.778270448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 99655a304e450baaae6b396cb942b9e47659d644 ]

Clang static checker (scan-build) warning:
net/tipc/bcast.c:305:4:
The expression is an uninitialized value. The computed value will also
be garbage [core.uninitialized.Assign]
  305 |                         (*cong_link_cnt)++;
      |                         ^~~~~~~~~~~~~~~~~~

tipc_rcast_xmit() will increase cong_link_cnt's value, but cong_link_cnt
is uninitialized. Although it won't really cause a problem, it's better
to fix it.

Fixes: dca4a17d24ee ("tipc: fix potential hanging after b/rcast changing")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Link: https://patch.msgid.link/20240912110119.2025503-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bcast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 885ecf6ea65aa..72362fb63d853 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -313,8 +313,8 @@ static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 {
 	struct tipc_msg *hdr, *_hdr;
 	struct sk_buff_head tmpq;
+	u16 cong_link_cnt = 0;
 	struct sk_buff *_skb;
-	u16 cong_link_cnt;
 	int rc = 0;
 
 	/* Is a cluster supporting with new capabilities ? */
-- 
2.43.0



