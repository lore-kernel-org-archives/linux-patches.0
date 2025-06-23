Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340EB224B01;
	Mon, 23 Jun 2025 22:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716586; cv=none; b=TBrftf4vd1kiYsJqk/eLpJoQz1NChmpqXOZoFCPRiyJGQko4TBEasyxQnivW2ow3V6u/G7qMvfNsVWCOsdmyQQ4/cFh8FM6DGsN13wJLih83aC6nr0u8u3EQNEBvWX+yalyv5N3OBJzdpF3jwiNaqA7eF5gUoXr3V6AIsYAfm8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716586; c=relaxed/simple;
	bh=XosXS+vjKFULEFDG99zYZ/1/kEhBzRgv9Rj+LERrmoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn8VM2EoEWK0649XrYaRybK1XHSlObXFw34lZr9IgSdvyfSkP8rCWt3JilN/66Gt37JmhmMKc3RyjbD4YepeHY8DQ8i2WdoLBkYGPKN+VJi6a2tEEHNkqDrSglAPI9KSJntrZudP3AfNWjXQN6ZCSPIguc/B3MgcoEskLR5Av7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWwyae4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWwyae4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD99C4CEEA;
	Mon, 23 Jun 2025 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716586;
	bh=XosXS+vjKFULEFDG99zYZ/1/kEhBzRgv9Rj+LERrmoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWwyae4OxTtEazqIZCnhl5l1LhxRAAO7gEszPDFxJ8Dp4lrwrATVyW+jHeMwKtfJ3
	 tJZyTdD8O8tnUR7dqXzzxRE4zSC8W9IALY2QXO7Ngqz8VD4gS3jYSgPZHbQ2I0nknq
	 IqSMpi1lEK3/SVqKrbe2YShi4P4c+HAf/7bty7dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/414] sock: Correct error checking condition for (assign|release)_proto_idx()
Date: Mon, 23 Jun 2025 15:06:44 +0200
Message-ID: <20250623130648.706435353@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit faeefc173be40512341b102cf1568aa0b6571acd ]

(assign|release)_proto_idx() wrongly check find_first_zero_bit() failure
by condition '(prot->inuse_idx == PROTO_INUSE_NR - 1)' obviously.

Fix by correcting the condition to '(prot->inuse_idx == PROTO_INUSE_NR)'

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250410-fix_net-v2-1-d69e7c5739a4@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3c5386c76d6fe..9c63da2829f6e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3930,7 +3930,7 @@ static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
-	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
+	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
 		return -ENOSPC;
 	}
@@ -3941,7 +3941,7 @@ static int assign_proto_idx(struct proto *prot)
 
 static void release_proto_idx(struct proto *prot)
 {
-	if (prot->inuse_idx != PROTO_INUSE_NR - 1)
+	if (prot->inuse_idx != PROTO_INUSE_NR)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-- 
2.39.5



