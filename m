Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DFE1A6808;
	Mon, 23 Mar 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275522; cv=none; b=NsfRGNyW+QRGJ8Nd283FZp3EG/OtKUwtFFo5q6hKwCPxXuFgG4yQmpu6HXuzzn2s3fBOrpnjlKSqz6GwJWQYM3khWTUnO/8z7Kxgh5KEwxRHQj9VmTolusCfcHhXzLVetEWXUDfgDi6kBfniwd+KupDg9pOngxyTPP1gAn3B87k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275522; c=relaxed/simple;
	bh=YxSqfCcl05ibHhVEAWeqg1Z3ZWQuJfno6JY5yFyoHjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3j/OthRMEj80lzbYHpiCeQDGhseSo2UY1t5J8TcO8o/sjUmMsJJtDbSS4SS5dV/yGVwmI3ZiMllslELDwMWKbNjkqXIf8JLx4XGSRqD9DBwitD6bHfbeRfEV4YvRa51bRIuURddPTb4dB0ssoaUm/YvS2XG+FpZJrGEFz1Pe1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbMMJmJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbMMJmJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AE3C4CEF7;
	Mon, 23 Mar 2026 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275521;
	bh=YxSqfCcl05ibHhVEAWeqg1Z3ZWQuJfno6JY5yFyoHjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbMMJmJI99bDsE7hj2MpMnMDsXZYm4GXeymmKwaOdmgCUQFzWwS42oXgH9Jrm6D3G
	 MXWCHgRHLsMCSJfoJNb7/Oc0Eeetx8nVZQOH42F7LjR/1dUCuuV+0yHHqF8Lksu+nc
	 V0fuVQyT1+W0ebFSwlJ8lUHLHUoXPWnj/PNzGLQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.12 130/460] libceph: admit message frames only in CEPH_CON_S_OPEN state
Date: Mon, 23 Mar 2026 14:42:06 +0100
Message-ID: <20260323134529.804784895@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit a5a373705081d7cc6363e16990e2361b0b362314 upstream.

Similar checks are performed for all control frames, but an early check
for message frames was missing.  process_message() is already set up to
terminate the loop in case the state changes while con->ops->dispatch()
handler is being executed.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2936,6 +2936,11 @@ static int __handle_control(struct ceph_
 	if (con->v2.in_desc.fd_tag != FRAME_TAG_MESSAGE)
 		return process_control(con, p, end);
 
+	if (con->state != CEPH_CON_S_OPEN) {
+		con->error_msg = "protocol error, unexpected message";
+		return -EINVAL;
+	}
+
 	ret = process_message_header(con, p, end);
 	if (ret < 0)
 		return ret;


