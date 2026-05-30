Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8B33FE15;
	Sat, 30 May 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161712; cv=none; b=r53/i2RiND8/06SEhbCo3qTgtfT/bhL1rg2Cx1MVmQ0NXHAImkcqRXSSUyZpq2NB2CVgAKtD8g9vFWCt7lrgG3m0reuYGsC/yARqzD3LduCwtCADlZYFYWBMXDxpxem+mwIkZTlwgtG/Gv8L+aXjtD3dNYfgb9PkPOwkA/5MofI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161712; c=relaxed/simple;
	bh=EgJYAjw1oJc4vNoRE9d+vKp5Xe/LqnrG4vJ2M/zXCaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXy3RkdKKKSqLeG0/U7+zj9qFgaftTu0om1SVGrQoVm0/PxSiRwMyQjZGgrirfAPH8ynDJROm/DFb7QC9QAKMVnhr3sK4qLd2YaY9KyiTRkb7FljIEBqXni0THPDIyUkDOdKW9ZGia1IJxtsCb2c7vYU+H6bVRc4Uv05Av9Q4dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYRpMmt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYRpMmt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C831F00893;
	Sat, 30 May 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161711;
	bh=5pUCFMW4qeVT4XSEWRRjLhsFfZgZvi2EaNroleNtw3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYRpMmt41tgJ4ECVpF3c91xOKH3ms6Kj5kjF4nTvt3AsmcAlPgspEgm3AIJr1Cuzb
	 7aULUPIAkgVYkEjWnFDyV5I0pUK2WG4RCXVWGTYsF/8woKhe267J3R8n8CjJBp9cVd
	 p2XcoDgrgz4Nnr8NH+jNAP4V7ep8zHf7IP2LRPPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 697/969] sctp: fix OOB write to userspace in sctp_getsockopt_peer_auth_chunks
Date: Sat, 30 May 2026 18:03:41 +0200
Message-ID: <20260530160319.764094888@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 0cf004ffb61cd32d140531c3a84afe975f9fc7ea ]

sctp_getsockopt_peer_auth_chunks() checks that the caller's optval
buffer is large enough for the peer AUTH chunk list with

    if (len < num_chunks)
            return -EINVAL;

but then writes num_chunks bytes to p->gauth_chunks, which lives
at offset offsetof(struct sctp_authchunks, gauth_chunks) == 8
inside optval.  The check is missing the sizeof(struct
sctp_authchunks) = 8-byte header.  When the caller supplies
len == num_chunks (for any num_chunks > 0) the test passes but
copy_to_user() writes sizeof(struct sctp_authchunks) = 8 bytes
past the declared buffer.

The sibling function sctp_getsockopt_local_auth_chunks() at the
next line already has the correct check:

    if (len < sizeof(struct sctp_authchunks) + num_chunks)
            return -EINVAL;

Align the peer variant with its sibling.

Reproducer confirms on v7.0-13-generic: an unprivileged userspace
caller that opens a loopback SCTP association with AUTH enabled,
queries num_chunks with a short optval, then issues the real
getsockopt with len == num_chunks and sentinel bytes painted past
the buffer observes those sentinel bytes overwritten with the
peer's AUTH chunk type.  The bytes written are under the peer's
control but land in the caller's own userspace; this is not a
kernel memory corruption, but it is a kernel-side contract
violation that can silently corrupt adjacent userspace data.

Fixes: 65b07e5d0d09 ("[SCTP]: API updates to suport SCTP-AUTH extensions.")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260416031903.1447072-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index dfc613859ff58..b544f403f7ca8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6995,7 +6995,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 
 	/* See if the user provided enough room for all the data */
 	num_chunks = ntohs(ch->param_hdr.length) - sizeof(struct sctp_paramhdr);
-	if (len < num_chunks)
+	if (len < sizeof(struct sctp_authchunks) + num_chunks)
 		return -EINVAL;
 
 	if (copy_to_user(to, ch->chunks, num_chunks))
-- 
2.53.0



