Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283DF352FED;
	Tue, 26 Aug 2025 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217024; cv=none; b=WAX6QwWm07gYdaSkow7Ywd5ScMb219GMfsZUazU4MvSvcNjFOC5vYJqQuaPPLQt2/Nubws6HQRC640N/3tzVD80HWr6ioruwQob+zvu7/2Gp62KfiwFVlL982vcrO8py29qCHVUQ05OlGvgDEwOpQicZDGfVbzEWV7uD98Rxrzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217024; c=relaxed/simple;
	bh=feb/ZQa+C2fAeWyNxo2LHzMDlvtDR9e1iO+53JBuYs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OINe0e4GT1e03gzjl6b9Y3Yed8aNr0XWQe5uTm/niDBu65L+o+ydlOOAjpWmQgqcSgPBd9kWhZweCFDjjrWTAup7JH9Ll/WS6ARV8MX47bjVSLfMXCnEhbEPUpt3uncXorZtudZX82yYqzg/sXOJ1YS6gaO1EF90+imb3SqVhM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjhvewgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjhvewgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69AC4CEF1;
	Tue, 26 Aug 2025 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217024;
	bh=feb/ZQa+C2fAeWyNxo2LHzMDlvtDR9e1iO+53JBuYs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjhvewgXo+rqVYa3ZnNd0+xR4+DVOqgXfIV3+chCargp6guUhjdIRuhwb0GrY58Cv
	 hjST4R7XuB9shXY3C2XeGq865zHKYrbLQBbp3/aTCx7WWgWOYSjxNcgLuFvN71lDTw
	 xVLyfkU7c8YyA0AuAMnH5cUA72+bx9xhrm/yg0kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 630/644] ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826111002.168953103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 84967deee9d9870b15bc4c3acb50f1d401807902 ]

The seg6_genl_sethmac() directly uses the algorithm ID provided by the
userspace without verifying whether it is an HMAC algorithm supported
by the system.
If an unsupported HMAC algorithm ID is configured, packets using SRv6 HMAC
will be dropped during encapsulation or decapsulation.

Fixes: 4f4853dc1c9c ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250815063845.85426-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 58203c41d652..7e3a85769932 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -294,6 +294,9 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
+	if (!__hmac_get_algo(hinfo->alg_id))
+		return -EINVAL;
+
 	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
 
-- 
2.50.1



