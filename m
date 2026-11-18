Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035561;
	b=awS1ZosPfcGKaeXncie6ahPefeRl2HGAcMo5JGv6VUzX457vP7O9fnPJ+G3XFnn2DIG/
	 hPzAzjuNuCJVouhJW/lVM5I+RJtfwFVowiagJws+ddT5BEppk78E2a1wcgaDljUc4T+qz
	 LH7y8jKOVNePSGFjGrUGdhG3JXZh3xQfsik4TOYfIaMKmo+fmc2x3kx5DOypQ95g6IMsM
	 mGPaE2ZtTXhyfTfWeIyaOjHbY2y6mHDF+3QdbrUJa3xRAHU5WOK4UdPEXR8iF/DzdBqPo
	 HIENQc6kuRB+aRxmJO6M3iSrB7qvvmqGgdDM18y5poehobs3wcmFHL2Dtyz7VAEZcxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKqWgUw6PNcBKIfD8HnLEGvSU/JyK1r/nNBswHux0m8=;
	b=tzZupCxaBMGm0nC8JLGBOLDospaFUHstAnzDkKhoNZIf40KYJ3NgXbBxfO553NTWYdBP
	 IB9q+lYt3pcb2BiWfaQ/qwncxwyInFBFWTkXgZe/5awf5hucH5q2lQ8RGO1/7HUn6ny45
	 4wLnappCK3c2q8Y0UvXwR2LZacMc+Rj0/jxgk/47yhEUKNbWDUswFihSRCz7kSQ1OAzE7
	 eS6iTqIIDz3rGWEqxMslvERbr/OKSGIIeDaEGWvKCdjK+sfERxuED5L1y+NS1IZxLyywl
	 fcZp26yIeYCV+V4xHMXNGZevq5qEYltISVdi4f6fXWUQD0zcvAimuSVKPYbq91qf7VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JptbHrh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E0606A31C;
	Wed, 18 Nov 2026 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JptbHrh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962041F000C4;
	Wed, 18 Nov 2026 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035561;
	bh=qKqWgUw6PNcBKIfD8HnLEGvSU/JyK1r/nNBswHux0m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JptbHrh+DA50kwl2Y6Nc4lzhBeKTTZAzO0MBRlqa7yzTRBf+f77QXFnXM2tX/3G2U
	 cXBeUOOZak06Dq//v5mBPMtjM3EHY7YUphgamVXLnfty81e+Fo9zxrVae5CJafu3O/
	 MT1+X3bkRglHKRfHx5nOvXxqOEAFv1PRpNgnHyZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0702/3318] SUNRPC: keep the first error in svc_register()
Date: Wed, 18 Nov 2026 15:22:04 +0100
Message-ID: <20261118150339.428827727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1198,13 +1198,16 @@ int svc_register(const struct svc_serv *
 
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


