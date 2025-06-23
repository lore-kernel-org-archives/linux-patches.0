Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4A94409;
	Mon, 23 Jun 2025 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716073; cv=none; b=VyHB3a7rq1ROq6VbqKMuZY0ZTJG1UNwiZ5rn9sw27dvpdyQ2Fr1hv4nZMceHrbHj8WrLpIEN24At6rS2rfmHLpihEr+N1zvDByVwzZ4UEMbdTM9txkudrpAemXGzRmJpm4dpAJO4/Q4eXxCMrVTeNbvi8iUoRooU7iKpxWj8o7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716073; c=relaxed/simple;
	bh=BntU0rwWl1a/639FYeruWVy8FKnACTGpBHPw17oZmjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sabenXfgfJt3lHC0OrtSdyBrmyk3Lgj20Xr1yLw1AF/CIwdKdBjPvOrUwHppwY62DRV+R/TzbReZQtGO9uRbSnCMuDc2aPjbOjZRivHUTpjoZQhv2tCr5OHgltJTp0BPL7SSL/Tt9E5XC7dam6FfhMdka5iOJ0vZtAKoj7oi+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uSwxoeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uSwxoeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F6BC4CEEA;
	Mon, 23 Jun 2025 22:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716073;
	bh=BntU0rwWl1a/639FYeruWVy8FKnACTGpBHPw17oZmjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uSwxoeb90FsF3lzlLixvVwulxwHTyFYGSsIfloNb2QvHwIrgym2ZqK2h28GV+Ezn
	 xKs11ZYq5WKY2ZDVSpvvk/0FBuwYsPP9huqt7d/LQT3CEcUCQc6hkBHPHSdv7YuGEY
	 ck934HRCsYcU54dyAzzHMwLE5zzHYxsVwsc7kHYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	tianshuo han <hantianshuo233@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.15 500/592] sunrpc: handle SVC_GARBAGE during svc auth processing as auth error
Date: Mon, 23 Jun 2025 15:07:38 +0200
Message-ID: <20250623130712.324662799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 94d10a4dba0bc482f2b01e39f06d5513d0f75742 upstream.

tianshuo han reported a remotely-triggerable crash if the client sends a
kernel RPC server a specially crafted packet. If decoding the RPC reply
fails in such a way that SVC_GARBAGE is returned without setting the
rq_accept_statp pointer, then that pointer can be dereferenced and a
value stored there.

If it's the first time the thread has processed an RPC, then that
pointer will be set to NULL and the kernel will crash. In other cases,
it could create a memory scribble.

The server sunrpc code treats a SVC_GARBAGE return from svc_authenticate
or pg_authenticate as if it should send a GARBAGE_ARGS reply. RFC 5531
says that if authentication fails that the RPC should be rejected
instead with a status of AUTH_ERR.

Handle a SVC_GARBAGE return as an AUTH_ERROR, with a reason of
AUTH_BADCRED instead of returning GARBAGE_ARGS in that case. This
sidesteps the whole problem of touching the rpc_accept_statp pointer in
this situation and avoids the crash.

Cc: stable@kernel.org
Fixes: 29cd2927fb91 ("SUNRPC: Fix encoding of accepted but unsuccessful RPC replies")
Reported-by: tianshuo han <hantianshuo233@gmail.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1369,7 +1369,8 @@ svc_process_common(struct svc_rqst *rqst
 	case SVC_OK:
 		break;
 	case SVC_GARBAGE:
-		goto err_garbage_args;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
+		goto err_bad_auth;
 	case SVC_SYSERR:
 		goto err_system_err;
 	case SVC_DENIED:
@@ -1510,14 +1511,6 @@ err_bad_proc:
 	*rqstp->rq_accept_statp = rpc_proc_unavail;
 	goto sendit;
 
-err_garbage_args:
-	svc_printk(rqstp, "failed to decode RPC header\n");
-
-	if (serv->sv_stats)
-		serv->sv_stats->rpcbadfmt++;
-	*rqstp->rq_accept_statp = rpc_garbage_args;
-	goto sendit;
-
 err_system_err:
 	if (serv->sv_stats)
 		serv->sv_stats->rpcbadfmt++;


