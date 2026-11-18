Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051872;
	b=U6e6+RB+GiIEaCHAa4h+hj9QzRa4v0h/vrfQ2bCQ2tVvanAP6B9lubnd5opDltLHnd0a
	 BcymhNNUNF4yFH2ASS03a5hqqx4g8/w4HK36bxMEJBQ5fqYQ/H8pOZcDsenx6YIE0Uqj+
	 glhmCuT3nbTlPFAkL5cRi4u/scSwnBtIGozLdfj4dd832JE9xeyQpfpCGPMzzYQ418JhQ
	 bq94B7JtdOxqZI/6+ZLwlkzTHao47+J0MLwvSxL/FfOEwtNwULY/LjFRugQsD6WVsX0MM
	 5gFc6koaR+oYS137XiQVzUTU8IN98Gve9MciD6reSMhFwOurV9L5sDurtq1lf8Qpolg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l4X57mJF20PKWRiMX1DW5KqcVY8YCCq7T7pCjaGXisA=;
	b=d6KV2fZys0bw8pRXk/iW/P1oONlrLxcHV/zLV50xrMtlHBzz9uwyJGHt5bNPkYNVaRvb
	 ocVUXcbJjieN/jNsvptYzFmyCiTPzX+ntubCAyGz4zYhPxzYWGOGUy9WOAU2b6vrkIau6
	 3PkObLB3TY4PFKPuL9Dgy7X3bi1bPPdxb5wIst02MymQvSOABIeZA3XT/qaLfApEoa4ID
	 2VVKgfu8e56SSD5seNBsa9VdsccYZz/peM5TdWPCTYcmmRaSlpYFNKjdNuu+eIJvlCbt5
	 jjCN9/xP+yCQFUf0YK2xK6LQWWLx0uJAohng+Zzp8yP1YthffuDedVcPhhGVCLeRoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMyd6HYv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B46E606A31C;
	Thu, 19 Nov 2026 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMyd6HYv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30441F000C4;
	Thu, 19 Nov 2026 01:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051872;
	bh=l4X57mJF20PKWRiMX1DW5KqcVY8YCCq7T7pCjaGXisA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMyd6HYvDzl5nl64gz/izZTdUk8jgRs625coSInB01s8/PLYSZHzBNV+8dxWl+Dx8
	 SmPnYDhI/GgbRx3bjq5LcuYkvHuGQ+FvH2oWntzi9NUGyXCboAm+v3cTmzEoMPHN/P
	 EzHpWO90m5wq8lyozhbmUlQIG05V3r86aP6rzjbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0360/2214] SUNRPC: keep the first error in svc_register()
Date: Wed, 18 Nov 2026 15:33:56 +0100
Message-ID: <20261118150025.086564456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9ed91d7c4698e611ea5bfca45076008def831fb3 upstream.

svc_register() assigns every pg_rpcbind_set() result to the same "error"
variable and returns the last one, so a later result erases an earlier
failure.

Keep the first error instead of the last.

Fixes: 642ee6b209c2 ("SUNRPC: Allow further customisation of RPC program registration")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-3-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1102,13 +1102,16 @@ int svc_register(const struct svc_serv *
 
 	for (progp = serv->sv_program; progp; progp = progp->pg_next) {
 		for (i = 0; i < progp->pg_nvers; i++) {
+			int ret;
 
-			error = progp->pg_rpcbind_set(net, progp, i,
+			ret = progp->pg_rpcbind_set(net, progp, i,
 					family, proto, port);
-			if (error < 0) {
+			if (ret < 0) {
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
-					progp->pg_name, i, -error);
+					progp->pg_name, i, -ret);
+				if (!error)
+					error = ret;
 				break;
 			}
 		}


