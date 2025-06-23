Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63A4C74;
	Mon, 23 Jun 2025 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716132; cv=none; b=YAkWdqhFQYPuhUzdX0F1tmgwPROLlapWVO/kArKJGqIrTQyakzb+YTHQ95MSDdS0cl/cE+DjaK8FDbcM1XHBa5ovmBEQcE92q+GDmeJOoQmaHWw8wWgailrc11up5Hp6e7IyDLIp2KqeHFTcgtsfakunXHnh0G/2t0YfEZc2Ko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716132; c=relaxed/simple;
	bh=rKASpjpWT1ZOG6NMp74XgnhBq1oFNy9jo8sq5ZpX0ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMn0fbxPsCi8aTrM5SRy2fquKHjm+LVUW6LoOH35gPF+LRSwQ8c1EuWcgqFfTmybb/cxVZlkU1LMEs+SWaoPspflmOWWxrM+mm16+kDoYfuC+m0qhj0OxQOa3BRS6VkH+WiEP+YCQ4cEfVjk2zuDaCPJVRx3szHgf+aKsyUbQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEpVJwKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEpVJwKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0122BC4CEEA;
	Mon, 23 Jun 2025 22:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716132;
	bh=rKASpjpWT1ZOG6NMp74XgnhBq1oFNy9jo8sq5ZpX0ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEpVJwKijjCMwRoRenZezIQKa2ciUzkifoS9lKzcpaEkoo3bGmM2/YXAKftRMB7yk
	 3idNyyYYvCNZw/DuYsVBe6tR67Hb0+nRCTB6/3EfETXmo5Y/AAGtG/FGLcawNCFUGf
	 /51vuKHVfnWKshlFuLx49fUvEsRXt7eLqpo4wzQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	tianshuo han <hantianshuo233@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.6 242/290] sunrpc: handle SVC_GARBAGE during svc auth processing as auth error
Date: Mon, 23 Jun 2025 15:08:23 +0200
Message-ID: <20250623130634.209034136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1344,7 +1344,8 @@ svc_process_common(struct svc_rqst *rqst
 	case SVC_OK:
 		break;
 	case SVC_GARBAGE:
-		goto err_garbage_args;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
+		goto err_bad_auth;
 	case SVC_SYSERR:
 		goto err_system_err;
 	case SVC_DENIED:
@@ -1485,14 +1486,6 @@ err_bad_proc:
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


