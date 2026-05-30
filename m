Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F17B21B191;
	Sat, 30 May 2026 18:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166648; cv=none; b=RhiEZoFnceXHjkf7+ZTM2XM/ADWwfU3hTVyw1kMaI0TK/W4VUHstz5tHcOJekpDf3WjiXTu7RE+8JoENGBs3kTz9262+agoOGxOKDq6EY8uxv+UIHQLQ73P98jF+2CEMTzERcLhGytBnT0z+HBjMULvIOvqZbdeep0tID64wyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166648; c=relaxed/simple;
	bh=dbH9qiT9CI9jY3eLN55wVKRZbMBYV7kKAL4XdpOnyuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0CvzWy3Nezv8J4bbIh3PRsh7pP++DHg3ktSU2sVHFDZ5X15hkPu5JKfjBw83m3tAMRv7l2Q0Wt2/6EvOFYvHQAgEMNHT7b1RuCZU6X+SBOcmGKkYcf04C4sX1EZqzXEp3YZyDBduQcHwPz25Dz/ROpJSJgLd5e01uJfC5YbVU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehg5mcXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehg5mcXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BF11F00893;
	Sat, 30 May 2026 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166647;
	bh=Q1iSgwUtQnFIaYXo+wsAyN94IBO2QhSLQDdMQ3PE1mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehg5mcXNFPhuBw6EGyOk41zjrBQn0YO3UykNdbXapQFLOzUvfug4YHIgTXa2lnD2W
	 dzdzl7NTMf2FZCLa9Zj1hmlKXpBGTfsFUr4Co7P2ime98zXPXyQb+wPoY7eny+eE/f
	 P7FXFJqQve69QrutAxDMF3iXc0c5/AEPQGe5VPCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/589] sctp: fix OOB write to userspace in sctp_getsockopt_peer_auth_chunks
Date: Sat, 30 May 2026 18:05:08 +0200
Message-ID: <20260530160235.947680395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e0f608eb46902..8c7bdf01e32a1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6880,7 +6880,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 
 	/* See if the user provided enough room for all the data */
 	num_chunks = ntohs(ch->param_hdr.length) - sizeof(struct sctp_paramhdr);
-	if (len < num_chunks)
+	if (len < sizeof(struct sctp_authchunks) + num_chunks)
 		return -EINVAL;
 
 	if (copy_to_user(to, ch->chunks, num_chunks))
-- 
2.53.0



