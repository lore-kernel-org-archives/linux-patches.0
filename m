Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891801F16B;
	Sat, 17 Oct 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258552; cv=none; b=VNVUCFngntXhz6fwlVT1XPrHgT6DAXPFA1SDwfUsyE/7BkEhUuRPIWfQAVktdT5dXx3jqPy5KKl7C99qwtFKS35ozYY3aqM+u8pHcAruezhsd5iJkAhV2BhBpskiPrhpHNyUH7qFugX0/3KBHaJXdZpCZvm4DGjclovJ1o/0x/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258552; c=relaxed/simple;
	bh=stV4Z0jBhLKf/M1hQFHs7G4Ua3Fdn8pavS4qP9s69rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwJ2kWeM+4ZhekbeS9VSMsJDa3eMquhzP6RYdwRTTl3GFRk9fW47SP7/fmtrJMZn7qHxWwG1RhpCTduHS4l9AMM1U6SmWxvzfAFwPxFgR6RJ36blVByPo+1taqvdxCbwPHSoh0GBiTzeDx4ZQXwrE4U4O/uedoQ6HgzEvjmPhRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDenuaPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDenuaPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D071F000C4;
	Sat, 17 Oct 2026 17:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258551;
	bh=fz8z4CfxnYAu6MUv7ip8/elY8/Wr614WwokKDoLBGqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDenuaPNIO8izMSFIgZLb2aN8Lxsi2UaFU3gWichbt4uvaoTSFp0ucujpwSSZUc3i
	 k+XQfj1p1+YAtzYGrsN2fJwlsWB8CY1w9y20Rb5DBlZlB+aHzKrvTMZzJ3hQlxnKXN
	 a5FiqS9UNDy+9Eu+N4TwA7ETW4JxxP5Mz+wVXI5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0921/1674] ksmbd: fix signededness bug in smb_direct_prepare_negotiation()
Date: Sat, 17 Oct 2026 17:53:13 +0200
Message-ID: <20261017160454.775846234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 6b4f875aac344cdd52a1f34cc70ed2f874a65757 ]

smb_direct_prepare_negotiation() casts an unsigned __u32 value
from sp->max_recv_size and req->preferred_send_size to a signed
int before computing min_t(int, ...). A maliciously provided
preferred_send_size of 0x80000000 will return as smaller than
max_recv_size, and then be used to set the maximum allowed
alowed receive size for the next message.

By sending a second message with a large value (>1420 bytes)
the attacker can then achieve a heap buffer overflow.

This fix replaces min_t(int, ...) with min_t(u32)

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 10ceade590529..8c450e5fd4f0b 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1977,9 +1977,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		goto out;
 
 	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
-	st->max_recv_size = min_t(int, st->max_recv_size,
+	st->max_recv_size = min_t(u32, st->max_recv_size,
 				  le32_to_cpu(req->preferred_send_size));
-	st->max_send_size = min_t(int, st->max_send_size,
+	st->max_send_size = min_t(u32, st->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
 	st->max_fragmented_send_size =
 		le32_to_cpu(req->max_fragmented_size);
-- 
2.53.0



