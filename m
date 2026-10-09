Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A233A3B582F;
	Fri,  9 Oct 2026 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555664; cv=none; b=MhGZrPB3O7ZPBeg4bzy4nVY0SV59/M+QmG1mey06UtiqbezdeHaRLouOGqb7SFzVKSAx3UYe5BAgeFpZH7KSZzuzIfJBuyUKWQl+8B20EMW2LfCWE8bDrggSX1VE5wzn3GtLSTmlgTCgRHTgH2Fgsjdu7C5LMbQFDlU59el8IlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555664; c=relaxed/simple;
	bh=O20jsHfoUgI16NnurJ8gQqjMpooKRqAe//ZG6UU703Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcVHmtiHHze64gk0qcgWynZzkkcMbey1QLZl49EVtzTkhhYM/m0w3D3PvH+s7qMBYy3ylecLUpK9zwG5AnxFhx6nHk5NpP9A0KhizfpmACmmM+C3l6kRmvs8MSIs2Gn3CDGDWrExzF5fCiIEsWNP6cyikwGEhXaJ3y0EgM0RHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ0GOFnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ0GOFnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C351F000FF;
	Fri,  9 Oct 2026 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555662;
	bh=DXeABlEYHS7VbNlvfpb0I6RhU4o+bdguzCytQLRpEWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ0GOFnxhOCZgbHs5q5u++dboNgo3U7wxa93aKNkzA+MyF+WXq+DLXot8BcHc7w8m
	 h8lrSQhb3skF5vfMvvmEQQrRpM9K8yx2cXmtNKv5tBAeiakz2bpop5vf/FMeOJW6Ql
	 I26QSBXQv+dIkAhMQ+PVAHSqy4uyFAC2OFTYlANw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 045/428] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
Date: Fri,  9 Oct 2026 16:06:22 +0200
Message-ID: <20261009140947.095867854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yang <junvyyang@tencent.com>

commit 4f1da630d13de0370e2f6361f961f1c8b384af1c upstream.

sctp_wait_for_connect() drops the socket lock while it sleeps. An
out-of-the-blue ABORT can then be processed from the socket backlog and
unlink the association. If a concurrent shutdown(fd, SHUT_RD) sets
RCV_SHUTDOWN, the waiter breaks with err == 0 before checking
asoc->base.dead. Its final sctp_association_put() can then free the
association, leaving sctp_sendmsg_to_asoc() to continue with a dangling
pointer.

Check RCV_SHUTDOWN along with the wait error in sctp_sendmsg_to_asoc()
before using the association again. The check only accesses the socket,
so it needs no additional association reference. Return the existing
-ESRCH so that sctp_sendmsg() skips freeing a new association that may
already have been destroyed.

Keep sctp_wait_for_connect() unchanged to preserve its behavior for the
connect() caller.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260926095606.68601-1-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1844,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct s
 		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
-			if (err) {
+			if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
 				err = -ESRCH;
 				goto err;
 			}


