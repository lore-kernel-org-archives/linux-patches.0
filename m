Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B43B4E9B;
	Tue, 21 Jul 2026 20:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666153; cv=none; b=OtQTer3E0HqN/gcgYJrBx+Txnia9zlR/bm9GZ4IwUnWEJrantAgBM9R2xfXoqPhd6gifaoKeOzPhDWYlwFhHCXKhDic7iApMlbfKB8ze7DieZeJp+DY95G3z0VvvT5CyUwGA4QIrIbuHfHpKwtLyTpbIIDdSy4Ec0P29K+xjtL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666153; c=relaxed/simple;
	bh=ANBSjb6TmoaFTfPuWQ2mTX8R0HeIdoit3REkNlFY0xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXlpU7iyyf3W1BwLmq1mn8687nt3IT34KM6xxLSMs78CaQ5146LtxrHIFd8pcR0Ke9FeKhUeNJLltmtDKEVxKz8DaAMKXbe9RTPfBCMTGbc35BPoiVvMBCmTcCpWGSSLeW6y3jE210pABAewaxyn9sL/OQypWjIa7jmckHK97Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrW4lvwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrW4lvwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E1F1F00A3A;
	Tue, 21 Jul 2026 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666151;
	bh=qLwZNkKSHpZ/1MFlNXJdpAIlXexd8xk/UGEGAvi2Ts4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrW4lvwkslZWmZlHf42R4SuVBBc0B2QhdPGgcN2w9HAQg5dxVLOogQ/kEHYVGz3PK
	 9+2bwPuX0V2uk8BbpLemAlkol0KXkMdAhDa2ZEtX8Q/E0OvgZOLJg/OoBroYM68Oo4
	 D0cr6xifslN47N0ZwOZO9CoaNcwc9ARYuYqiTi8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0574/1266] handshake: Require admin permission for DONE command
Date: Tue, 21 Jul 2026 17:16:51 +0200
Message-ID: <20260721152454.709732874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81246a65303d9635266b1334490142caaf86a11f ]

ACCEPT and DONE are the two downcalls of the handshake genl
family, both intended for use by the trusted handshake agent
(tlshd). ACCEPT already requires GENL_ADMIN_PERM; DONE has
no privilege check at all.

The fd-lookup in handshake_nl_done_doit() only confirms that
some pending handshake request exists for the supplied sockfd;
it does not authenticate the sender. An unprivileged process
that guesses or observes a valid sockfd can therefore submit
a DONE with HANDSHAKE_A_DONE_STATUS == 0, leaving the kernel
consumer to proceed as if the handshake succeeded. A non-zero
status on a forged DONE tears down a legitimate in-flight
handshake before tlshd can report its real result.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260609141831.90694-1-cel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/handshake.yaml | 1 +
 net/handshake/genl.c                       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 6d89e30f5fd52b..0888c39ec2bcd0 100644
--- a/Documentation/netlink/specs/handshake.yaml
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -113,6 +113,7 @@ operations:
       name: done
       doc: Handler reports handshake completion
       attribute-set: done
+      flags: [admin-perm]
       do:
         request:
           attributes:
diff --git a/net/handshake/genl.c b/net/handshake/genl.c
index 233be5cbfec91a..8fdec426e580a0 100644
--- a/net/handshake/genl.c
+++ b/net/handshake/genl.c
@@ -36,7 +36,7 @@ static const struct genl_split_ops handshake_nl_ops[] = {
 		.doit		= handshake_nl_done_doit,
 		.policy		= handshake_done_nl_policy,
 		.maxattr	= HANDSHAKE_A_DONE_REMOTE_AUTH,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 };
 
-- 
2.53.0



