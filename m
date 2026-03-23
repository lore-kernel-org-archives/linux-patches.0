Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAACB3AF67D;
	Mon, 23 Mar 2026 14:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276998; cv=none; b=A0grmYUIapxe2aoU1rmu1asu0Flxhc81MwKluu+CI4yLus9HR0DzzT7+Dy3zBmNVVXMf+k9eQWv1oCe+AtHcaB0itLP3W4UtocZjg142YmoRZalfBPfPI4usv5mv8XfMnFmb8932d8XDHI6u/KjoWDfD5IQ4/PjR0B0nttPiwrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276998; c=relaxed/simple;
	bh=d6JBE4ZrP+2RqJL1MNSUFja7TeEf4FofABoZ8l3kmSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=na8zBc/rfvSzWl6lccWuA7BIohbuwKpyhPH1x0yd8FaMcydU81OKOkMLnLmZs6XFqa3MSokGtFrdOU9yQXQdt7zMRwB6vuvE5tY8mCmcsyUMUYTndWZ57p6qtVwJ85NpIPQcoEI3tudlQnGb2cspswv3gdvpLqbt8iplMakqV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBNOAWeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBNOAWeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E73C4CEF7;
	Mon, 23 Mar 2026 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276997;
	bh=d6JBE4ZrP+2RqJL1MNSUFja7TeEf4FofABoZ8l3kmSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBNOAWeHITFpcohIEJ/OoaZjgOa9/xuZQzkbe3mXEzjwhy7h/gAbxphm1WclAtEiP
	 2axYtHxeX6edoBiX8Od/1ElcHAluNHNsnl6OjH9nL2D6b+SieG7Hjn+bl5XlBA7Dug
	 fVAdS3gRlcoCDqHQbcuW1qEWCYj9l90eTuLoC/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 281/460] io_uring/uring_cmd: fix too strict requirement on ioctl
Date: Mon, 23 Mar 2026 14:44:37 +0100
Message-ID: <20260323134533.383114411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Asbj�rn Sloth T�nnesen" <ast@fiberby.net>

[ Upstream commit 600b665b903733bd60334e86031b157cc823ee55 ]

Attempting SOCKET_URING_OP_SETSOCKOPT on an AF_NETLINK socket resulted
in an -EOPNOTSUPP, as AF_NETLINK doesn't have an ioctl in its struct
proto, but only in struct proto_ops.

Prior to the blamed commit, io_uring_cmd_sock() only had two cmd_op
operations, both requiring ioctl, thus the check was warranted.

Since then, 4 new cmd_op operations have been added, none of which
depend on ioctl. This patch moves the ioctl check, so it only applies
to the original operations.

AFAICT, the ioctl requirement was unintentional, and it wasn't
visible in the blamed patch within 3 lines of context.

Cc: stable@vger.kernel.org
Fixes: a5d2f99aff6b ("io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Asbjørn: function moved in commit 91db6edc573b; updated subject prefix]
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -338,16 +338,19 @@ int io_uring_cmd_sock(struct io_uring_cm
 	struct proto *prot = READ_ONCE(sk->sk_prot);
 	int ret, arg = 0;
 
-	if (!prot || !prot->ioctl)
-		return -EOPNOTSUPP;
-
 	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
 			return ret;
 		return arg;
 	case SOCKET_URING_OP_SIOCOUTQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
 		if (ret)
 			return ret;


