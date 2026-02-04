Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5842188A;
	Wed,  4 Feb 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216937; cv=none; b=N5Qh8NPEx8dq6S7I5zhlyPdQGmFptd09NAXUzf4PvDBNbBv3t3bXy2b8FvPhAYkchT7pfu4o+d5Ozx3Syz2KfwK+vCoGQFv3H8pLD05+InUnTCyxVluE6mFphj7CHYZk5KJcfXe6CLvc0R18UGx9v10no/0JZ8onyuOeXJ8X57o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216937; c=relaxed/simple;
	bh=r3twgjmPjqfcjimrv/3dNYObQLlC869XxZE9Lc1lgsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6LBZIUC0KgcSyA7YON/5UeK7T+pXh7wVmYlh51si00jPo8yJ6r/3+thJCc7guJTxSztZAuCEx7nS0vz5B/pOi24bwwDB8dSRfbNL6r1HEWpuUO/x72/fmqxRRzdfUTg9L1x53kplNjEQLnnjtiD/HFqW0XWDpXbNDZhXpz/knw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFLGLVwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFLGLVwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7F3C4CEF7;
	Wed,  4 Feb 2026 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216936;
	bh=r3twgjmPjqfcjimrv/3dNYObQLlC869XxZE9Lc1lgsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFLGLVwQMdRj+z7mT0tm3Twh68zxP292U9u0rIVDcbXVhvN2950xrw52HQvbyWfNT
	 31xmvZrd26Jy+wvJxRKo9qALjLDcwRNtq3ZE7daUlqS/JSc+uJOTuXUX7ybnmItBrX
	 oxey3Cviiv1MB2G8ab2dQSSrq0r813N4SN/8oyEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/206] fou: Dont allow 0 for FOU_ATTR_IPPROTO.
Date: Wed,  4 Feb 2026 15:38:27 +0100
Message-ID: <20260204143900.950361531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7a9bc9e3f42391e4c187e099263cf7a1c4b69ff5 ]

fou_udp_recv() has the same problem mentioned in the previous
patch.

If FOU_ATTR_IPPROTO is set to 0, skb is not freed by
fou_udp_recv() nor "resubmit"-ted in ip_protocol_deliver_rcu().

Let's forbid 0 for FOU_ATTR_IPPROTO.

Fixes: 23461551c0062 ("fou: Support for foo-over-udp RX path")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260115172533.693652-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/fou.yaml | 2 ++
 net/ipv4/fou_nl.c                    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index 266c386eedf3a..e5753a30a29a2 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -36,6 +36,8 @@ attribute-sets:
       -
         name: ipproto
         type: u8
+        checks:
+          min: 1
       -
         name: type
         type: u8
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 6c3820f41dd5d..5bb8133ed7a89 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -14,7 +14,7 @@
 const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
 	[FOU_ATTR_PORT] = { .type = NLA_U16, },
 	[FOU_ATTR_AF] = { .type = NLA_U8, },
-	[FOU_ATTR_IPPROTO] = { .type = NLA_U8, },
+	[FOU_ATTR_IPPROTO] = NLA_POLICY_MIN(NLA_U8, 1),
 	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
 	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
-- 
2.51.0



