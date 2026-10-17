Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8635C1BC;
	Sat, 17 Oct 2026 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253820; cv=none; b=r/w/ikiFtv4I5hYyYVlbSYeg8rHGmmoy0RGF4O/pLXVDMwiIMpSqSjCDikbjgATX3bEN1ukzVKuoPUvG/VR/Q/AEY002Dhy73R9+4SUi7zvks1S0NeF21c+BovOX0y3jb3emPO+0d5uToQvQC/GrXj5lMurCwFW6fB+v7Y/iE98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253820; c=relaxed/simple;
	bh=fMdMWUybbVv3VtpgaiIFsgpAO4JRvBEdNIv6RarpRaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZevvtXglZ4Xy098NRHMduOPqNriUH49AMQYoKmXE4o20CEcVFh8K1K01y0j7T+LE761tN9yijG9Ev3+mvo2evsViHyb11B5XHTem0ToTSh0U8VzEXqhTNgrRovw7DtrajNt6W09/mFbD2zQb/xFB0ELS0DzZzH/2rJ2J1C0Wms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RACaEC8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RACaEC8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B46F1F000C4;
	Sat, 17 Oct 2026 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253818;
	bh=ti2y8AHhDPr/gRHqMp3hiMpVqEkx+rqXptlx0j4n5Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RACaEC8ocuwF2smIXqxcZryfCgaCr4ktrgyfpj8mOgFXMfn1Jyp7EuIHDzAJDJPzM
	 +0BMwLBwgWEXwgc8ZNz1Kl8ThOvy4PJ+Bhdz5nsJt90+qIyGIAAGXxH4Xcqe6V5NF5
	 /XvQ2n92qyxvtF0GyW3KVz8idyTLTAinQ9/jJXR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/869] ksmbd: fix signededness bug in smb_direct_prepare_negotiation()
Date: Sat, 17 Oct 2026 17:51:22 +0200
Message-ID: <20261017160043.236525895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3976009596d99..585617595727b 100644
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



