Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE47425CEE;
	Tue, 16 Jun 2026 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627339; cv=none; b=ssMJEr04lePkoUGFBMExbxmDep6QNWGeuN4DtlgurC74Zt3s6bcIrxUJrbKVOseLEFCRQHYfI1gHpU4zOVX/LNtPqMXOlgiDTsSc2ITpOXOFNaw9GgXMgskEMassW+C9JjYwJwIMaKIgzNTEZsBcyfUF6jsqCVMX+9NaXcCmNCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627339; c=relaxed/simple;
	bh=qgVKqQKxXpWHu8XH391mb2gEUDNy8Asfc+M3EGo+q18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdDvy99pyeigggYlFtqhalIMot0fjCG1dahZ1586S9TXKtvZcr2I+Vkp8naHC8c3GUeXRBoWOD8uRyt1a/PHpHTKBgZkLmgcDliYPUOyZa+iWGc/Xx+Y6qgHSadZv1WNMZBpxK81nNz8V3bvr69OwOUTkVJPRI7aLjiaYwtRSRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjabosZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjabosZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E795B1F000E9;
	Tue, 16 Jun 2026 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627338;
	bh=Eh+zIFXlyF3wiixaIrUk0ujGTfRc58OGilvevkSYpiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjabosZVd5TQZUYD7Lte+04bmC/FxzzzEEHoxJhLlD8RRawsRRDEvrsHmMqcSu6r/
	 rcKTM5ANLyuqFNIaOMgktkVJQmZF0VOjU590CNnq2sW5YI/3ZF4oj9++YiLgq0MqnP
	 /ZliSV5sKpot0vXZ1cToID3CqQs1LLNQNdgeQFx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 159/261] mptcp: sockopt: check timestamping ret value
Date: Tue, 16 Jun 2026 20:29:57 +0530
Message-ID: <20260616145052.443884965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 57132affbc89c02e1bf73fdf5724311bdc9a29da upstream.

sock_set_timestamping() can fail for different reasons. The returned
value should then be checked.

If sock_set_timestamping() fails for at least one subflow, the first
error is now reported to the userspace, similar to what is done with
other socket options.

Fixes: 9061f24bf82e ("mptcp: sockopt: propagate timestamp request to subflows")
Cc: stable@vger.kernel.org
Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Closes: https://lore.kernel.org/willemdebruijn.kernel.178a41a53d041@gmail.com
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-7-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -235,15 +235,19 @@ static int mptcp_setsockopt_sol_socket_t
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err;
 
 		lock_sock(ssk);
-		sock_set_timestamping(ssk, optname, timestamping);
+		err = sock_set_timestamping(ssk, optname, timestamping);
 		release_sock(ssk);
+
+		if (err < 0 && ret == 0)
+			ret = err;
 	}
 
 	release_sock(sk);
 
-	return 0;
+	return ret;
 }
 
 static int mptcp_setsockopt_sol_socket_linger(struct mptcp_sock *msk, sockptr_t optval,


